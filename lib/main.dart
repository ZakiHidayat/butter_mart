import 'dart:io';

import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/bottom_nav.dart';
import 'package:butter_mart/ui/pages/onBoarding_page.dart';
import 'package:butter_mart/ui/pages/splash_screen_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await SecureStorage.deleteDataLokal();
  final token = await SecureStorage.getToken();
  final isLoggedIn = token != null;

  runApp(
    MyApp(home: isLoggedIn? BottomNav() : OnBoardingPage()),
  );
}
// MyApp(home: isLoggedIn? BottomNav() : OnBoardingPage()),
class MyApp extends StatelessWidget {
   MyApp({Key? key, required this.home}) : super(key: key);
   final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Platform.isIOS? appThemeIos  :appThemeAndroid,
      home: SplashScreenPage(home),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
      );
    }
    );
  }
}

