import 'package:flutter/material.dart';

class UiSpacing {
  static Widget verticalSpacingTiny() {
    return const SizedBox(
      height: 5,
    );
  }

  static Size screenSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return size;
  }

  static Widget horizontalSpacingTiny() {
    return const SizedBox(
      width: 10,
    );
  }

  static Widget verticalSpacingSmall() {
    return const SizedBox(
      height: 20,
    );
  }

  static Widget verticalSpacingMedium() {
    return const SizedBox(
      height: 30,
    );
  }

  static Widget verticalSpacingSemilarge() {
    return const SizedBox(
      height: 40,
    );
  }

  static Widget verticalSpacingLarge() {
    return const SizedBox(
      height: 70,
    );
  }

  static Widget horizontalSpacingLarge() {
    return const SizedBox(
      width: 70,
    );
  }

  static Widget horizontalSpacingMedium() {
    return const SizedBox(
      width: 70,
    );
  }

  static Widget horizontalSpacingSmall() {
    return const SizedBox(
      width: 20,
    );
  }

  static bool isLargeScreen(BuildContext context) {
    var isLarge = false;
    if (UiSpacing.screenSize(context).width > 600) {
      isLarge = true;
    } else {
      isLarge = false;
    }

    return isLarge;
  }

  static double logoScale(BuildContext context) {
    double? logoSize = UiSpacing.isLargeScreen(context) ? 1 : 1.7;
    return logoSize;
  }
}
