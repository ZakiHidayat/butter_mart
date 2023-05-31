import 'dart:developer';

import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/auth/login_page.dart';
import 'package:butter_mart/ui/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/bm-logo.svg', height: 35),
                  const SizedBox(height: 30),
                  Image.asset('assets/images/motor.png'),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome To',
                    style: blackTextStyle.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Butter Mart Online!',
                    style: blueTextStyle.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Browse your favorite baking supplies\nand get them delivered',
                    textAlign: TextAlign.center,
                    style: blackTextStyle.copyWith(
                      height: 1.36,
                        fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: primaryColor,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(defaultRadius))),
                            onPressed: () {
                              Navigator.of(context).push(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        LoginPage(),
                                  ));
                            },
                            child: Text(
                              'Masuk',
                              style: whiteTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: whiteColor,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius:
                                    BorderRadius.circular(defaultRadius))),
                            onPressed: () {
                              Navigator.of(context).push(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        RegisterPage(),
                                  ));
                            },
                            child: Text(
                              'Saya Baru, Daftarkan Saya',
                              style: blueTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        const SizedBox(height: 15),
                        Text.rich(
                          TextSpan(text: 'Dengan masuk atau mendaftar, Anda menyetujui ',
                              children: [
                                TextSpan(
                                    text: 'Ketentuan Layanan kami',
                                    style: blueTextStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        log('ketentuan');
                                      }),
                                const TextSpan(text: ' Dan '),
                                TextSpan(
                                    text: 'Kebijakan Privasi.',
                                    style: blueTextStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        log('kebijakan');
                                      }),
                              ]),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
