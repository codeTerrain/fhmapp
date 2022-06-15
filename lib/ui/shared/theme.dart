import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    backgroundColor: kWhite,
    scaffoldBackgroundColor: scaffoldColor,
    textTheme: TextTheme(
      bodyText1: const TextStyle(
          color: kBlack,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Avenir'),
      bodyText2: TextStyle(
          color: transGrey,
          fontWeight: FontWeight.bold,
          fontSize: UIFontSize.fontSizeSmall,
          fontFamily: 'Avenir'),
      headline1: const TextStyle(
          color: primaryColor,
          fontSize: 30.0,
          fontWeight: FontWeight.w900,
          fontFamily: 'Avenir'),
      headline5: const TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir'),
      headline3: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w900,
          fontSize: 15,
          fontFamily: 'Avenir'),
      button: const TextStyle(color: kWhite),
      headline6: const TextStyle(
          color: kWhite,
          fontWeight: FontWeight.w600,
          fontSize: 40,
          fontFamily: 'Avenir'),
      headline4: const TextStyle(
          color: kWhite,
          fontWeight: FontWeight.normal,
          fontSize: 13,
          fontFamily: 'Avenir'),
      subtitle2: const TextStyle(
          color: primaryColor, fontSize: 25, fontFamily: 'Avenir'),
    ),
    iconTheme: IconThemeData(color: Colors.grey[500]));
