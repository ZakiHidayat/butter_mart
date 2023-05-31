// ignore_for_file: deprecated_member_use

import 'package:butter_mart/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomNav extends StatefulWidget {
  final int index;
  const BottomNav({Key? key, this.index = 0}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  getIndex() {
    if(widget.index > 0) {
      setState(() {
      _selectedIndex = widget.index;
    });
    }
  }
  @override
  void initState() {
    getIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: greyColor.withOpacity(0.20), width: 0.7),
              ),
          ),
          child: NavigationBar(
              height: 60,
              // backgroundColor: Color(0xffEEF3F8),
              backgroundColor: whiteColor,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              animationDuration: const Duration(milliseconds: 700),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/home-icon.svg',
                      color: primaryColor),
                  label: 'Beranda',
                  selectedIcon: SvgPicture.asset('assets/icons/home-icon.svg',
                      color: primaryColor),
                  tooltip: (''),
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/profile-icon.svg',
                      color: primaryColor),
                  label: 'Akun Saya',
                  selectedIcon: SvgPicture.asset(
                      'assets/icons/profile-icon.svg',
                      color: primaryColor),
                  tooltip: (''),
                ),
              ]),
        ));
  }
}
