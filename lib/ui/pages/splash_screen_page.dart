import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage(this.home);
  final Widget home;

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
        'assets/icons/bm-logo.json',
            height: 200,
            width: 250,
        controller: _controller,
        onLoaded: (compos) {
          _controller
          ..duration = const Duration(seconds: 2)
          ..forward().then((value){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget.home,), (_) => false);
          });
        }
      ),
      ),
    );
  }
}
