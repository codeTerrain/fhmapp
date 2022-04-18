import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../shared/style.dart';

var generalBorderRadius = BorderRadius.circular(10);
const scrollPhysics = ScrollPhysics(
    parent: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()));
var roundedListTileBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15.0),
);

Container programmeTag(BuildContext context,
    {required String text, TextStyle? style, double? margin}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin ?? 12),
    padding: containerPadding.copyWith(top: 4, bottom: 4),
    decoration:
        BoxDecoration(color: grey, borderRadius: BorderRadius.circular(30)),
    child: Text(
      text,
      style: style,
    ),
  );
}

Route createRoute({required Widget page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

// Future<void> animateScroll(int page) async {
//     setState(() => _isScrolling = true);
//     await _pageController.animateToPage(
//       max(min(page, getPagesLength() - 1), 0),
//       duration: Duration(milliseconds: widget.animationDuration),
//       curve: widget.curve,
//     );
//     if (mounted) {
//       setState(() => _isScrolling = false);
//     }
//   }
const containerPadding = EdgeInsets.symmetric(
  horizontal: 15,
);

String formatTime(DateTime dateTime) {
  return timeago.format(dateTime);
}
