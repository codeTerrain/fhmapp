import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/static_lists.dart';
import 'package:fhmapp/ui/views/uploader_fac.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/events.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/style.dart';
import '../viewmodels/event_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/appbars.dart';
import '../widgets/cached_image.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';

class EventDetails extends StatelessWidget {
  Event event;
  EventDetails(this.event, {Key? key}) : super(key: key);

  final Respository _respository = locator<Respository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SingleChildScrollView(
        physics: scrollPhysics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CachedImage(
                  image: event.image,
                  margin: EdgeInsets.zero,
                  borderRadius1: BorderRadius.zero,
                  borderRadius2: BorderRadius.zero,
                ),
                // SizedBox(
                //     width: UiSpacing.screenSize(context).width,
                //     height: 200,
                //     child: Image.asset(
                //       'assets/images/dashboard/dummyFamily.png',
                //       fit: BoxFit.cover,
                //     )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  color: kWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              //maxLines: 5,
                              //overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1.2,
                              text: TextSpan(
                                text: eventDateFormat(event.startDate) + '\n',
                                //  text: 'THU, 13th JUN, 2022\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: secondary2),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: event.name + '\n',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  TextSpan(
                                    text: event.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: grey),
                                  ),
                                ],
                              ),
                            ),
                            UiSpacing.verticalSpacingSmall(),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                Text(
                                  event.location ?? 'N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.people_alt_outlined),
                                Text(
                                  'Organized By: ${event.organizedBy ?? 'N/A'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      UiSpacing.verticalSpacingSmall(),
                      StreamBuilder<List<Event>>(
                          stream:
                              _respository.getEventRegisteredUsers(event.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData) {
                              return const Center(child: Text('Loading...'));
                            }
                            List<Event> selectedEvent = snapshot.data!;

                            return ViewModelBuilder<EventViewModel>.reactive(
                                viewModelBuilder: () => EventViewModel(),
                                builder: (context, eventModel, child) {
                                  return ButtonWrapper(
                                      color: eventModel.isBusy
                                          ? secondary1
                                          : ((selectedEvent[0]
                                                  .registeredUsers
                                                  .contains('emma@gmail.com')
                                              ? secondary1
                                              : primaryColor)),
                                      buttonText: eventModel.isBusy
                                          ? 'Un-register Me'
                                          : ((selectedEvent[0]
                                                  .registeredUsers
                                                  .contains('emma@gmail.com')
                                              ? 'Un-register Me'
                                              : 'Register Me')),
                                      onPressed: () =>
                                          eventModel.updateEventAttendees(
                                              event: selectedEvent[0])

                                      // Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute<void>(
                                      //         builder: (BuildContext context) =>
                                      //             const Upl(),
                                      //       ),
                                      //     )
                                      );
                                });
                          }),
                    ],
                  ),
                ),
              ],
            ),
            UiSpacing.verticalSpacingMedium(),
            Padding(
              padding: containerPadding,
              child: Text(
                'Similar Events',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: kBlack),
              ),
            ),
            StreamBuilder<List<Event>>(
                stream: _respository.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  List<Event> events = snapshot.data!
                      .where((element) =>
                          element.startDate.isAfter(DateTime.now()))
                      .toList();
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          UiSpacing.horizontalSpacingSmall(),
                      //  shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: scrollPhysics,
                      itemCount: events.length < 5 ? events.length : 5,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                            child: ClipRRect(
                              borderRadius: generalBorderRadius,
                              child: Stack(
                                key: ValueKey(events[index].id),
                                alignment: Alignment.bottomCenter,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    height: 200,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: CachedImage(
                                        image: events[index].image,
                                        margin: EdgeInsets.zero,
                                      ),
                                      //  Image.asset(
                                      //   programList[index].image,
                                      //   width: 200,
                                      //   height: 130,
                                      //   fit: BoxFit.fitWidth,
                                      // ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: mainPadding,
                                      // height: 50,
                                      decoration: BoxDecoration(
                                        color: kBlack.withAlpha(180),
                                      ),
                                      // borderRadius: const BorderRadius.vertical(
                                      //     bottom: Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventDateFormat(event.startDate),
                                            //  text: 'THU, 13th JUN, 2022\n',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: kWhite),
                                          ),
                                          Text(
                                            events[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                ?.copyWith(color: kWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        EventDetails(events[index]),
                                  ),
                                ));
                      },
                    ),
                  );
                }),
            UiSpacing.verticalSpacingMedium(),

            //),
          ],
        ),
      ),
    );
  }
}
