import 'dart:io';

import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/services/auth_service.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/bottom_nav.dart';
import 'package:butter_mart/ui/pages/onBoarding_page.dart';
import 'package:butter_mart/ui/pages/splash_screen_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await SecureStorage.deleteDataLokal();
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
    requestHeader: true
  ));
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';
 
  final token = await SecureStorage.getToken();
  final isLoggedIn = token != null;

  runApp(
    MyApp(home: isLoggedIn? const BottomNav() : const OnBoardingPage()),
  );
}
// MyApp(home: isLoggedIn? BottomNav() : OnBoardingPage()),
class MyApp extends StatelessWidget {
   MyApp({Key? key, required this.home}) : super(key: key);
   final Widget home;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MaterialApp(
        theme: Platform.isIOS? appThemeIos  :appThemeAndroid,
        home: SplashScreenPage(home),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      }
      ),
    );
  }
}

