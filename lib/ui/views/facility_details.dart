import 'dart:ui';

import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:fhmapp/ui/widgets/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/model/directions.dart';
import '../../core/model/facility_model.dart';

class FacilityDetails extends StatelessWidget {
  final Facility facility;
  final LatLng origin;
  final Directions? info;
  const FacilityDetails(this.facility,
      {Key? key, required this.info, required this.origin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/fhmapp.appspot.com/o/facilityTypes%2Fclinic.jpg?alt=media&token=38ea21b7-1409-471d-acbf-030deb9e7bd8',
            fit: BoxFit.fitHeight,
          ),
          InfoAppBar(
            backgroundColor: transparent,
            title: Text(
              facility.name,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: kWhite),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    width: UiSpacing.screenSize(context).width,
                    height: 325,
                    //margin: mainPadding,
                    padding: containerPadding.copyWith(top: 10),
                    decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.8),
                        borderRadius: generalBorderRadius),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(FeatherIcons.map, size: 12),
                                radius: 12),
                            UiSpacing.horizontalSpacingTiny(),
                            Text(info!.totalDistance,
                                style: Theme.of(context).textTheme.bodyText1),
                            const Spacer(),
                            directionButton(context)
                          ],
                        ),
                        UiSpacing.verticalSpacingSmall(),
                        Switcher(facility)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector directionButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(30)),
        child: Text(
          'Get Directions',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: kWhite, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Switcher extends StatefulWidget {
  final Facility facility;
  const Switcher(this.facility, {Key? key}) : super(key: key);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool services = true;
  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.headline5;
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () => setState(() {
                      services = true;
                    }),
                child: Text('Services',
                    style: titleStyle?.copyWith(
                        color: services ? primaryColor : kBlack))),
            UiSpacing.horizontalSpacingSmall(),
            GestureDetector(
                onTap: () => setState(() {
                      services = false;
                    }),
                child: Text('Contact',
                    style: titleStyle?.copyWith(
                        color: services ? kBlack : primaryColor)))
          ],
        ),
        UiSpacing.verticalSpacingTiny(),
        Visibility(
            visible: services ? true : false,
            child: Services(services: widget.facility.services)),
        Visibility(
            visible: services ? false : true,
            child: FacilityContact(facility: widget.facility))
      ],
    );
  }
}

class Services extends StatelessWidget {
  final List services;
  const Services({
    Key? key,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Row(
              children: [
                const CircleAvatar(backgroundColor: grey, radius: 4),
                UiSpacing.horizontalSpacingTiny(),
                Text(services[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: grey)),
              ],
            ),
        separatorBuilder: (context, index) => UiSpacing.verticalSpacingTiny(),
        itemCount: services.length);
  }
}

class FacilityContact extends StatelessWidget {
  const FacilityContact({
    Key? key,
    required this.facility,
  }) : super(key: key);

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            FeatherIcons.user,
            color: primaryColor,
          ),
          UiSpacing.horizontalSpacingTiny(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiSpacing.verticalSpacingTiny(),
              Text(facility.contact?[index].name ?? 'N/A',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: grey)),
              Text(facility.address,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: grey)),
              Text(facility.contact?[index].phone ?? 'N/A',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: grey)),
            ],
          )
        ],
      ),
      separatorBuilder: (context, index) => UiSpacing.verticalSpacingTiny(),
      itemCount: facility.contact!.length,
    );
  }
}
