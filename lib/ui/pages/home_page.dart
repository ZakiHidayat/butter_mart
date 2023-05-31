// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:butter_mart/locals/secure_storage.dart';
import 'package:butter_mart/models/cart.dart';
import 'package:butter_mart/models/user.dart';
import 'package:butter_mart/services/cart_service.dart';
import 'package:butter_mart/services/category_service.dart';
import 'package:butter_mart/services/product_service.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/cart_page.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

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

  List<Category> categories = [];
  List<Product> products = [];
  int activeIndexCategory = 0;
  bool isLoadingCarts = true;
  bool isLoadingUser = true;
  bool isLoadingCategories = true;
  bool isLoadingProduct = true;
  List<Cart> carts = [];

  void changeActiveIndexCategory(int value) {
    setState(() {
      activeIndexCategory = value;
    });
  }

  Future refresh({String? categoryId = '0'} ) async {
    
    Future.delayed(const Duration(seconds: 3)).then((_) {
      CartService.getCarts().then((value) {
        setState(() {
          carts = value;
          isLoadingCarts = false;
        });
      }).catchError((e) {
        log('$e');
      });
      SecureStorage.getUser().then((value) {
        setState(() {
          user = value;
          isLoadingUser = false;
        });
      }).catchError((e) {
        log('$e');
      });
      CategoryService.getCategories().then((value) {
        setState(() {
          categories = value;
          categories.insert(0, Category(id: 0, name: 'Semua'));
          isLoadingCategories = false;
        });
      }).catchError((e) {
        log('$e');
      });
      ProductService.getProduct(categoryId: categoryId).then((value) {
        setState(() {
          products = value;
          isLoadingProduct = false;
        });
      }).catchError((e) {
        log('$e');
      });
     
    });
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    refresh();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth ??= MediaQuery.of(context).size.width;

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;

    if (itemHeight < 700) {
      setState(() {});
    }

    // log('HEIGHT $itemHeight');
    // log('$ratio');

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            //App Bar Custom
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.7,
                    color: Colors.grey.withOpacity(0.20),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: defaultPadding, left: defaultPadding, top: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isLoadingUser
                                ?
                                //Loading SHIMMER ANIMATION
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                            color: greyColor.withOpacity(0.13),
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color:
                                                    greyColor.withOpacity(0.13),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        defaultRadius)),
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            height: 12,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color:
                                                    greyColor.withOpacity(0.13),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        defaultRadius)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                //Loading SHIMMER ANIMATION END
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AdvancedAvatar(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffEEF3F8),
                                            border: Border.all(
                                                width: 1,
                                                color: primaryColor
                                                    .withOpacity(0.28)),
                                            borderRadius:
                                                BorderRadius.circular(500)),
                                        name: user?.name,
                                        image: NetworkImage('${user?.avatar}'),
                                        style: blueTextStyle.copyWith(
                                            fontSize: 18),
                                        size: MediaQuery.of(context)
                                                .size
                                                .width -
                                            MediaQuery.of(context).size.width +
                                            45,
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.52,
                                        child: RichText(
                                            softWrap: false,
                                            textScaleFactor: 1.25,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                style:
                                                    blackTextStyle.copyWith(),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          'Selamat Datang 👋🏻, \n',
                                                      style: blackTextStyle
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                  TextSpan(
                                                      text: '${user?.name}',
                                                      style: blueTextStyle
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ])),
                                      ),
                                    ],
                                  ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        const CartPage(),
                                  ));
                                },
                                icon: SvgPicture.asset(
                                    'assets/icons/shopping-cart.svg'))
                          ],
                        ),
                        //SEARCH BAR
                        const SizedBox(height: 17),
                        SizedBox(
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
                        //SEARCH BAR END
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoadingCategories
                      ? SizedBox(
                          height: 42,
                          child: ListView.separated(
                              padding: const EdgeInsets.only(
                                  left: defaultPadding, right: defaultPadding),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, __) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.13),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.withOpacity(0.0),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                );
                              },
                              separatorBuilder: (_, __) {
                                return const SizedBox(width: 8);
                              },
                              itemCount: 5),
                        )
                      : SizedBox(
                          height: 42,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: defaultPadding, right: defaultPadding),
                              itemBuilder: (ctx, i) {
                                final category = categories[i];
                                return GestureDetector(
                                  onTap: () {
                                    Gaimon.medium();
                                    changeActiveIndexCategory(i);
                                    refresh(categoryId: category.id.toString());
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: i == activeIndexCategory
                                            ? const Color(0xffEEF3F8)
                                            : Colors.grey.withOpacity(0.13),
                                        border: Border.all(
                                          width: 1,
                                          color: i == activeIndexCategory
                                              ? primaryColor
                                              : Colors.grey.withOpacity(0.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        category.name.toTitleCase(),
                                        style: i == activeIndexCategory
                                            ? blueTextStyle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)
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
                  //Percobaan 2
                  // SizedBox(
                  //   height: 42,
                  //   child: ScrollablePositionedList.builder(
                  //     padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: categories.length,
                  //     itemBuilder: (ctx, i) {
                  //       final category = categories[i];
                  //       return Row(
                  //         children: [
                  //           GestureDetector(
                  //             onTap: () async {
                  //               Gaimon.medium();
                  //               changeActiveIndexCategory(i);
                  //               await itemScrollController.scrollTo(
                  //                   index: i,
                  //                   alignment: 0.35,
                  //                   duration:
                  //                       const Duration(milliseconds: 250));
                  //             },
                  //             child: Container(
                  //               alignment: Alignment.center,
                  //               decoration: BoxDecoration(
                  //                   color: i == activeIndexCategory
                  //                       ? primaryColor.withOpacity(0.20)
                  //                       : Colors.grey.withOpacity(0.13),
                  //                   border: Border.all(
                  //                     width: 1,
                  //                     color: i == activeIndexCategory
                  //                         ? primaryColor
                  //                         : Colors.grey.withOpacity(0.0),
                  //                   ),
                  //                   borderRadius:
                  //                       BorderRadius.circular(12.0)),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 12),
                  //                 child: Text(
                  //                   category.name.toTitleCase(),
                  //                   style: i == activeIndexCategory
                  //                       ? blueTextStyle.copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 14)
                  //                       : blackTextStyle.copyWith(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 14),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 10,
                  //           )
                  //         ],
                  //       );
                  //     },
                  //     itemScrollController: itemScrollController,
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            //List Product
            isLoadingProduct
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : !products.isNotEmpty ? Expanded(child: Center(child: Text('Produk tidak tersedia'),)) :Expanded(
                    child: Container(
                      color: const Color(0xffF2F2F6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: RefreshIndicator(
                          color: primaryColor,
                          onRefresh: refresh,
                          child: MasonryGridView.count(
                            padding: const EdgeInsets.only(top: defaultPadding, bottom: 100),
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final cart = carts
                                  .where((element) =>
                                      element.productId == product.id)
                                  .toList();
                              final isInCart = cart.isNotEmpty;
                              return MasonryGridTile(
                                product: product,
                                isInCart: isInCart,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MasonryGridTile extends StatefulWidget {
  final Product product;
  bool isInCart;

  MasonryGridTile({Key? key, required this.product, this.isInCart = false})
      : super(key: key);

  @override
  State<MasonryGridTile> createState() => _MasonryGridTileState();
}

class _MasonryGridTileState extends State<MasonryGridTile> {
  int quantity = 0;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.20)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            style: greyTextStyle.copyWith(
                                fontWeight: FontWeight.w400),
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
                      // isTappedFirst
                      //     ? Container(
                      //         margin: const EdgeInsets.only(bottom: 6, top: 6),
                      //         child: CartStepperInt(
                      //           elevation: 0,
                      //           size: 33.86,
                      //           editKeyboardType:
                      //               const TextInputType.numberWithOptions(
                      //                   signed: true),
                      //           style: CartStepperTheme.of(context).copyWith(
                      //             textStyle: numberTextStyle.copyWith(),
                      //             foregroundColor: Colors.red,
                      //             activeForegroundColor: Colors.black,
                      //             activeBackgroundColor: Colors.transparent,
                      //             border: Border.all(
                      //                 width: 1.0, color: primaryColor),
                      //             radius: const Radius.circular(13.0),
                      //           ),
                      //           value: quantity,
                      //           didChangeCount: (count) {
                      //             setState(() {
                      //               quantity = count;
                      //             });
                      //             Gaimon.soft();
                      //             if (quantity < 1) {
                      //               Gaimon.heavy();
                      //               setState(() {
                      //                 isTappedFirst = false;
                      //               });
                      //             }
                      //           },
                      //         ),
                      //       )
                      //     :

                      widget.isInCart
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        const CartPage(),
                                  ));
                              },
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0)),
                                  side: const BorderSide(
                                    width: 1.0,
                                    color: primaryColor,
                                  )),
                              child: Text(
                                'Di Keranjang',
                                style: whiteTextStyle.copyWith(),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                  Gaimon.light();
                                  quantity++;
                                  widget.isInCart = true;
                                });
                                if (widget.isInCart) {
                                  final result =
                                      await CartService.createProductCart(
                                          productId:
                                              widget.product.id.toString(),
                                          quantity: quantity.toString());
                                  if (!mounted) return;
                                  Gaimon.success();
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        backgroundColor: primaryColor,
                                        content: Text.rich(
                                          TextSpan(text: 
                                          'Item Berhasil Ditambahkan ke keranjang, kamu bisa ',
                                          style: whiteTextStyle.copyWith(),
                                          children: [
                                            TextSpan(
                                              text: 'Ubah Jumlah Item ',
                                              style: whiteTextStyle.copyWith(
                                                fontWeight: FontWeight.w700
                                              )
                                            ),
                                            TextSpan(
                                              text: 'dan ',
                                              style: whiteTextStyle.copyWith()
                                            ),
                                            TextSpan(
                                              text: 'Hapus Item di keranjang',
                                              style: whiteTextStyle.copyWith(
                                                fontWeight: FontWeight.w700
                                              )
                                            )
                                          ]
                                          ),
                                          style: whiteTextStyle.copyWith(),
                                        )));
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0)),
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
