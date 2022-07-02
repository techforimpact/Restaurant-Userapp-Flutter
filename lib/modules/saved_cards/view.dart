import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_table/utils/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({Key? key}) : super(key: key);

  @override
  State<SavedCardsPage> createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  final SavedCardsLogic logic = Get.put(SavedCardsLogic());

  final SavedCardsState state = Get.find<SavedCardsLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //!-------------payment
    // StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.all(0),
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
                  const Text(
                    'swipe on Card to delete',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: customTextGreyColor),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'My Saved Cards',
                style: kGreetingsStyle,
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
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      log('Waiting');
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 5, 0, 5),
                            child: SizedBox(
                              height: 165,
                              width: MediaQuery.of(context).size.width * .8,
                              child: SkeletonLoader(
                                period: const Duration(seconds: 2),
                                highlightColor: Colors.grey,
                                direction: SkeletonDirection.ltr,
                                builder: Container(
                                  height: 165,
                                  width: MediaQuery.of(context).size.width * .8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
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
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Center(
                                  child: Text(
                                    'No Saved Card Found',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
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
                        return FadedSlideAnimation(
                          child: Wrap(
                            children: List.generate(
                                snapshot.data!.docs.length,
                                (index) => Slidable(
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          SizedBox(width: 40,),
                                          InkWell(
                                            onTap: () {
                                              showAnimatedDialog(
                                                  animationType:
                                                      DialogTransitionType.size,
                                                  curve: Curves.fastOutSlowIn,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Delete'),
                                                      content: Text(
                                                          "Do you want to delete it"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("No",
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .blue))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'credit_cards')
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete();
                                                            },
                                                            child: Text("Yes",
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .blue))),
                                                      ],
                                                    );
                                                  });
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

                                          // SlidableAction(
                                          //   onPressed:
                                          //       (BuildContext context) {},
                                          //   backgroundColor: Colors.transparent,
                                          //   foregroundColor: Colors.white,
                                          //   icon:

                                          // ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
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
                                                style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
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
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Center(
                                child: Text(
                                  'No Saved Card Found',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
        child: InkWell(
          onTap: () {
            customPaymentDialog(context);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: customThemeColor,
                borderRadius: BorderRadius.circular(30)),
            child: const Center(
              child: Text(
                'Add Card',
                style: kTopHeadingStyle,
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
  customPaymentDialog(BuildContext context1) {
    Get.find<SavedCardsLogic>().cardNumberController.clear();
    Get.find<SavedCardsLogic>().cardExpiryController.clear();
    Get.find<SavedCardsLogic>().cardCVCController.clear();
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
                              Get.find<SavedCardsLogic>().cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(19),
                            cardNumberMask
                          ],
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Card number',
                            labelStyle: TextStyle(
                                fontFamily: 'Poppins', color: customThemeColor),
                            hintText: '1234 1234 1234 1234',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
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
                                  controller: Get.find<SavedCardsLogic>()
                                      .cardExpiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5),
                                    cardExpiryMask
                                  ],
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Expiry date',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: customThemeColor),
                                    hintText: 'MM/YY',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
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
                                  controller: Get.find<SavedCardsLogic>()
                                      .cardCVCController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'CVC',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: customThemeColor),
                                    hintText: '123',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Poppins',
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
                                      log('CardNumber--->>${Get.find<SavedCardsLogic>().cardNumberController.text.replaceAll(' ', '')}');
                                      log('CardExpiry--->>${Get.find<SavedCardsLogic>().cardExpiryController.text.toString().substring(0, 2)}');
                                      log('CardExpiry--->>${Get.find<SavedCardsLogic>().cardExpiryController.text.toString().substring(3, 5)}');
                                      log('CardCVC--->>${Get.find<SavedCardsLogic>().cardCVCController.text}');
                                      StripePayment.createTokenWithCard(CreditCard(
                                              expYear: 20 +
                                                  int.parse(Get.find<
                                                          SavedCardsLogic>()
                                                      .cardExpiryController
                                                      .text
                                                      .toString()
                                                      .substring(3, 5)),
                                              expMonth: int.parse(
                                                  Get.find<SavedCardsLogic>()
                                                      .cardExpiryController
                                                      .text
                                                      .toString()
                                                      .substring(0, 2)),
                                              number:
                                                  Get.find<SavedCardsLogic>()
                                                      .cardNumberController
                                                      .text
                                                      .toString()
                                                      .replaceAll(' ', ''),
                                              cvc: Get.find<SavedCardsLogic>()
                                                  .cardCVCController
                                                  .text
                                                  .toString()))
                                          .then((token) async {
                                        log('Token-->>${token.tokenId}');

                                        FirebaseFirestore.instance
                                            .collection('credit_cards')
                                            .doc()
                                            .set({
                                          'uid': Get.find<GeneralController>()
                                              .boxStorage
                                              .read('uid'),
                                          'card_number':
                                              Get.find<SavedCardsLogic>()
                                                  .cardNumberController
                                                  .text
                                                  .toString()
                                                  .replaceAll(' ', ''),
                                          'card_expiry_month':
                                              Get.find<SavedCardsLogic>()
                                                  .cardExpiryController
                                                  .text
                                                  .toString()
                                                  .substring(0, 2),
                                          'card_expiry_year':
                                              Get.find<SavedCardsLogic>()
                                                  .cardExpiryController
                                                  .text
                                                  .toString()
                                                  .substring(3, 5),
                                          'card_cvc':
                                              Get.find<SavedCardsLogic>()
                                                  .cardCVCController
                                                  .text
                                                  .toString(),
                                        });
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
