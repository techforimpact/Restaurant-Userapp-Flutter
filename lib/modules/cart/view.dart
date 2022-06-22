
import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/custom_dotted_divider.dart';
import '../home/logic.dart';
import '../payment/view.dart';
import '../book_now/view.dart';
import 'logic.dart';
import 'state.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartLogic logic = Get.put(CartLogic());
  final CartState state = Get.find<CartLogic>().state;
  String couponCode = '';
  DocumentSnapshot<Object?>? couponDocumentSnapshot;
  @override
  void initState() {
    super.initState();
    logic.getTotalBillOfCart();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartLogic>(
      builder: (_cartLogic) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 15,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'Cart',
            style: state.appBarTextStyle,
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    ///---swipe-indication
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/iwwa_swipe.svg',
                          width: MediaQuery.of(context).size.width * .08,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'swipe on an item to delete',
                          style: state.swipeTextStyle,
                        )
                      ],
                    ),

                    ///---cart-list
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream:
                            FirebaseFirestore.instance.collection('cart').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  'Record not found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            } else {
                              return StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  //inner stream builder
                                  stream: FirebaseFirestore.instance
                                      .collection('wishList')
                                      .where('uid',
                                          isEqualTo: Get.find<GeneralController>()
                                              .boxStorage
                                              .read('uid'))
                                      .snapshots(),
                                  builder: (context, snapshotInner) {
                                    if (snapshotInner.hasData) {
                                      return FadedSlideAnimation(
                                        beginOffset: const Offset(0, 0.3),
                                        endOffset: const Offset(0, 0),
                                        slideCurve: Curves.linearToEaseOut,
                                        child: Column(
                                          children: List.generate(
                                              snapshot.data!.docs.length, (index) {
                                            checkWishList(bool? newValue) {
                                              setState(() {});
                                            }

                                            var data = snapshotInner.data!.docs;
                                            var wId = '';
                                            var favourites = false;
                                            for (var wishItem in data) {
                                              wId = wishItem.data()['w_id'];

                                              if (wId ==
                                                  snapshot.data!.docs[index]
                                                      .get('product_id')) {
                                                favourites = true;
                                              }
                                            }

                                            if (snapshot.data!.docs[index]
                                                    .get('uid') ==
                                                Get.find<HomeLogic>()
                                                    .currentUserData!
                                                    .get('uid')) {
                                              FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(snapshot.data!.docs[index].id)
                                                  .get()
                                                  .then(
                                                (value) async {
                                                  var resturentId =
                                                      value.get('restaurant_id');
                                                  var qurySnapshot =
                                                      await FirebaseFirestore.instance
                                                          .collection('restaurants')
                                                          .where('id',
                                                              isEqualTo: resturentId)
                                                          .get();
                                                  _cartLogic
                                                          .restaurentDocumentSnapshot =
                                                      qurySnapshot.docs[0];
                                                },
                                              );
                                              return GestureDetector(
                                                onHorizontalDragDown: (e) {
                                                  log('Dragged');
                                                  Get.find<GeneralController>()
                                                      .checkWishList(
                                                          context,
                                                          snapshot.data!.docs[index]
                                                              .get('product_id'),
                                                          checkWishList);
                                                },
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    motion: const StretchMotion(),
                                                    children: [
                                                      //!=======================================================================
                                                      InkWell(
                                                        onTap: () {
                                                          if (!favourites) {
                                                            log('$favourites');
                                                            Get.find<
                                                                    GeneralController>()
                                                                .addToWishList(
                                                                    context,
                                                                    snapshot.data!
                                                                        .docs[index]
                                                                        .get(
                                                                            'product_id'),
                                                                     'products');
                                                            setState(() {
                                                              favourites = true;
                                                            });
                                                          } else {
                                                            print('delete');
                                                            Get.find<
                                                                    GeneralController>()
                                                                .deleteWishList(
                                                                    context,
                                                                    snapshot.data!
                                                                        .docs[index]
                                                                        .get(
                                                                            'product_id'));
                                                            setState(() {
                                                              favourites = false;
                                                            });
                                                          }
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              customThemeColor,
                                                          child: Icon(
                                                            favourites
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .03,
                                                      ),

                                                      InkWell(
                                                        onTap: () {
                                                          FirebaseFirestore.instance
                                                              .collection('cart')
                                                              .doc(snapshot.data!
                                                                  .docs[index].id)
                                                              .delete();
                                                          _cartLogic
                                                              .getTotalBillOfCart();

                                                          Get.find<HomeLogic>()
                                                              .getCartCount();
                                                        },
                                                        child: const CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: Colors.red,
                                                          child: Icon(
                                                            Icons.delete_forever,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      // ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            15, 15, 15, 15),
                                                    child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(19),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color: customThemeColor
                                                        //         .withOpacity(0.19),
                                                        //     blurRadius: 40,
                                                        //     spreadRadius: 0,
                                                        //     offset: const Offset(0,
                                                        //         15), // changes position of shadow
                                                        //   ),
                                                        // ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            20.0),
                                                        child: Row(
                                                          children: [
                                                            ///---image
                                                            Container(
                                                              height: 80,
                                                              width: 80,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color:
                                                                          Colors.grey,
                                                                      shape: BoxShape
                                                                          .circle),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(40),
                                                                child: snapshot
                                                                            .data!
                                                                            .docs[
                                                                                index]
                                                                            .get(
                                                                                'name') ==
                                                                        ''
                                                                    ? Image.asset(
                                                                        'assets/bite-bag-full.png',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Image.network(
                                                                        '${snapshot.data!.docs[index].get('image')}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                              ),
                                                            ),

                                                            ///---detail
                                                            Expanded(
                                                                child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ///---name
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                               '${snapshot.data!.docs[index].get('name')}',
                                                                              style: state
                                                                                  .productNameTextStyle),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                                  .only(
                                                                              right:
                                                                                  15),
                                                                          child: Text(
                                                                              '${snapshot.data!.docs[index].get('discount')}% off',
                                                                              style: TextStyle(
                                                                                  fontFamily:
                                                                                      'Poppins',
                                                                                  fontSize:
                                                                                      14,
                                                                                  fontWeight:
                                                                                      FontWeight.w700,
                                                                                  color: customGreenColor)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(
                                                                                  context)
                                                                              .size
                                                                              .height *
                                                                          .01,
                                                                    ),

                                                                    ///---price
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ///---original-price
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment
                                                                                    .centerLeft,
                                                                            child: Text(
                                                                                'Rs${snapshot.data!.docs[index].get('original_price')}',
                                                                                style: state
                                                                                    .productPriceTextStyle!
                                                                                    .copyWith(decoration: TextDecoration.lineThrough)),
                                                                          ),
                                                                        ),

                                                                        ///---dis_price
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment
                                                                                    .centerLeft,
                                                                            child: Text(
                                                                                'Rs${snapshot.data!.docs[index].get('dis_price')}',
                                                                                style: state
                                                                                    .productPriceTextStyle!
                                                                                    .copyWith(color: customThemeColor)),
                                                                          ),
                                                                        ),

                                                                        ///---quantity
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment
                                                                                    .center,
                                                                            child:
                                                                                Container(
                                                                              width:
                                                                                  70,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius:
                                                                                      BorderRadius.circular(19),
                                                                                  color: customThemeColor),
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.fromLTRB(
                                                                                    0,
                                                                                    2,
                                                                                    0,
                                                                                    2),
                                                                                child:
                                                                                    Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        if (int.parse(snapshot.data!.docs[index].get('quantity').toString()) > 1) {
                                                                                          FirebaseFirestore.instance.collection('cart').doc(snapshot.data!.docs[index].id).update({
                                                                                            'quantity': FieldValue.increment(-1),
                                                                                          });
                                                                                          _cartLogic.getTotalBillOfCart();
                                                                                        }
                                                                                      },
                                                                                      child: const Padding(
                                                                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                                        child: Icon(
                                                                                          Icons.remove,
                                                                                          color: Colors.white,
                                                                                          size: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Text('${snapshot.data!.docs[index].get('quantity')}', style: state.productPriceTextStyle!.copyWith(color: Colors.white)),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        if (int.parse(snapshot.data!.docs[index].get('quantity').toString()) < int.parse(snapshot.data!.docs[index].get('max_quantity').toString())) {
                                                                                          FirebaseFirestore.instance.collection('cart').doc(snapshot.data!.docs[index].id).update({
                                                                                            'quantity': FieldValue.increment(1),
                                                                                          });
                                                                                          _cartLogic.getTotalBillOfCart();
                                                                                        }
                                                                                      },
                                                                                      child: const Padding(
                                                                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                                                        child: Icon(
                                                                                          Icons.add,
                                                                                          color: Colors.white,
                                                                                          size: 10,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  });
                            }
                          } else {
                            return Text(
                              'Record not found',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            );
                          }
                        }),

                    
                  ],
                ),
              ),
            ),
          
        Positioned(
          bottom: 0,
          left: 0,
          child: Column(children: [
                    _cartLogic.showBill!
                        ? GestureDetector(
                          onTap: () {},
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width-40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                    activeColor: customThemeColor,
                                    value: _cartLogic.radioValue,
                                    onChanged: (value) {
                                      takeAwayDialog(context);
                                    }),
                                    Text(
                                      'You want to take away?',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: customGreenColor),
                                    ),
                              
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
//-----------------
                    _cartLogic.showBill!
                        ? SizedBox(
                             width: MediaQuery.of(context).size.width-40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GetBuilder<GeneralController>(
                                    builder: (controller) {
                                  return Checkbox(
                                      activeColor: customThemeColor,
                                      value: controller
                                              .tableBookingDocumentReference !=
                                          null,
                                      onChanged: (value) {
                                        if (_cartLogic.restaurentDocumentSnapshot !=
                                            null) {
                                          Get.to(BookingTable(
                                            restaurantModel: _cartLogic
                                                .restaurentDocumentSnapshot!,
                                            isProductInclude: true,
                                          ));
                                        }
                                      });
                                }),
                                 Text(
                                      'Do You want to Book a table?',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: customGreenColor),
                                    ),
                               
                              ],
                            ),
                          )
                        : const SizedBox(),
                       
                  _cartLogic.showBill!
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(32))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            ///---total-price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price',
                                  style: state.billLabelTextStyle,
                                ),
                                Text(
                                  'Rs${_cartLogic.totalPrice}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            ///---total-discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Discount',
                                      style: state.billLabelTextStyle,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${((double.parse(_cartLogic.totalDiscount.toString()) / double.parse(_cartLogic.totalPrice.toString())) * 100).toPrecision(2)}%',
                                      style: state.discountPercentTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  'Rs${_cartLogic.totalDiscount}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                      
                            ///---coupon discount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Coupon discount',
                                  style: state.billLabelTextStyle,
                                ),
                                Text(
                                  'Rs${_cartLogic.couponDiscount}',
                                  style: state.billValueTextStyle,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            MySeparator(
                              color: customTextGreyColor.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            ///---use a coupon
                            InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                    Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                          color: Colors.white),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 20),
                                            Text(
                                              "Enter Coupon",
                                              style: state.grandTotalTextStyle,
                                            ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: TextFormField(
                                                onChanged: (couponCode) {
                                                  this.couponCode = couponCode;
                                                },
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  labelText: "Coupon",
                                                  labelStyle: const TextStyle(
                                                      color: customThemeColor),
                                                  border: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5))),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5))),
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  customThemeColor)),
                                                  errorBorder:
                                                      const UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  if (couponCode.isEmpty) {
                                                    return;
                                                  }
                                                  //-------------
                                                  _cartLogic
                                                      .getTotalBillOfCart();

                                                  Get.find<GeneralController>()
                                                      .focusOut(context);
                                                  showProgress();
                                                  //-------------
                                                  var querySnapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('coupon')
                                                          .where(
                                                              'discountCouponCode',
                                                              isEqualTo:
                                                                  couponCode)
                                                          .where('isValid',
                                                              isEqualTo: true)
                                                          .get();
                                                  //--coupon is valid or not
                                                  if (querySnapshot
                                                      .docs.isEmpty) {
                                                    showToast(
                                                        "Not a valid coupon");
                                                    dissmissProgress();
                                                    return;
                                                  }
                                                  //get the currently apply coupan code doc snapshot
                                                  DocumentSnapshot
                                                      coupondocumentSnapshot =
                                                      querySnapshot.docs.first;
                                                  // curently cart item with coupan code
                                                  var cartQuery =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('cart')
                                                          .where("uid",
                                                              isEqualTo: Get.find<
                                                                      GeneralController>()
                                                                  .boxStorage
                                                                  .read('uid'))
                                                          .where('couponCode',
                                                              isEqualTo:
                                                                  couponCode)
                                                          .get();
                                                  //get the user for this coupon
                                                  var userUsageDoc =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('coupon')
                                                          .doc(
                                                              coupondocumentSnapshot
                                                                  .id)
                                                          .collection('user')
                                                          .doc(Get.find<
                                                                  GeneralController>()
                                                              .boxStorage
                                                              .read('uid'))
                                                          .get();

                                                  log("couponData ");
                                                  if (userUsageDoc.exists) {
                                                    var userUsage = userUsageDoc
                                                            .get('userUsage')
                                                        as int;

                                                    print(
                                                        'user usage $userUsage');
                                                    print(
                                                        'doc coupon usage ${coupondocumentSnapshot.get('usageLimit')}');
                                                    if (userUsage <
                                                        int.parse(
                                                            coupondocumentSnapshot
                                                                .get(
                                                                    'usageLimit'))) {
                                                      if (cartQuery
                                                          .docs.isNotEmpty) {
                                                        // FirebaseFirestore.instance
                                                        //   .collection('coupon')
                                                        //   .doc(
                                                        //       coupondocumentSnapshot
                                                        //           .id)
                                                        //   .collection('user')
                                                        //   .doc(Get.find<
                                                        //           GeneralController>()
                                                        //       .boxStorage
                                                        //       .read('uid'))
                                                        //   .set(
                                                        //       {
                                                        //     'userUsage':
                                                        //         ++userUsage
                                                        //   },
                                                        // SetOptions(
                                                        //     merge: true));
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('cart')
                                                            .doc(cartQuery
                                                                .docs[0].id)
                                                            .update({
                                                          'isApplyCoupon': true
                                                        });
                                                      } else {
                                                        print(
                                                            'prodcut not added for coupan');
                                                        showToast(
                                                            "Add other product for this coupon");
                                                        dissmissProgress();
                                                        return;
                                                      }
                                                    } else {
                                                      print('limit up');
                                                      showToast(
                                                          "your usage limit exceed");
                                                      dissmissProgress();

                                                      return;
                                                    }
                                                  } else {
                                                    if (cartQuery
                                                        .docs.isNotEmpty) {
                                                      //    FirebaseFirestore.instance
                                                      //     .collection('coupon')
                                                      //     .doc(
                                                      //         coupondocumentSnapshot
                                                      //             .id)
                                                      //     .collection('user')
                                                      //     .doc(Get.find<
                                                      //             GeneralController>()
                                                      //         .boxStorage
                                                      //         .read('uid'))
                                                      //     .set({
                                                      //   'userUsage': 1,
                                                      //   'uid':Get.find<
                                                      //                   GeneralController>()
                                                      //               .boxStorage
                                                      //               .read('uid')
                                                      // }, SetOptions(merge: true));
                                                      // cartQuery.docs[0].reference
                                                      //     .update({
                                                      //   'isApplyCoupon': true
                                                      // });
                                                    } else {
                                                      print(
                                                          'prodcut not added for coupan');
                                                      showToast(
                                                          "Add other product for this coupon");
                                                      dissmissProgress();
                                                      return;
                                                    }
                                                  }

                                                  String discountMethod =
                                                      querySnapshot.docs.first
                                                              .data()[
                                                          'discountMethod'];
                                                  double discount =
                                                      double.parse(querySnapshot
                                                          .docs.first
                                                          .data()['discount']
                                                          .toString());
                                                  if (discountMethod.contains(
                                                      'Percentage Discount')) {
                                                    double d =
                                                        (discount / 100.0)
                                                            .toDouble();
                                                    double totalDiscount =
                                                        (double.parse(_cartLogic
                                                                    .grandTotal
                                                                    .toString()) *
                                                                d)
                                                            .toDouble();

                                                    //---------------for coupon discount
                                                    print(
                                                        'minAmountValue =============> ${coupondocumentSnapshot.get('minAmountValue')}');
                                                    print(
                                                        'minAmountValue =============> ${_cartLogic.totalPrice!}');
                                                    if (discount.toPrecision(
                                                                2) >
                                                            _cartLogic
                                                                    .totalPrice! *
                                                                0.8 ||
                                                        _cartLogic.totalPrice! <
                                                            int.parse(
                                                                coupondocumentSnapshot
                                                                    .get(
                                                                        'minAmountValue')) ||
                                                        cartQuery
                                                            .docs.isEmpty) {
                                                      showToast(
                                                          'you cannot use this coupan');
                                                      dissmissProgress();

                                                      Get.back();
                                                      return;
                                                    } else {
                                                      couponDocumentSnapshot =
                                                          userUsageDoc;
                                                      _cartLogic
                                                              .couponDiscount =
                                                          totalDiscount
                                                              .toPrecision(2);
                                                      _cartLogic.update();
                                                    }
                                                  } else {
                                                    //---------------for coupon discount
                                                    print(
                                                        'minAmountValue =============> ${coupondocumentSnapshot.get('minAmountValue')}');
                                                    print(
                                                        'minAmountValue =============> ${_cartLogic.totalPrice!}');
                                                    if (discount.toPrecision(
                                                                2) >
                                                            _cartLogic
                                                                    .totalPrice! *
                                                                0.8 ||
                                                        _cartLogic.totalPrice! <
                                                            int.parse(
                                                                coupondocumentSnapshot
                                                                    .get(
                                                                        'minAmountValue')) ||
                                                        cartQuery
                                                            .docs.isEmpty) {
                                                      showToast(
                                                          'you cannot use this coupan');
                                                      dissmissProgress();

                                                      Get.back();
                                                      return;
                                                    } else {
                                                      couponDocumentSnapshot =
                                                          userUsageDoc;
                                                      _cartLogic
                                                              .couponDiscount =
                                                          discount
                                                              .toPrecision(2);
                                                      _cartLogic.update();
                                                    }
                                                  }
                                                  showToast(_cartLogic
                                                      .couponDiscount
                                                      .toString());
                                                  _cartLogic.update();
                                                  dissmissProgress();
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: customThemeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Center(
                                                    child: Text(
                                                      'Submit',
                                                      style:
                                                          state.buttonTextStyle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isScrollControlled: true);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/coupn.svg',
                                      width: 20,
                                      height: 20,
                                      color: customThemeColor,
                                    ),
                                  ),
                                  Text(
                                    'Use a Coupon',
                                    style:
                                        state.billLabelTextStyleWithCustomColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            MySeparator(
                              color: customTextGreyColor.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            ///---grand-total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Grand Total',
                                  style: state.grandTotalTextStyle,
                                ),
                                Text(
                                  'Rs${_cartLogic.grandTotal! - _cartLogic.couponDiscount!}',
                                  style: state.grandTotalTextStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            ///---button
                            InkWell(
                              onTap: () {
                                //!------------------
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PaymentPage(
                                    coupanDocumentSnapshot:
                                        couponDocumentSnapshot,
                                  );
                                }));
                              },
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: customThemeColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    'Proceed to Payment',
                                    style: state.buttonTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),  

          ],),
          
        
        
        ),
          ],
        ),
      ),
    );
  }

  void takeAwayDialog(BuildContext context) {

  showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Take Away'),
            content: Text("Do you want it take away?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    logic.radioValue = false;
                    logic.update();
                  },
                  child: Text("No",
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    logic.radioValue = true;
                    logic.update();
                  },
                  child: Text("Yes",
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            ],
          );
        });
  

  }
  
}
