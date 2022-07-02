import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../cart/logic.dart';
import 'logic.dart';
import 'state.dart';
import 'stripe_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, this.coupanDocumentSnapshot}) : super(key: key);
  final DocumentSnapshot<Object?>? coupanDocumentSnapshot;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentLogic logic = Get.put(PaymentLogic());
  final PaymentState state = Get.find<PaymentLogic>().state;
  final _cartLogic = Get.find<CartLogic>();

  @override
  void initState() {
    super.initState();

    logic.getData();
    StripeService.init();
  }

  @override
  void dispose() {
  
    super.dispose();
  }

  List<int> check = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      builder: (_generalController) => GetBuilder<PaymentLogic>(
        builder: (_paymentLogic) => ModalProgressHUD(
          inAsyncCall: _generalController.formLoader!,
          progressIndicator: const CircularProgressIndicator(
            color: customThemeColor,
          ),
          child: WillPopScope(
            onWillPop: () async {
              return false;
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
                  'Payment',
                  style: state.appBarTextStyle,
                ),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      Text(
                        'From Saved Cards',
                        style: state.headingTextStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('credit_cards')
                              .where('uid',
                                  isEqualTo: Get.find<GeneralController>()
                                      .boxStorage
                                      .read('uid'))
                              .snapshots(),
                          builder: (cnt, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                check.isEmpty) {
                              log('Waiting');
                              return Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(18, 5, 0, 5),
                                    child: SizedBox(
                                      height: 165,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: SkeletonLoader(
                                        period: const Duration(seconds: 2),
                                        highlightColor: Colors.grey,
                                        direction: SkeletonDirection.ltr,
                                        builder: Container(
                                          height: 165,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data!.docs.isEmpty &&
                                  check.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Stack(
                                    children: [
                                      Image.asset('assets/cardBackground.png'),
                                      Positioned(
                                          bottom: 20,
                                          right: 40,
                                          child: Image.asset(
                                            'assets/card_bottom_logo.png',
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 30, 0, 0),
                                        child: Center(
                                          child: Text(
                                            'No Saved Card Found',
                                            style: TextStyle( 
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                check.add(1);
                                return FadedSlideAnimation(
                                  child: Container(
                                    color: Colors.transparent,
                                    height: 165,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (cnt, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: InkWell(
                                              onTap: () {
                                                _paymentLogic
                                                    .updateReferenceContext(
                                                        context);
                                                customFromSavedCardsDialog(
                                                    context,
                                                    snapshot.data!.docs[index],
                                                    widget
                                                        .coupanDocumentSnapshot);
                                              },
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                      'assets/cardBackground.png'),
                                                  Positioned(
                                                      bottom: 20,
                                                      right: 40,
                                                      child: Image.asset(
                                                        'assets/card_bottom_logo.png',
                                                      )),
                                                  Positioned(
                                                    bottom: 50,
                                                    left: 30,
                                                    child: Text(
                                                      '${snapshot.data!.docs[index].get('card_number').toString().substring(0, 4)}'
                                                      ' **** **** '
                                                      '${snapshot.data!.docs[index].get('card_number').toString().substring(12, 16)}',
                                                      style: const TextStyle( fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  beginOffset: const Offset(0.3, 0.2),
                                  endOffset: const Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                );
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Stack(
                                  children: [
                                    Image.asset('assets/cardBackground.png'),
                                    Positioned(
                                        bottom: 20,
                                        right: 40,
                                        child: Image.asset(
                                          'assets/card_bottom_logo.png',
                                        )),
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 30, 0, 0),
                                      child: Center(
                                        child: Text(
                                          'No Saved Card Found',
                                          style: TextStyle( fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Add New',
                        style: state.headingTextStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _paymentLogic.updateRadioValue(
                                      _paymentLogic.cardRadioGroupValue);

                                  customPaymentDialog(
                                      context, widget.coupanDocumentSnapshot);
                                  /*var response = await StripeService.payWithNewCard(
                                      amount: '${Get.find<CartLogic>().grandTotal}',
                                      currency: 'USD',
                                      context: context);*/
                                  /*var response = await StripeService.payViaExistingCard(
                                      amount: '${Get.find<CartLogic>().grandTotal}',
                                      currency: 'USD',
                                      card: CreditCard(
                                        expYear: 2023,
                                        expMonth: 4,
                                        number: '4242424242434242',
                                        cvc: '123'
                                      ));*/

                                  /*var response =
                                      await StripeService.createPaymentIntent(
                                    '${Get.find<CartLogic>().grandTotal}',
                                    'USD',
                                  );*/
                                  /*var response = await StripeService.payNowHandler(
                                    amount: '${Get.find<CartLogic>().grandTotal}',
                                    currency: 'USD',
                                  );*/
                                },
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        activeColor: Colors.red,
                                        value: _paymentLogic.radioValue!,
                                        groupValue:
                                            _paymentLogic.cardRadioGroupValue,
                                        onChanged: (int? newValue) {}),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 38,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffF47B0A),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: SvgPicture.asset(
                                        'assets/cardIcon.svg',
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Card',
                                      style: state.titleTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(50, 5, 0, 5),
                                child: Divider(
                                  color: customTextGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: customThemeColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        'PAY Rs ${_cartLogic.grandTotal}',
                        style: state.buttonTextStyle,
                      ),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _paymentFormKey = GlobalKey();
  var cardNumberMask = MaskTextInputFormatter(mask: '#### #### #### ####');
  var cardExpiryMask = MaskTextInputFormatter(mask: '##/##');
 
  //--------------------------
  customFromSavedCardsDialog(
      BuildContext context1,
      DocumentSnapshot documentSnapshot,
      DocumentSnapshot<Object?>? coupanDocumentSnapshot) {
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context1,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue With Selected Card?',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.5),
                              )),

                          ///---footer
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 20, 0, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Get.find<GeneralController>()
                                          .updateFormLoader(true);
                                      Navigator.pop(context);
                                      log('CardNumber--->>${documentSnapshot.get('card_number')}');
                                      log('CardExpiry--->>${documentSnapshot.get('card_expiry_month')}');
                                      log('CardExpiry--->>${documentSnapshot.get('card_expiry_year')}');
                                      log('CardCVC--->>${documentSnapshot.get('card_cvc')}');
                                      //!--------------------
                                     
                                      //----------------------------
                                      StripePayment.createTokenWithCard(CreditCard(
                                              expYear: 20 +
                                                  int.parse(documentSnapshot
                                                      .get('card_expiry_year')
                                                      .toString()),
                                              expMonth: int.parse(
                                                  documentSnapshot
                                                      .get('card_expiry_month')
                                                      .toString()),
                                              number: documentSnapshot
                                                  .get('card_number')
                                                  .toString(),
                                              cvc: documentSnapshot
                                                  .get('card_cvc')
                                                  .toString()))
                                          .then((token) async {
                                        log('Token-->>${token.tokenId}');
                                        Get.find<PaymentLogic>().paymentToken =
                                            token.tokenId;
                                        Get.find<PaymentLogic>().update();
                                        customProceedDialog(context1);

                                        Get.find<GeneralController>()
                                            .updateFormLoader(false);

                                        if (coupanDocumentSnapshot != null) {
                                          var updageCoupanUsage = int.parse(
                                                  coupanDocumentSnapshot
                                                      .get('usageLimit')) -
                                              1;
                                          await coupanDocumentSnapshot.reference
                                              .set({
                                            'usageLimit': updageCoupanUsage
                                          }, SetOptions(merge: true));
                                        }
                                      }).catchError((e) {
                                        Get.find<GeneralController>()
                                            .updateFormLoader(false);
                                        Get.snackbar(
                                          'Incorrect Card $e Details',
                                          '',
                                          colorText: Colors.white,
                                          backgroundColor:
                                              customThemeColor.withOpacity(0.7),
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(15),
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: customThemeColor,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          child: Text(
                                            'Continue',
                                            style: GoogleFonts.jost(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  customPaymentDialog(BuildContext context1,
      DocumentSnapshot<Object?>? coupanDocumentSnapshot) {
    Get.find<PaymentLogic>().cardNumberController.clear();
    Get.find<PaymentLogic>().cardExpiryController.clear();
    Get.find<PaymentLogic>().cardCVCController.clear();
    return showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context1,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        },
        transitionBuilder: (BuildContext context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _paymentFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller:
                              Get.find<PaymentLogic>().cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(19),
                            cardNumberMask
                          ],
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Card number',
                            labelStyle:
                                TextStyle( fontFamily: 'Poppins',color: customThemeColor),
                            hintText: '1234 1234 1234 1234',
                            hintStyle: TextStyle( fontFamily: 'Poppins',
                              color: customTextGreyColor,
                            ),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextGreyColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customTextGreyColor)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: customThemeColor)),
                            errorBorder: UnderlineInputBorder(
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
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: TextFormField(
                                  controller: Get.find<PaymentLogic>()
                                      .cardExpiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5),
                                    cardExpiryMask
                                  ],
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Expiry date',
                                    labelStyle: TextStyle( fontFamily: 'Poppins',
                                        color: customThemeColor),
                                    hintText: 'MM/YY',
                                    hintStyle: TextStyle( fontFamily: 'Poppins',
                                      color: customTextGreyColor,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customTextGreyColor)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customTextGreyColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customThemeColor)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: TextFormField(
                                  controller: Get.find<PaymentLogic>()
                                      .cardCVCController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'CVC',
                                    labelStyle: TextStyle( fontFamily: 'Poppins',
                                        color: customThemeColor),
                                    hintText: '123',
                                    hintStyle: TextStyle( fontFamily: 'Poppins',
                                      color: customTextGreyColor,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customTextGreyColor)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customTextGreyColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customThemeColor)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        ///---footer
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_paymentFormKey.currentState!
                                        .validate()) {
                                      Get.find<GeneralController>()
                                          .updateFormLoader(true);
                                      Navigator.pop(context);
                                      log('CardNumber--->>${Get.find<PaymentLogic>().cardNumberController.text.replaceAll(' ', '')}');
                                      log('CardExpiry--->>${Get.find<PaymentLogic>().cardExpiryController.text.toString().substring(0, 2)}');
                                      log('CardExpiry--->>${Get.find<PaymentLogic>().cardExpiryController.text.toString().substring(3, 5)}');
                                      log('CardCVC--->>${Get.find<PaymentLogic>().cardCVCController.text}');
                                      StripePayment.createTokenWithCard(CreditCard(
                                              expYear: 20 +
                                                  int.parse(
                                                      Get.find<PaymentLogic>()
                                                          .cardExpiryController
                                                          .text
                                                          .toString()
                                                          .substring(3, 5)),
                                              expMonth: int.parse(
                                                  Get.find<PaymentLogic>()
                                                      .cardExpiryController
                                                      .text
                                                      .toString()
                                                      .substring(0, 2)),
                                              number: Get.find<PaymentLogic>()
                                                  .cardNumberController
                                                  .text
                                                  .toString()
                                                  .replaceAll(' ', ''),
                                              cvc: Get.find<PaymentLogic>()
                                                  .cardCVCController
                                                  .text
                                                  .toString()))
                                          .then((token) async {
                                        log('Token-->>${token.tokenId}');

                                        Get.find<PaymentLogic>().paymentToken =
                                            token.tokenId;
                                        Get.find<PaymentLogic>().update();
                                        FirebaseFirestore.instance
                                            .collection('credit_cards')
                                            .doc()
                                            .set({
                                          'uid': Get.find<GeneralController>()
                                              .boxStorage
                                              .read('uid'),
                                          'card_number':
                                              Get.find<PaymentLogic>()
                                                  .cardNumberController
                                                  .text
                                                  .toString()
                                                  .replaceAll(' ', ''),
                                          'card_expiry_month':
                                              Get.find<PaymentLogic>()
                                                  .cardExpiryController
                                                  .text
                                                  .toString()
                                                  .substring(0, 2),
                                          'card_expiry_year':
                                              Get.find<PaymentLogic>()
                                                  .cardExpiryController
                                                  .text
                                                  .toString()
                                                  .substring(3, 5),
                                          'card_cvc': Get.find<PaymentLogic>()
                                              .cardCVCController
                                              .text
                                              .toString(),
                                        });

                                        Get.find<GeneralController>()
                                            .updateFormLoader(false);
                                        customProceedDialog(context1);
                                        // var response =
                                        //     await StripeService.createCharge(
                                        //         token.tokenId!,
                                        //         Get.find<CartLogic>()
                                        //             .grandTotal!
                                        //             .toPrecision(2),
                                        //         'USD',
                                        //         context1);

                                        if (coupanDocumentSnapshot != null) {
                                          var updageCoupanUsage = int.parse(
                                                  coupanDocumentSnapshot
                                                      .get('usageLimit')) -
                                              1;
                                          print(
                                              '111111111111 ${updageCoupanUsage}');
                                          await coupanDocumentSnapshot.reference
                                              .set({
                                            'usageLimit': updageCoupanUsage
                                          }, SetOptions(merge: true));
                                        }
                                      }).catchError((e) {
                                        Get.find<GeneralController>()
                                            .updateFormLoader(false);
                                        Get.snackbar(
                                          'Incorrect Card Details',
                                          '',
                                          colorText: Colors.white,
                                          backgroundColor:
                                              customThemeColor.withOpacity(0.7),
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(15),
                                        );
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: customThemeColor,
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Text(
                                          'SAVE',
                                          style: GoogleFonts.jost(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
