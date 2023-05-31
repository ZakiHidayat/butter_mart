import 'dart:math';

import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/models/user.dart';
import 'package:butter_mart/ui/pages/bottom_nav.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:butter_mart/theme/app_theme.dart';

class WelcomeBackPage extends StatefulWidget {
  const WelcomeBackPage({Key? key}) : super(key: key);

  @override
  State<WelcomeBackPage> createState() => _WelcomeBackPage();
}

class _WelcomeBackPage extends State<WelcomeBackPage> {
   ConfettiController? confettiController;
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    SecureStorage.getUser().then((value) {
      setState(() {
        isLoading = false;
        user = value;
      });

    });
    confettiController!.play();
    super.initState();
  }

  @override
  void dispose() {
    confettiController?.dispose();
    super.dispose();
  }

   Path drawStar(Size size) {
     // Method to convert degree to radians
     double degToRad(double deg) => deg * (pi / 180.0);

     const numberOfPoints = 5;
     final halfWidth = size.width / 2;
     final externalRadius = halfWidth;
     final internalRadius = halfWidth / 2.5;
     final degreesPerStep = degToRad(360 / numberOfPoints);
     final halfDegreesPerStep = degreesPerStep / 2;
     final path = Path();
     final fullAngle = degToRad(360);
     path.moveTo(size.width, halfWidth);

     for (double step = 0; step < fullAngle; step += degreesPerStep) {
       path.lineTo(halfWidth + externalRadius * cos(step),
           halfWidth + externalRadius * sin(step));
       path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
           halfWidth + internalRadius * sin(step + halfDegreesPerStep));
     }
     path.close();
     return path;
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius))),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const BottomNav(),
                ),
                    (_) => false);
          },
          child: Text(
            'Lanjut Ke Halaman Utama',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Stack(
          children: [
            Center(
              child: ConfettiWidget(
                confettiController: confettiController!,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                // shouldLoop: true,
                colors: const [
                  Color(0xff2E68A2),
                  Color(0xff64A1B6),
                  Color(0xffF3C06B),
                ], // manually specify the colors to be used
                createParticlePath: drawStar,
              ),
            ),
            Center(
              child: Text.rich(
                TextSpan(
                    text: '" Selamat Datang Kembali\nDi Aplikasi ',
                    style: blackTextStyle.copyWith(
                        fontSize: 22, fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(
                          text: 'Butter Mart Online\n',
                          style: blueTextStyle.copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: '${user?.name} "',
                        style: secondaryTextStyle.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
