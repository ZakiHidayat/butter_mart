import 'package:butter_mart/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Widget? _child;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: greyColor.withOpacity(0.30), width: 0.7))),
          child: NavigationBar(
              height: 60,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              animationDuration: const Duration(milliseconds: 800),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              backgroundColor: whiteColor,
              destinations: [
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/home-icon.svg',
                      color: primaryColor),
                  label: 'Home',
                  selectedIcon: SvgPicture.asset('assets/icons/home-icon.svg',
                      color: primaryColor),
                ),
                NavigationDestination(
                  icon: SvgPicture.asset('assets/icons/profile-icon.svg',
                      color: primaryColor),
                  label: 'Profile',
                  selectedIcon: SvgPicture.asset(
                      'assets/icons/profile-icon.svg',
                      color: primaryColor),
                ),
              ]),
        ));
  }
}
