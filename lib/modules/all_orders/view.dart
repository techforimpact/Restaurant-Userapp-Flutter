import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:book_a_table/utils/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'package:intl/intl.dart';

import '../../../controllers/general_controller.dart';
import '../../../route_generator.dart';
import '../../../utils/color.dart';

import '../home/logic.dart';
import '../order_detail/view.dart';
import 'logic.dart';
import 'state.dart';

class AllOrdersPage extends StatefulWidget {
  const AllOrdersPage({Key? key, this.backNormal}) : super(key: key);

  final bool? backNormal;
  @override
  _AllOrdersPageState createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  final AllOrdersLogic logic = Get.put(AllOrdersLogic());
  final AllOrdersState state = Get.find<AllOrdersLogic>().state;
  final _generalController = Get.find<GeneralController>();
  final _homeLogic = Get.find<HomeLogic>();

  bool showEmptyScreen = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllOrdersLogic>(
      builder: (_allOrdersLogic) => GestureDetector(
        onTap: () {
          _generalController.focusOut(context);
        },
        child: Scaffold(
          appBar: 
          AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: InkWell(
              onTap: () {
                log('-->>${Get.previousRoute}');
                if (widget.backNormal == null &&
                    (Get.previousRoute.contains('ScreenController') ||
                        Get.previousRoute.contains('home') ||
                        Get.previousRoute.contains('allOrders'))) {
                  Get.offAllNamed(PageRoutes.home);
                } else {
                  Get.back();
                }
                //  Get.offAllNamed(PageRoutes.home);
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
              'Orders',
              style: state.appBarTextStyle,
            ),
          ),
  
          body: ListView(
            children: [
              ///---order-list
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .orderBy('date_time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      log('Waiting');
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),
                        child: SizedBox(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: SkeletonLoader(
                            period: const Duration(seconds: 2),
                            highlightColor: Colors.grey,
                            direction: SkeletonDirection.ltr,
                            builder: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding:  EdgeInsets.only(top: 30),
                          child: Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: kPlaceStyle,
                          ),
                        );
                      } else {
                        for (var element in snapshot.data!.docs) {
                          if (element.get('uid') ==
                              _homeLogic.currentUserData!.get('uid')) {
                            showEmptyScreen = false;
                          }
                        }
                        if (showEmptyScreen) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              Image.asset(
                                'assets/noOrders.png',
                                width: MediaQuery.of(context).size.width * .8,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              const Text(
                                'No orders yet',
                                textAlign: TextAlign.center,
                                style: TextStyle( fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28,
                                    color: Colors.black),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'Hit the orange button down below to create an order',
                                  textAlign: TextAlign.center,
                                  style: TextStyle( fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      color: customTextGreyColor),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return FadedSlideAnimation(
                            child: Wrap(
                              children: List.generate(
                                  snapshot.data!.docs.length, (index) {
                                if (!showEmptyScreen &&
                                    (snapshot.data!.docs[index].get('uid') ==
                                        _homeLogic.currentUserData!
                                            .get('uid'))) {
                                  DateTime dt = (snapshot.data!.docs[index]
                                          .get('date_time') as Timestamp)
                                      .toDate();
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 30, 15, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(OrderDetailPage(
                                          orderModel:
                                              snapshot.data!.docs[index],
                                        ));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          //         22), // changes position of shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              ///---image
                                              Hero(
                                                tag:
                                                    '${snapshot.data!.docs[index].get('restaurant_image')}',
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.grey,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.network(
                                                        '${snapshot.data!.docs[index].get('restaurant_image')}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ///---name-otp
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                '${snapshot.data!.docs[index].get('restaurant')}',
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                        textAlign: TextAlign.justify,
                                                                style: state
                                                                    .nameTextStyle),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                  'Order OTP: ${snapshot.data!.docs[index].get('otp')}',
                                                                  style: state
                                                                      .otpTextStyle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .005,
                                                      ),

                                                      ///---date
                                                      Text(
                                                          DateFormat('dd-MM-yy')
                                                              .format(dt),
                                                          style: state
                                                              .otpTextStyle),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .01,
                                                      ),

                                                      ///---status-amount
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '${snapshot.data!.docs[index].get('status')}',
                                                                  style: state
                                                                      .otpTextStyle!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.green)),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            19),
                                                                    color:
                                                                        customThemeColor),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          2,
                                                                          0,
                                                                          2),
                                                                  child: Center(
                                                                    child: Text(
                                                                        '\Rs  ${(double.parse(snapshot.data!.docs[index].get('grand_total').toString()) - double.parse(snapshot.data!.docs[index].get('coupon_discount').toString())).toPrecision(2)}',
                                                                        style: state
                                                                            .priceTextStyle!
                                                                            .copyWith(color: Colors.white)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            ],
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
                            beginOffset: const Offset(0.3, 0.2),
                            endOffset: const Offset(0, 0),
                            slideCurve: Curves.linearToEaseOut,
                          );
                        }
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

              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
