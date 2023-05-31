import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const primaryColor = Color(0xff2E68A2);
const secondaryColor = Color(0xffF3C06B);
const whiteColor = Color(0xffFFFFFF);
const greyColor = Color.fromARGB(255, 129, 129, 129);
const blackColor = Color(0xff000000);

const whiteTextStyle = TextStyle(color: whiteColor);

const blackTextStyle = TextStyle(color: blackColor);

const greyTextStyle = TextStyle(color: greyColor);

const blueTextStyle = TextStyle(color: primaryColor);

const secondaryTextStyle = TextStyle(color: secondaryColor);

const numberTextStyle = TextStyle(
  fontFamily: 'NumbersClaimcheck',
  letterSpacing: 0.6,
);

const double defaultRadius = 16;
const double defaultPadding = 20;

final appThemeIos = ThemeData(
  fontFamily: 'Raleway',
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.all(const TextStyle(
        letterSpacing: 0.6, color: primaryColor, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.orange.shade100,
    indicatorColor: primaryColor.withOpacity(0.25),
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    color: Colors.deepPurpleAccent,
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      //<-- SEE HERE
      // Status bar color
      statusBarColor: Colors.white,
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
    iconTheme: IconThemeData(color: Colors.black),
    color: Colors.deepPurpleAccent,
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      //<-- SEE HERE
      // Status bar color
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

