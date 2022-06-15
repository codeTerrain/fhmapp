import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../shared/routes.dart';
import '../shared/spacing.dart';
import '../shared/style.dart';
import 'custom_textfield.dart';
import 'drawer.dart';

var generalBorderRadius = BorderRadius.circular(10);

const scrollPhysics = ScrollPhysics(
    parent: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()));

Icon phoneIcon = Icon(
  Icons.phone_iphone,
  color: transGrey,
);
var noProfile = Container(
    height: 90,
    width: 90,
    decoration: BoxDecoration(
        color: kWhite,
        shape: BoxShape.circle,
        border: Border.all(color: primaryColor, width: 2)),
    child: const Icon(
      Icons.person,
      size: 40,
    ));

var roundedListTileBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(15.0),
);

const mainPadding = EdgeInsets.only(left: 15, right: 18);

var boxDecoration =
    BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10));

Container drawerCaller(BuildContext context) {
  return Container(
    width: 50,
    height: 50,
    child: IconButton(
      onPressed: () => showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          isScrollControlled: true,
          context: context,
          builder: (context) => const CustomDrawer()),
      icon: Image.asset('assets/images/general/drawerIcon.png'),
      color: primaryColor,
    ),
    decoration: boxDecoration,
  );
}

Container newPostCaller(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    width: 50,
    height: 50,
    child: IconButton(
      onPressed: () => Navigator.pushNamed(context, Routes.createPost),
      icon: Image.asset('assets/images/dashboard/newPost.png'),
      color: primaryColor,
    ),
    decoration: boxDecoration,
  );
}

const circularProgressIndicator = SliverToBoxAdapter(
  child: Center(
      child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: primaryColor,
          ))),
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

String getChatRoomId(
  String id1,
  String id2,
) {
  if (id1.substring(0, 1).codeUnitAt(0) > id2.substring(0, 1).codeUnitAt(0)) {
    return id2 + "_" + id1;
  } else {
    return id1 + "_" + id2;
  }
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

dobSelector(
    {String hintText = 'Select Date of Birth',
    required BuildContext context,
    required TextEditingController controller,
    required onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: CustomTextField(
        enabled: false,
        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        width: UiSpacing.screenSize(context).width,
        prefixIcon: Icon(
          Icons.date_range,
          color: transGrey,
        ),
        controller: controller,
        hintText: hintText),
  );
}

Future<DateTime?> datePicker(BuildContext context) {
  return showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: kWhite,
            ),
            dialogBackgroundColor: kWhite,
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}
