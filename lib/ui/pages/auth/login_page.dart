import 'package:butter_mart/services/auth_service.dart';
import 'package:butter_mart/ui/pages/onBoarding_page.dart';
import 'package:butter_mart/ui/pages/welcome_pages/welcome_back_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaimon/gaimon.dart';

import '../../../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

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
                final isSuccess = await AuthService.login(
                    email: _emailC.text, password: _passwordC.text);
                setState(() {
                  isLoading = false;
                });
                if (isSuccess) {
                  Gaimon.heavy();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WelcomeBackPage(),
                      ),
                      (_) => false);
                } else {
                  Gaimon.error();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          'Login Gagal',
                          style: whiteTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    );
                }
              } on DioError catch (e) {
                setState(() {
                  isLoading = false;
                });
                Gaimon.error();
                String error = "";
                if (e.response != null) {
                  debugPrint(e.response?.data.toString());
                  error = e.response?.data["message"];
                } else {
                  error = e.message.toString();
                }
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      backgroundColor: primaryColor,
                    ),
                  );
              }
            }
          },
          child: Text(
            'Masuk',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
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
            icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Masuk',
                            style: blackTextStyle.copyWith(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                            )),
                        SizedBox(height: 26),
                        //Email
                        TextFormField(
                          cursorColor: primaryColor,
                          controller: _emailC,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
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
                              borderRadius:
                                  BorderRadius.circular(defaultRadius),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultRadius),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultRadius),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultRadius),
                              borderSide: BorderSide(
                                color: greyColor,
                                width: 2.0,
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 23, top: 20, bottom: 20),
                          ),
                        ),
                        SizedBox(height: 26),
                        TextFormField(
                          controller: _passwordC,
                          obscureText: _obscureText,
                          style: blackTextStyle.copyWith(fontSize: 18),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Masukkan Kata Sandi',
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                      _obscureText
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      color: _obscureText
                                          ? Colors.grey
                                          : primaryColor),
                                ),
                              ),
                              hintStyle: greyTextStyle.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              labelStyle: greyTextStyle.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                borderSide: BorderSide(
                                  color: greyColor,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 23, vertical: 20)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
