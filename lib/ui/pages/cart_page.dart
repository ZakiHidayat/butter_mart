import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:butter_mart/models/cart.dart';
import 'package:butter_mart/services/cart_service.dart';
import 'package:butter_mart/theme/app_theme.dart';
import 'package:butter_mart/ui/pages/bottom_nav.dart';
import 'package:butter_mart/ui/pages/home_page.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class CartPage extends StatefulWidget {
  final bool isFromProfile;
  const CartPage({super.key, this.isFromProfile = false});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int quantity = 0;
  bool isTappedFirst = false;

  List<Cart> carts = [];

  bool isLoading = false;

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1)).then((_) {
      CartService.getCarts().then((value) {
        setState(() {
          carts = value;
        });
      }).catchError((e) {
        log('$e');
      });

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())  );
          return false;
        },
        child: Scaffold(
            backgroundColor: const Color(0xffF2F2F6),
            appBar: AppBar(
              shape: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.20), width: 0.7)),
              elevation: 0,
              backgroundColor: whiteColor,
              centerTitle: true,
              title: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Kerajang Saya\n',
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                          text: '${carts.length} Item',
                          style: greyTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ]),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: IconButton(
                  onPressed: () {
                    if(widget.isFromProfile) {
                      Navigator.of(context).pushReplacement(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        const BottomNav(index: 1,),
                                  ));
                    }else{
                       Navigator.of(context).pushReplacement(SwipeablePageRoute(
                                    canOnlySwipeFromEdge: true,
                                    builder: (BuildContext context) =>
                                        const BottomNav()
                                        ));
                    }
                  },
                  icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
                ),
              ),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : carts.isNotEmpty
                    ? 
                    Container(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: defaultPadding),
                        child: ListView.builder(
                            itemCount: carts.length,
                            itemBuilder: (context, index) {
                              final cart = carts[index];
                              final quantityController = TextEditingController(
                                  text: cart.quantity.toString());
                              return Container(
                                padding: EdgeInsets.all(8),
                                  child: Column(children: [
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: const BoxDecoration(
                                    color: whiteColor,
                                    // border: Border.all(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    // borderRadius:
                                    // BorderRadius.circular(defaultRadius),
                                  ),
                                  child: Row(children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(defaultRadius),
                                          bottomLeft:
                                              Radius.circular(defaultRadius)),
                                      child: Image.network(
                                        cart.product.image,
                                        width: 120,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              cart.product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: blackTextStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              Text(
                                                'Rp ',
                                                style: greyTextStyle.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                              AutoSizeText(
                                                maxLines: 1,
                                                minFontSize: 15,
                                                stepGranularity: 15,
                                                overflow: TextOverflow.ellipsis,
                                                NumberFormat.currency(
                                                  locale: 'id-ID',
                                                  name: '',
                                                  decimalDigits: 0,
                                                ).format(int.parse(
                                                    cart.product.price)),
                                                style: numberTextStyle.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: greyColor),
                                              ),
                                              Text(
                                                ' / Item',
                                                style: greyTextStyle.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Total Rp ',
                                                style: blueTextStyle.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                              AutoSizeText(
                                                maxLines: 1,
                                                minFontSize: 15,
                                                stepGranularity: 15,
                                                overflow: TextOverflow.ellipsis,
                                                NumberFormat.currency(
                                                  locale: 'id-ID',
                                                  name: '',
                                                  decimalDigits: 0,
                                                ).format(int.parse('100000')),
                                                style: numberTextStyle.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: primaryColor),
                                              ),
                                            ],
                                          ),
                                          const Expanded(
                                              child: SizedBox(
                                            height: double.infinity,
                                          )),
                                          Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // CartStepperInt(
                                                //   elevation: 0,
                                                //   size: 33.86,
                                                //   editKeyboardType:
                                                //       const TextInputType
                                                //           .numberWithOptions(
                                                //           signed: true),
                                                //   style:
                                                //       CartStepperTheme.of(context)
                                                //           .copyWith(
                                                //     textStyle:
                                                //         numberTextStyle.copyWith(),
                                                //     foregroundColor: Colors.red,
                                                //     activeForegroundColor:
                                                //         Colors.black,
                                                //     activeBackgroundColor:
                                                //         Colors.transparent,
                                                //     border: Border.all(
                                                //         width: 1.0,
                                                //         color: primaryColor),
                                                //     radius:
                                                //         const Radius.circular(13.0),
                                                //   ),
                                                //   value: quantity,
                                                //   didChangeCount: (count) {
                                                //     setState(() {
                                                //       quantity = count;
                                                //     });
                                                //     Gaimon.soft();
                                                //     if (quantity < 1) {
                                                //       Gaimon.heavy();
                                                //       setState(() {
                                                //         isTappedFirst = false;
                                                //       });
                                                //     }
                                                //   },
                                                // ),
      
                                                SizedBox(
                                                  width: 60,
                                                  height: 40,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        quantityController,
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                      signed: true,
                                                    ),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          3),
                                                    ],
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.all(5),
                                                        border:
                                                            OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              defaultRadius),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                IconButton(
                                                    onPressed: () async {
                                                      Gaimon.success();
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      await CartService.updateCart(
                                                          cartId:
                                                              cart.id.toString(),
                                                          quantity:
                                                              quantityController
                                                                  .text,
                                                          productId: cart
                                                              .product.id
                                                              .toString());
                                                      refresh();
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.grey
                                                          .withOpacity(0.70),
                                                    )),
                                                IconButton(
                                                  onPressed: () async {
                                                    Gaimon.success();
                                                    setState(() {
                                                      isLoading = true;
                                                    });
      
                                                    await CartService.deleteCart(
                                                        cartId:
                                                            cart.id.toString());
      
                                                    refresh();
                                                  },
                                                  icon: SvgPicture.asset(
                                                      color: Colors.grey
                                                          .withOpacity(0.70),
                                                      'assets/icons/trash-icon.svg'),
                                                )
                                              ]),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ]));
                            }),
                      ) :const Center(
                        child: Text('Keranjang Kosong'),
                      )
                      
                      ),
      ),
    );
  }
}
// widget.product.price