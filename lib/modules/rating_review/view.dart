import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/general_controller.dart';
import '../../models/review.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class RatingReviewPage extends StatefulWidget {
  const RatingReviewPage({Key? key, this.orderModel}) : super(key: key);

  final DocumentSnapshot? orderModel;
  @override
  State<RatingReviewPage> createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  final RatingReviewLogic logic = Get.put(RatingReviewLogic());

  final RatingReviewState state = Get.find<RatingReviewLogic>().state;
  final _generalController = Get.find<GeneralController>();

  final GlobalKey<FormState> _reviewFormKey = GlobalKey();

  double? ratingValue1 = 0;
  double? ratingValue2 = 0;
  double? ratingValue3 = 0;
  SingingCharacter? _character = SingingCharacter.no;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingReviewLogic>(
      builder: (_ratingReviewLogic) => GestureDetector(
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
          ),
          body: Form(
            key: _reviewFormKey,
            child: ListView(
              children: [
                ///---heading
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'How do you rate the',
                    style: state.headingTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: customThemeColor.withOpacity(0.19),
                        //     blurRadius: 40,
                        //     spreadRadius: 0,
                        //     offset: const Offset(
                        //         0, 22), // changes position of shadow
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Food items you collected ?',
                            style: state.titleTextStyle,
                          ),
                          RatingBar.builder(
                            initialRating: ratingValue1!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newValue) {
                              log('Rating--->>${newValue.toString()}');
                              setState(() {
                                ratingValue1 = newValue;
                              });
                              // _ratingReviewLogic.updateRatingValue(newValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: customThemeColor.withOpacity(0.19),
                        //     blurRadius: 40,
                        //     spreadRadius: 0,
                        //     offset: const Offset(
                        //         0, 22), // changes position of shadow
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Service of Restaurent store? ',
                            style: state.titleTextStyle,
                          ),
                          RatingBar.builder(
                            initialRating: ratingValue2!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newValue) {
                              log('Rating--->>${newValue.toString()}');
                              setState(() {
                                ratingValue2 = newValue;
                              });
                              // _ratingReviewLogic.updateRatingValue(newValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: customThemeColor.withOpacity(0.19),
                        //     blurRadius: 40,
                        //     spreadRadius: 0,
                        //     offset: const Offset(
                        //         0, 22), // changes position of shadow
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall experience with Restaurent?',
                            style: state.titleTextStyle,
                          ),
                          RatingBar.builder(
                            initialRating: ratingValue3!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newValue) {
                              log('Rating--->>${newValue.toString()}');
                              setState(() {
                                ratingValue3 = newValue;
                              });
                              // _ratingReviewLogic.updateRatingValue(newValue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///---restaurant-review
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: customThemeColor.withOpacity(0.19),
                        //     blurRadius: 40,
                        //     spreadRadius: 0,
                        //     offset: const Offset(
                        //         0, 22), // changes position of shadow
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Did you purchase additional full priced food or beverage items from the Restaurent at the time of collecting your order? If yes, what did you purchase?',
                            style: state.titleTextStyle,
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('Yes'),
                            value: SingingCharacter.yes,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                              });
                            },
                          ),
                          RadioListTile<SingingCharacter>(
                            title: const Text('No'),
                            value: SingingCharacter.no,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                _character == SingingCharacter.yes
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: TextFormField(
                          focusNode: _ratingReviewLogic.focusNode,
                          style: const TextStyle( fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                          controller: _ratingReviewLogic.reviewController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Review",
                            labelStyle: TextStyle( fontFamily: 'Poppins',
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.black.withOpacity(0.4)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.5))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.5))),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customThemeColor)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field Required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      )
                    : const SizedBox(),

                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: InkWell(
              onTap: () async {
                if (ratingValue1 != 0 &&
                    ratingValue2 != 0 &&
                    ratingValue3 != 0) {
                  double avgRatting =
                      ((ratingValue1! + ratingValue2! + ratingValue3!) / 3)
                          .toPrecision(1);
                  log('TOTAL--->>$avgRatting');
                  //get the current restaurant
                  QuerySnapshot query1 = await FirebaseFirestore.instance
                      .collection('restaurants')
                      .where('id',
                          isEqualTo: widget.orderModel!.get('restaurant_id'))
                      .get();
                  // get the nested of the review collection
                  if (query1.docs.isNotEmpty) {
                    List tempRateList = query1.docs[0].get('ratings');
                    tempRateList.add(avgRatting);
                    log('TempRateList-->>${tempRateList.length}');

                    List tempReviewList = query1.docs[0].get('reviews');
                    tempReviewList.add(_ratingReviewLogic.reviewController.text);
                    log('TempReviewList-->>${tempReviewList.length}');
                    Review reviewModel = Review(
                        userName: Get.find<GeneralController>()
                            .boxStorage
                            .read('userName'),
                        ratingValue1: ratingValue1 ?? 1,
                        ratingValue2: ratingValue2 ?? 0,
                        ratingValue3: ratingValue3 ?? 0,
                        avgRatings: avgRatting,
                        reviews: _ratingReviewLogic.reviewController.text,
                        dateTime: DateTime.now());
                    //?----------------
                    FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(query1.docs[0].id)
                        .collection('review_ratting')
                        .doc(_generalController.boxStorage.read(
                            'uid')) //user id will be store as docid in nested collection doc
                        .set(reviewModel.toMap(), SetOptions(merge: true));

                    FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(query1.docs[0].id)
                        .update({
                          'avgRatting': avgRatting,
                      'ratings': tempRateList,
                      'reviews': tempReviewList,
                      'total_rates': FieldValue.increment(1),
                    });
                    //order status update to the order collection
                    FirebaseFirestore.instance
                        .collection('orders')
                        .doc(widget.orderModel!.id)
                        .update({
                      'review_status': 'done',
                    });
                    Get.back();
                    Get.snackbar(
                      'Rated Successfully',
                      '',
                      colorText: Colors.white,
                      backgroundColor: customThemeColor.withOpacity(0.7),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(15),
                    );
                  }
                } else {
                  Get.snackbar(
                    'Rate Please...',
                    '',
                    colorText: Colors.white,
                    backgroundColor: customThemeColor.withOpacity(0.7),
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(15),
                  );
                }
              },
              child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: customThemeColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      'Done',
                      style: state.buttonTextStyle,
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter { yes, no }
