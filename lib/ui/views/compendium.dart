import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/model/directions.dart';
import '../../core/model/facility_model.dart';
import '../../core/services/map_router.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/spacing.dart';
import '../shared/style.dart';
import '../widgets/misc.dart';
import 'facility_details.dart';

class Compendium extends StatefulWidget {
  const Compendium({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CompendiumState();
  }
}

class _CompendiumState extends State<Compendium> {
  late Stream<List<Facility>> _facilitiesStream;
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  final Respository _respository = locator<Respository>();
  String? filter;

  @override
  void initState() {
    super.initState();
    _facilitiesStream = _respository.getFacilities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Facility>>(
        stream: _facilitiesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }

          return Stack(
            children: [
              FacilitiesMap(
                facilities: snapshot.data!,
                mapController: _mapController,
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 100),
              //   child: StoreCarousel(
              //     mapController: _mapController,
              //     facilities: snapshot.data!,
              //   ),
              // ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      drawerCaller(context),
                      UiSpacing.horizontalSpacingTiny(),
                      Expanded(
                        child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: generalBorderRadius),
                            child: TypeAheadFormField<Facility>(
                                // hideOnEmpty: true,
                                minCharsForSuggestions: 1,
                                onSuggestionSelected:
                                    (Facility facility) async {
                                  final controller =
                                      await _mapController.future;
                                  await controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          facility.location.latitude,
                                          facility.location.longitude,
                                        ),
                                        zoom: 16,
                                      ),
                                    ),
                                  );
                                },
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      prefixIcon: filter == null || filter == ""
                                          ? const ImageIcon(
                                              AssetImage(
                                                  'assets/images/general/search.png'),
                                              color: primaryColor,
                                              size: 50,
                                            )
                                          : InkWell(
                                              child: const Icon(
                                                Icons.clear,
                                                color: primaryColor,
                                              ),
                                              onTap: () {
                                                _searchController.clear();
                                              },
                                            ),
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(height: 2),
                                    )),
                                itemBuilder: (context, Facility facility) =>
                                    ListTile(
                                      title: Text(facility.name),
                                      subtitle: Text(facility.address),
                                    ),
                                suggestionsCallback: (pattern) => snapshot.data!
                                    .where((facility) => facility.name
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase())))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key? key,
    required this.facility,
    required this.mapController,
  }) : super(key: key);

  final Facility facility;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.facility.name),
      subtitle: Text(widget.facility.address),
      leading: SizedBox(
        width: 100,
        height: 100,
        child: _placePhotoUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                child: Image.network(_placePhotoUrl, fit: BoxFit.cover),
              )
            : Container(),
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.facility.location.latitude,
                widget.facility.location.longitude,
              ),
              zoom: 16,
            ),
          ),
        );
      },
    );
  }
}

class FacilitiesMap extends StatefulWidget {
  const FacilitiesMap({
    Key? key,
    required this.facilities,
    required this.mapController,
  }) : super(key: key);

  final List<Facility> facilities;
  final Completer<GoogleMapController> mapController;

  @override
  State<FacilitiesMap> createState() => _FacilitiesMapState();
}

class _FacilitiesMapState extends State<FacilitiesMap> {
  static LatLng? _initialPosition;
  Directions? _info;

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue

      _initialPosition = await Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //denied permissions
        _initialPosition =
            await Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //denied permissions permanently
      _initialPosition = await Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

//permissions granted
    //currentPosition = await Geolocator.getCurrentPosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Center(
            child: Text(
              'loading, please wait..',
              style: Theme.of(context).textTheme.headline3,
            ),
          )
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition!,
                  zoom: 14,
                ),
                myLocationEnabled: true,
                markers: widget.facilities
                    .map((facility) => Marker(
                          markerId: MarkerId(facility.placeId),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          position: LatLng(
                            facility.location.latitude,
                            facility.location.longitude,
                          ),
                          infoWindow: InfoWindow(
                            title: facility.name,
                            snippet: facility.address,
                          ),
                          onTap: () {
                            _getDirections(facility.location);
                            // Navigator.push<void>(
                            //   context,
                            //   MaterialPageRoute<void>(
                            //     builder: (BuildContext context) =>
                            //         FacilityDetails(facility,
                            //             origin: _initialPosition!, info: _info),
                            //   ),
                            // );
                          },
                        ))
                    .toSet(),
                myLocationButtonEnabled: true,
                onMapCreated: (mapController) {
                  widget.mapController.complete(mapController);
                },
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: primaryColor,
                      width: 5,
                      points: _info!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
              ),
              if (_info != null)
                Positioned(
                  bottom: 20.0,
                  left: 10.0,
                  child: Container(
                    height: 40,
                    padding: containerPadding,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: generalBorderRadius,
                    ),
                    child: Center(
                      child: Text(
                          '${_info?.totalDistance}, ${_info?.totalDuration}',
                          style: Theme.of(context).textTheme.headline4),
                    ),
                  ),
                ),
              // FloatingActionButton(onPressed: () => _getDirections())
            ],
          );
  }

  _getDirections(GeoPoint destination) async {
    final directions = await DirectionsRepository().getDirections(
        origin: _initialPosition!,
        destination: LatLng(destination.latitude, destination.longitude));
    setState(() => _info = directions);
  }
}
