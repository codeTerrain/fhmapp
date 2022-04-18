import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

import '../widgets/appbars.dart';
import '../widgets/misc.dart';

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      SizedBox(
                        height: 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resource',
                              style: Theme.of(context).textTheme.headline5,
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
                            Text(
                              'Description',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: grey),
                            ),
                            const Spacer(),
                            Text(
                              'Duration: 2hr 30mins',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(color: grey),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.video_library,
                            color: kWhite,
                          ),
                        ),
                      )
                    ],
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
