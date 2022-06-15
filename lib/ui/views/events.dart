import 'package:fhmapp/core/model/events.dart';
import 'package:fhmapp/core/model/program_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/search.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<String> filterTag = ['Tags:'];

  @override
  void initState() {
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
        appBar: InfoAppBar(
          title: Text(
            'Events',
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: drawerCaller(context),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Padding(
                  padding: mainPadding,
                  child: search(context, hintText: 'Search'))),
        ),
        body: Padding(
            padding: mainPadding,
            child: SingleChildScrollView(
              physics: scrollPhysics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiSpacing.verticalSpacingMedium(),
                  Text(
                    'Categories',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: kBlack),
                  ),
                  SizedBox(
                    height: 193,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          UiSpacing.horizontalSpacingSmall(),
                      //  shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: scrollPhysics,
                      itemCount: programList.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          child: Stack(
                            key: ValueKey(programList[index].id),
                            alignment: Alignment.bottomCenter,
                            children: [
                              FittedBox(
                                child: Image.asset(
                                  programList[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: mainPadding,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: programList[index].isSelected
                                          ? primaryColor.withAlpha(221)
                                          : grey.withAlpha(221),
                                      borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(10))),
                                  child: Text(
                                    programList[index].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(color: kWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              programList[index].isSelected =
                                  !programList[index].isSelected;
                              if (programList[index].isSelected) {
                                filterTag.add(programList[index].id);
                              } else {
                                filterTag.remove(programList[index].id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  UiSpacing.verticalSpacingSemilarge(),
                  Text(
                    (filterTag.length == 1 || filterTag.length == 5)
                        ? 'All'
                        : filterTag.toString(),
                    style: (filterTag.length == 1 || filterTag.length == 5)
                        ? Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: kBlack)
                        : Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: kBlack),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        for (var x in filterTag) {
                          if (eventList[index].programmeId.contains(x) ||
                              filterTag.length == 1) {
                            return EventCard(event: eventList[index]);
                          }
                        }
                        return const SizedBox();
                      },
                      itemCount: eventList.length)
                ],
              ),
            )));
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
              SizedBox(
                width: UiSpacing.screenSize(context).width,
                height: 100,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: event.image == null
                      ? const SizedBox()
                      : Image.asset(
                          event.image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.2,
                  text: TextSpan(
                    text: event.startDate.toString() + '\n',
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
              const ButtonWrapper(
                buttonText: 'Viev Event Info',
                trailing: ImageIcon(
                  AssetImage('assets/images/general/doubleArrow.png'),
                  size: 20,
                  color: kWhite,
                ),
                onPressed: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
