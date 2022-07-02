import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stripe_payment/stripe_payment.dart';

import '../../controllers/general_controller.dart';
import '../../route_generator.dart';
import '../../utils/color.dart';
import '../cart/logic.dart';
import '../home/logic.dart';
import 'logic.dart';

//stripe services payment gateway

class StripeTransactionResponse {
  String? message;
  bool? success;

  StripeTransactionResponse({
    this.message,
    this.success,
  });
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51JKmkhFBosdk9Yje0xlj0CfDiZdzI6xPTHBNkJL0WB6afL3wB3VPswVqPH41lpdxso9zKrgHMjoGar0DgcPYmBUc00e0DlY9z4  ';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51JKmkhFBosdk9YjermAtiFKMuNJKmw6TQTNtqndsZNe250P5ZFKb3FlyAwb5YcUOfuwpF6WJLbuMr51YEYUrXpnN00IERZrMrb",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  // static Future<PaymentResponse> choseExistingCard(
  //     {String? amount, String? currency, CreditCard? card}) async {
  //   try {
  //     var stripePaymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
  //     var stripePaymentIntent = await StripeService.createPaymentIntent(amount, currency);
  //     var response = await StripePayment.confirmPaymentIntent(
  //         PaymentIntent(
  //             clientSecret: stripePaymentIntent['client_secret'],
  //             paymentMethodId: stripePaymentMethod.id
  //         )
  //     );
  //
  //     if (response.status == 'succeeded') {
  //       //if the payment process success
  //       return new StripeTransactionResponse(
  //           message: 'Transaction successful',
  //           success: true
  //       );
  //     }else {
  //       //payment process fail
  //       return new StripeTransactionResponse(
  //           message: 'Transaction failed',
  //           success: false
  //       );
  //     }
  //   } on PlatformException catch (error) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (error) {
  //     return new StripeTransactionResponse(
  //       //convert the error to string and assign to message variable for json resposne
  //         message: 'Transaction failed: ${error.toString()}',
  //         success: false
  //     );
  //   }
  // }
  static Future<StripeTransactionResponse> payViaExistingCard(
      {String? amount, String? currency, CreditCard? card}) async {
    var stripePaymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card));
    var stripePaymentIntent =
        await StripeService.createPaymentIntent(amount, currency);
    var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: stripePaymentIntent['client_secret'],
        paymentMethodId: stripePaymentMethod.id));
    if (response.status == 'succeeded') {
      //if the payment process success
      return StripeTransactionResponse(
          message: 'Transaction successful', success: true);
    } else {
      //payment process fail
      return StripeTransactionResponse(
          message: 'Transaction failed', success: false);
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String? amount, String? currency, BuildContext? context}) async {
        
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      log('Payment Success--->>>${jsonEncode(paymentMethod)}');
      customProceedDialog(context!);

      return StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } catch (err) {
      Get.snackbar(
        'FAILED!',
        'Transaction Failed',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      return StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false,
      );
    }
  }

  static Future<Map<String, dynamic>> createCharge(String tokenId,
      double amount, String currency, BuildContext context) async {
    var response;
    try {
      Map<String, dynamic> body = {
        'amount': '${(amount * 100).toInt()}',
        'currency': currency,
        'source': tokenId,
        'description': 'Restaurent Order'
      };
      log('MAP-->>$body');
      response = await http.post(Uri.parse('https://api.stripe.com/v1/charges'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      // Get.find<GeneralController>().updateFormLoader(false);

      log('success charging user: ${jsonDecode(response.body)}');

      Get.find<PaymentLogic>().placeOrder();
      return jsonDecode(response.body);
    } catch (err) {
      Get.find<GeneralController>().updateFormLoader(false);
      log('err charging user: ${err.toString()}');
    }
    return {};
  }

  static createPaymentIntent(String? amount, String? currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types': 'card'
      };

      var response = await http.post(Uri.parse(StripeService.paymentApiUrl),
          body: body, headers: StripeService.headers);

      log('createPaymentIntent: ${response.body}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
    return null;
  }

  static Future<StripeTransactionResponse> payNowHandler(
      {required String amount, required String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));

      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction succeful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed in the catch block', success: false);
    }
  }
}

customProceedDialog(BuildContext context) {
  return showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///---header
                  Container(
                    height: 66,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 15, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Please note',
                              textAlign: TextAlign.start,
                              style: TextStyle( fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: customTextGreyColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///---body
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pick up from ${Get.find<PaymentLogic>().restName}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        Text(
                          '${Get.find<PaymentLogic>().restAddress}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Restaurent opening Time',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        Text(
                          '${Get.find<PaymentLogic>().restTime}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  ///---footer
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.find<GeneralController>()
                                  .updateFormLoader(true);
                              Navigator.pop(context);
                              var response = await StripeService.createCharge(
                                  Get.find<PaymentLogic>().paymentToken!,
                                  Get.find<CartLogic>()
                                      .grandTotal!
                                      .toPrecision(2),
                                  'USD',
                                  context);
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: customThemeColor,
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Text(
                                    'Proceed',
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
        );
      });
}

customConfirmDialog(BuildContext context ,  ) {
  return showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Transform.scale(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///---header
                    Container(
                      height: 66,
                      decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Order Successfully Placed',
                                textAlign: TextAlign.start,
                                style: TextStyle( fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: customTextGreyColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///---body
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick up from ${Get.find<PaymentLogic>().restName}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          Text(
                            '${Get.find<PaymentLogic>().restAddress}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Restaurent opening Time',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          Text(
                            '${Get.find<PaymentLogic>().restTime}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        
                          
                        ],
                      ),
                    ),

                    ///---footer
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);

                                Get.offAllNamed(PageRoutes.allOrders);

                                Get.find<HomeLogic>().getCartCount();
                                Get.snackbar(
                                  'Order Placed Successfully',
                                  '',
                                  colorText: Colors.white,
                                  backgroundColor:
                                      customThemeColor.withOpacity(0.7),
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(15),
                                );
                              },
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: customThemeColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(
                                      'Track Order',
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
        );
      });
}
