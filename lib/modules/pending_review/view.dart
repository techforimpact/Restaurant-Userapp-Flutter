
import 'package:book_a_table/utils/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../home/logic.dart';
import '../rating_review/view.dart';
import 'logic.dart';
import 'state.dart';

class PendingReviewPage extends StatefulWidget {
  const PendingReviewPage({Key? key}) : super(key: key);

  @override
  State<PendingReviewPage> createState() => _PendingReviewPageState();
}

class _PendingReviewPageState extends State<PendingReviewPage> {
  final PendingReviewLogic logic = Get.put(PendingReviewLogic());

  final PendingReviewState state = Get.find<PendingReviewLogic>().state;

  final _generalController = Get.find<GeneralController>();
  final _homeLogic = Get.find<HomeLogic>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PendingReviewLogic>(
      builder: (_pendingReviewLogic) => GestureDetector(
        onTap: () {
          _generalController.focusOut(context);
        },
        child: Scaffold(
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
              'Pending Reviews',
              style: kTopHeadingStyle.copyWith(fontSize: 20,color: Colors.black),
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
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: kTopHeadingStyle,
                          ),
                        );
                      } else {
                        return Wrap(
                          children: List.generate(snapshot.data!.docs.length,
                              (index) {
                            if (snapshot.data!.docs[index].get('uid') ==
                                    _homeLogic.currentUserData!.get('uid') &&
                                snapshot.data!.docs[index]
                                        .get('review_status')
                                        .toString() ==
                                    'pending' &&
                                snapshot.data!.docs[index]
                                        .get('status')
                                        .toString() ==
                                    'Complete') {
                              DateTime dt = (snapshot.data!.docs[index]
                                      .get('date_time') as Timestamp)
                                  .toDate();
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(RatingReviewPage(
                                      orderModel: snapshot.data!.docs[index],
                                    ));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(19),
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
                                                decoration: const BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
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
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ///---name-otp
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                            '${snapshot.data!.docs[index].get('restaurant')}',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: state
                                                                .nameTextStyle),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                              'OTP: ${snapshot.data!.docs[index].get('otp')}',
                                                              style: state
                                                                  .otpTextStyle),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .01,
                                                  ),

                                                  ///---date
                                                  Text(
                                                      DateFormat('dd-MM-yy')
                                                          .format(dt),
                                                      style:
                                                          state.otpTextStyle),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
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
                                                                      color: Colors
                                                                          .green)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width: 70,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                                    'Rs${snapshot.data!.docs[index].get('grand_total')}',
                                                                    style: state
                                                                        .priceTextStyle!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white)),
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
                        );
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
