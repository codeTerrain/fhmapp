import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:fhmapp/core/model/events.dart';
import 'package:fhmapp/core/model/program_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/views/event_details.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/static_lists.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/appbars.dart';
import '../widgets/cached_image.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/search.dart';
import 'create_event.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String? _filter;

  final TextEditingController _searchController = TextEditingController();

  final Respository _respository = locator<Respository>();

  String? _selectedTag;
  int? _selectedIndex;

  @override
  void initState() {
    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    for (Program program in programList) {
      setState(() {
        program.isSelected = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: mainPadding,
      child: CustomScrollView(
        physics: scrollPhysics,
        //crossAxisAlignment: CrossAxisAlignment.start,
        slivers: [
          SliverInfoAppBar(
            titleSpacing: 0,
            title: Text(
              'Events',
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: ViewModelBuilder<ProfileViewModel>.reactive(
                viewModelBuilder: () => ProfileViewModel(),
                onModelReady: (model) => model.getUserInfo(),
                builder: (context, model, child) {
                  if (model.isBusy) {
                    return const SizedBox();
                  }

                  return (model.user.fhmappAdminFor != null &&
                          model.user.fhmappAdminFor!.isNotEmpty)
                      ? newPostCaller(
                          context,
                          model.user.fhmappAdminFor,
                          CreateEvent(
                              fhmappAdminFor: model.user.fhmappAdminFor))
                      : const SizedBox();
                }),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20.0),
                child: search(context,
                    hintText: 'Search', controller: _searchController)),
          ),
          SliverToBoxAdapter(
            child: UiSpacing.verticalSpacingMedium(),
          ),
          SliverToBoxAdapter(
            child: Text(
              'Categories',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: kBlack),
            ),
          ),
          SliverToBoxAdapter(child: _buildChoiceChips()),
          SliverToBoxAdapter(child: UiSpacing.verticalSpacingSmall()),
          StreamBuilder<List<Event>>(
              stream: _respository.getEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(child: Text('Error: ${snapshot.error}')));
                }
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('Loading...')));
                }
                List<Event> events = snapshot.data!
                    .where((event) => event.startDate.isAfter(DateTime.now()))
                    .toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if ((_filter == null ||
                            events[index]
                                .description!
                                .toLowerCase()
                                .contains(_filter!.toLowerCase()) ||
                            _filter == null ||
                            events[index]
                                .programmeTag
                                .toLowerCase()
                                .contains(_filter!.toLowerCase())) &&
                        (_selectedTag == null ||
                            events[index]
                                .programmeTag
                                .toLowerCase()
                                .contains(_selectedTag!.toLowerCase()))) {
                      return EventCard(event: events[index]);
                    }

                    return const SizedBox();
                  }, childCount: events.length),
                );
              })
        ],
      ),
    ));
  }

  Widget _buildChoiceChips() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        separatorBuilder: (context, index) => UiSpacing.horizontalSpacingTiny(),
        physics: scrollPhysics,
        scrollDirection: Axis.horizontal,
        itemCount: programList.length,
        itemBuilder: (BuildContext context, int index) {
          return ChoiceChip(
            label: Text(programList[index].name),
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            selected: _selectedIndex == index,
            selectedColor: secondary1,
            onSelected: (bool selected) {
              setState(() {
                _selectedIndex = selected ? index : null;

                _selectedTag =
                    _selectedIndex == null ? null : programList[index].id;
              });
            },
            backgroundColor: kWhite,
            shape: RoundedRectangleBorder(borderRadius: generalBorderRadius),
            labelStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(color: kBlack),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          color: kWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: generalBorderRadius,
                  child: CachedImage(image: event.image)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.2,
                  text: TextSpan(
                    text: eventDateFormat(event.startDate) + '\n',

                    //formatTime(event.startDate!) + '\n',
                    //  text: 'THU, 13th JUN, 2022\n',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.normal, color: grey),
                    children: <TextSpan>[
                      TextSpan(
                        text: event.name + '\n',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      TextSpan(
                        text: event.description,
                      ),
                    ],
                  ),
                ),
              ),
              UiSpacing.verticalSpacingSmall(),
              ButtonWrapper(
                buttonText: 'Viev Event Info',
                trailing: const ImageIcon(
                  AssetImage('assets/images/general/doubleArrow.png'),
                  size: 20,
                  color: kWhite,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EventDetails(event),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
