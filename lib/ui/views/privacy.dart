import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: InfoAppBar(
          title: Text(
            'Privacy & Policy',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SingleChildScrollView(
          physics: scrollPhysics,
          child: Padding(
            padding: mainPadding,
            child: Column(
              children: [
                UiSpacing.verticalSpacingMedium(),
                Container(
                  padding: containerPadding.copyWith(top: 10, bottom: 10),
                  decoration: boxDecoration,
                  child: Text(
                    privacyPolicy,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                UiSpacing.verticalSpacingMedium(),
              ],
            ),
          ),
        ));
  }
}
