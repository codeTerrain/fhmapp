import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 20, 154, 50);
const Color secondary1 = Color.fromARGB(255, 254, 203, 46);
const Color secondary2 = Color.fromARGB(255, 250, 7, 19);
const Color grey = Color.fromARGB(255, 112, 112, 112);
Color transGrey = grey.withOpacity(0.3);
Color extraGrey = grey.withOpacity(0.1);
const Color scaffoldColor = Color.fromARGB(255, 239, 247, 241);

const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color transparent = Colors.transparent;

class UIFontSize {
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 18.0;
  static const double fontSizeLarge = 24.0;
}

class UITextStyle {
  static const TextStyle textStyleLight =
      TextStyle(fontWeight: FontWeight.w100, fontStyle: FontStyle.italic);
}
