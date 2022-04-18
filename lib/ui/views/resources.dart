import 'package:fhmapp/ui/shared/static_lists.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../shared/style.dart';
import '../widgets/misc.dart';

class Resources extends StatelessWidget {
  final String category;
  const Resources({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          InfoAppBar(
            title: Text(
              'Resources',
              style: Theme.of(context).textTheme.headline5,
            ),
            subTitle: Text(
              programs[category]!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: primaryColor),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        shape: roundedListTileBorder,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        // contentPadding: ,
                        tileColor: kWhite,
                        leading: Image.asset(
                          'assets/images/logos/ghs_logo.png',
                          scale: 2,
                        ),
                        title: Text(
                          'Resource $index',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: grey),
                        ),
                        trailing: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            constraints: const BoxConstraints.expand(width: 55),
                            // width: 50,
                            // height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  FeatherIcons.download,
                                  color: kWhite,
                                ),
                                Text(
                                  'jpg',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(color: kWhite),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        onTap: null,
                      ));
                }),
              ))
        ],
      ),
    );
  }
}
