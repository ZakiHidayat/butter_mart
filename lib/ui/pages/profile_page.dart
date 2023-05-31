// ignore_for_file: deprecated_member_use

import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/services/auth_service.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/cart_page.dart';
import 'package:butter_mart/ui/pages/onBoarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    SecureStorage.getUser().then((value) {
      setState(() {
        user = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F6),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const Gap(60),
                Stack(
                  children: [
                    Container(
                      height: 295,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1, color: Colors.grey.withOpacity(0.23)),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(55),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  '${user?.name}',
                                  style: blackTextStyle.copyWith(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Text(
                              '${user?.email}',
                              style: greyTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const Gap(25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(SwipeablePageRoute(
                                      canOnlySwipeFromEdge: true,
                                      builder: (BuildContext context) =>
                                          const CartPage(
                                        isFromProfile: true,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(defaultRadius),
                                      shape: BoxShape.rectangle,
                                      color: primaryColor,
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/icons/shopping-cart-bold.svg',
                                        color: whiteColor),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(defaultRadius),
                                    shape: BoxShape.rectangle,
                                    color: primaryColor,
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/icons/edit-icon-bold.svg',
                                      color: whiteColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text('Logout'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('tidak')),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      final issuccesslogout =
                                                          await AuthService
                                                              .logout();

                                                      if (issuccesslogout) {
                                                        await SecureStorage
                                                            .deleteDataLokal();
                                                        if (!mounted) return;
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const OnBoardingPage()),
                                                            (route) => false);
                                                      } else {
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        if (!mounted) return;
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              SnackBar(
                                                            backgroundColor:
                                                                primaryColor,
                                                            content: Text(
                                                              'Gagal Logout',
                                                              style: whiteTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ));
                                                      }
                                                    },
                                                    child: Text('Ya')),
                                              ],
                                            ));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    padding: const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(defaultRadius),
                                      shape: BoxShape.rectangle,
                                      color: primaryColor,
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/icons/logout-icon.svg',
                                        color: whiteColor),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(25)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      right: 30,
                      child: AdvancedAvatar(
                        decoration: BoxDecoration(
                            color: const Color(0xffEEF3F8),
                            border: Border.all(
                                width: 1,
                                color: primaryColor.withOpacity(0.28)),
                            borderRadius: BorderRadius.circular(500),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xffF2F2F6),
                                spreadRadius: 10,
                              )
                            ]),
                        name: user?.name,
                        image: NetworkImage('${user?.avatar}'),
                        style: blueTextStyle.copyWith(fontSize: 28),
                        size: MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width +
                            90,
                      ),
                    ),
                  ],
                ),
                const Gap(15),
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.23)),
                  ),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor Telepon :',
                              style: blueTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const Gap(10),
                            Text(
                              '${user?.noTelp}',
                              style: blackTextStyle.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        //Line
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.14),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat Tujuan :',
                              style: blueTextStyle.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const Gap(10),
                            Text(
                              '${user?.alamat}',
                              style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
    );
  }
}
