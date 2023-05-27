import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/models/user.dart';
import 'package:butter_mart/services/category_service.dart';
import 'package:butter_mart/services/product_service.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';

import '../../models/category.dart';
import '../../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? screenWidth;
  User? user;

  List<Category> categories = [Category(id: 0, name: 'Semua')];
  List<Product> products = [];
  int activeIndexCategory = 0;
  bool isLoading = false;

  void changeActiveIndexCategory(int value) {
    setState(() {
      activeIndexCategory = value;
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    await SecureStorage.getUser().then((value) {
      setState(() {
        user = value;
      });
    }).catchError((e) {
      log('$e');
    });
    await CategoryService.getCategories().then((value) {
      categories.addAll(value);
    }).catchError((e) {
      log('$e');
    });
    await ProductService.getProduct().then((value) {
      setState(() {
        products = value;
      });
    }).catchError((e) {
      log('$e');
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth ??= MediaQuery.of(context).size.width;

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width / 2;

    double ratio = 0.58;

    if (itemHeight < 700) {
      setState(() {
        ratio = 0.50;
      });
    }

    // log('HEIGHT $itemHeight');
    // log('$ratio');

    return Scaffold(
      backgroundColor: whiteColor,

      body: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            softWrap: false,
                            textScaleFactor: 1.25,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: blackTextStyle.copyWith(),
                                children: [
                                  TextSpan(
                                      text: 'Selamat Datang 👋🏻, \n',
                                      style: blackTextStyle.copyWith(
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: '${user?.name}',
                                      style: blueTextStyle.copyWith(
                                          fontWeight: FontWeight.w500)),
                                ])),
                        IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                                'assets/icons/shopping-cart.svg'))
                      ],
                    ),
                    const SizedBox(height: 17),
                    Container(
                      height: 45,
                      child: TextFormField(
                        cursorColor: primaryColor,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(18, 25, 0, 0),
                          fillColor: Colors.grey.withOpacity(0.10),
                          filled: false,
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Cari item disini',
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: SvgPicture.asset(
                                'assets/icons/search-icon.svg',
                                color: Colors.grey.withOpacity(0.90),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.28),
                                  width: 1)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 42,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    itemBuilder: (ctx, i) {
                      final category = categories[i];
                      return GestureDetector(
                        onTap: () {
                          Gaimon.medium();
                          changeActiveIndexCategory(i);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: i == activeIndexCategory
                                  ? primaryColor.withOpacity(0.20)
                                  : Colors.grey.withOpacity(0.13),
                              border: Border.all(
                                width: 1,
                                color: i == activeIndexCategory
                                    ? primaryColor
                                    : Colors.grey.withOpacity(0.0),
                              ),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              category.name.toTitleCase(),
                              style: i == activeIndexCategory
                                  ? blueTextStyle.copyWith(
                                      fontWeight: FontWeight.w600, fontSize: 14)
                                  : blackTextStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) {
                      return const SizedBox(width: 8);
                    },
                    itemCount: categories.length),
              ),
              const SizedBox(height: 8),
              isLoading ? const Center(child:  CircularProgressIndicator()) : products.isEmpty ? Center(child: Text('Data Kosong'),) :Expanded(
                child: Container(
                  color: const Color(0xfff8f8f8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RefreshIndicator(
                      color: primaryColor,
                      onRefresh: refresh,
                      child: MasonryGridView.count(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return MasonryGridTile(
                            product: product,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class MasonryGridTile extends StatefulWidget {
  final Product product;

  MasonryGridTile({Key? key, required this.product}) : super(key: key);

  @override
  State<MasonryGridTile> createState() => _MasonryGridTileState();
}

class _MasonryGridTileState extends State<MasonryGridTile> {
  int quantity = 0;
  bool isTappedFirst = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.20)),
          borderRadius: BorderRadius.circular(defaultRadius),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image(
                  height: MediaQuery.of(context).size.width * 0.38,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.product.image),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  widget.product.name.toTitleCase(),
                  maxLines: 3,
                  style: blackTextStyle.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      'Jumlah Stok : ',
                      textScaleFactor: 1.0,
                      style:
                          greyTextStyle.copyWith(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '${widget.product.stock}',
                      style: numberTextStyle.copyWith(
                          color: greyColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Rp ',
                      style: blackTextStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        maxLines: 1,
                        minFontSize: 18,
                        stepGranularity: 18,
                        overflow: TextOverflow.ellipsis,
                        NumberFormat.currency(
                          locale: 'id-ID',
                          name: '',
                          decimalDigits: 0,
                        ).format(int.parse(widget.product.price)),
                        style: numberTextStyle.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                isTappedFirst
                    ? Container(
                        margin: EdgeInsets.only(bottom: 6, top: 6),
                        child: CartStepperInt(
                          elevation: 0,
                          size: 33.86,
                          style: CartStepperTheme.of(context).copyWith(
                            textStyle: numberTextStyle.copyWith(),
                            foregroundColor: Colors.red,
                            activeForegroundColor: Colors.black,
                            activeBackgroundColor: Colors.transparent,
                            border: Border.all(width: 1.0, color: primaryColor),
                            radius: Radius.circular(13.0),
                          ),
                          value: quantity,
                          didChangeCount: (count) {
                            setState(() {
                              quantity = count;
                            });
                            Gaimon.soft();
                            if (quantity < 1) {
                              Gaimon.heavy();
                              setState(() {
                                isTappedFirst = false;
                              });
                            }
                          },
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Gaimon.heavy();
                            quantity++;
                            isTappedFirst = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)),
                            side: const BorderSide(
                              width: 1.0,
                              color: primaryColor,
                            )),
                        child: Text(
                          'Tambah Item',
                          style: blackTextStyle.copyWith(),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
