import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import 'course.dart';

class ELearning extends StatelessWidget {
  const ELearning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: scrollPhysics,
      slivers: [
        const SearchAppBar(),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 30,
        //   ),
        //   sliver:
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                elevation: 0,
                color: kWhite,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: UiSpacing.screenSize(context).width,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: kBlack,
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/dashboard/dummyFamily.png',
                                  ),
                                  fit: BoxFit.cover)),
                          height: 120,
                          width: 130,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                //mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Resource',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  UiSpacing.verticalSpacingTiny(),
                                  programmeTag(
                                    context,
                                    text: 'Adolescent Health',
                                    margin: 0,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            color: kWhite,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  UiSpacing.verticalSpacingTiny(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Description',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(color: grey),
                                      ),
                                    ),
                                  ),
                                  // UiSpacing.verticalSpacingTiny(),
                                  //(),
                                  Text(
                                    'Duration: 2hr 30mins',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(color: grey),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor,
                                child: IconButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Course(),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.video_library,
                                    color: kWhite,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: 4,
          ),
          //  ),
        ),
      ],
    );
  }
}
