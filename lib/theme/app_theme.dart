import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const primaryColor = Color(0xff2E68A2);
const secondaryColor = Color(0xffF3C06B);
const whiteColor = Color(0xffFFFFFF);
const greyColor = Color(0xffAAAAAA);
const blackColor = Color(0xff000000);

final whiteTextStyle = const TextStyle(color: whiteColor);

final blackTextStyle = const TextStyle(color: blackColor);

final greyTextStyle = const TextStyle(color: greyColor);

final blueTextStyle = const TextStyle(color: primaryColor);

final secondaryTextStyle = const TextStyle(color: secondaryColor);

final numberTextStyle = const TextStyle(
  fontFamily: 'NumbersClaimcheck',
  letterSpacing: 0.6,
);

const double defaultRadius = 16;
const double defaultPadding = 24;

final appThemeIos = ThemeData(
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.all(const TextStyle(
        letterSpacing: 0.6, color: primaryColor, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.orange.shade100,
    indicatorColor: primaryColor.withOpacity(0.25),
  ),
  fontFamily: 'Raleway',
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    color: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      //<-- SEE HERE
      // Status bar color
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

final appThemeAndroid = ThemeData(
  fontFamily: 'Raleway',
  navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          letterSpacing: 0.6,
          color: primaryColor,
          fontWeight: FontWeight.w500))),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    color: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      //<-- SEE HERE
      // Status bar color
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);
