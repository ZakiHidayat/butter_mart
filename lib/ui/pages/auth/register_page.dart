import 'package:butter_mart/services/auth_service.dart';
import 'package:butter_mart/ui/pages/home_page.dart';
import 'package:butter_mart/ui/pages/onBoarding_page.dart';
import 'package:butter_mart/ui/pages/welcome_pages/welcome_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:butter_mart/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaimon/gaimon.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  final _emailC = TextEditingController();
  final _no_telpC = TextEditingController();
  final _alamatC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirm_passwordC = TextEditingController();

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
              minimumSize: Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius))),
          onPressed: () async {

            if (_formKey.currentState!.validate()) {
              setState(() {
                isLoading = true;
              });

              try {
                final register = await AuthService.register(
                    name: _namaC.text,
                    email: _emailC.text,
                    no_telp: _no_telpC.text,
                    alamat: _alamatC.text,
                    password: _passwordC.text,
                    confirm_password: _confirm_passwordC.text);
                setState(() {
                  isLoading = false;
                });
                if (register.statusCode == 200 && register.data['status'] == true) {
                  Gaimon.heavy();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WelcomePage(),
                      ),
                          (_) => false);
                } else {
                  Gaimon.error();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(
                        '${register.data['message']}',
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      backgroundColor: primaryColor,
                    ));
                }
              } on DioError catch (e) {
                setState(() {
                  isLoading = false;
                });
                Gaimon.error();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(
                      '${e.response?.data['message']}',
                      style: whiteTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    backgroundColor: primaryColor,
                  ));
              }
            }
          },
          child: Text(
            'Daftarkan Sekarang!',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        OnBoardingPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(-1.0, 0.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);

                      // Transisi saat kembali ke halaman sebelumnya (mendorong dari kiri ke kanan)
                      var slideAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: slideAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              icon: SvgPicture.asset('assets/icons/arrow-left.svg')),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Daftar',
                          style: blackTextStyle.copyWith(
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                          )),
                    ),
                    SizedBox(height: 26),
                    //Nama
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      controller: _namaC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: 'Jhon doe',
                          labelText: 'Nama',
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                    SizedBox(height: 26),
                    //Email
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: 'jhondoe@gmail.com',
                          labelText: 'Email',
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                    SizedBox(height: 26),
                    //No Telp
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.phone,
                      controller: _no_telpC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: '0812345678',
                          labelText: 'No Telpon',
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                    SizedBox(height: 26),
                    //Alamat
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      controller: _alamatC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: 'Masukkan Alamat Lengkap Anda',
                          labelText: 'Alamat Lengkap',
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                    SizedBox(height: 26),
                    //Password
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      obscureText: _obscurePass,
                      controller: _passwordC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: 'Masukkan Kata Sandi',
                          labelText: 'Password',
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscurePass = !_obscurePass;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                  _obscurePass
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: _obscurePass
                                      ? Colors.grey
                                      : primaryColor),
                            ),
                          ),
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                    SizedBox(height: 26),
                    //Confirm Password
                    TextFormField(
                      cursorColor: primaryColor,
                      controller: _confirm_passwordC,
                      obscureText: _obscureConfirmPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Wajib diisi';
                        }
                      },
                      style: blackTextStyle.copyWith(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: 'Masukkan Ulang Kata Sandi',
                          labelText: 'Confirm Password',
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPass = !_obscureConfirmPass;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                  _obscureConfirmPass
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: _obscureConfirmPass
                                      ? Colors.grey
                                      : primaryColor),
                            ),
                          ),
                          hintStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          labelStyle: greyTextStyle.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 2.0,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 23, top: 20, bottom: 20)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
