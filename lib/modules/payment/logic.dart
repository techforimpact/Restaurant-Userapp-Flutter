import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import '../../controllers/fcm_controller.dart';
import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../cart/logic.dart';
import '../home/logic.dart';
import 'state.dart';
import 'stripe_service.dart';

class PaymentLogic extends GetxController {
  final state = PaymentState();

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryController = TextEditingController();
  TextEditingController cardCVCController = TextEditingController();

  int? cardRadioGroupValue = 1;
  int? bankRadioGroupValue = 2;
  int? radioValue = 0;
  updateRadioValue(int? newValue) {
    radioValue = newValue;
    update();
  }

  String? paymentToken;

  ///---random-string-open
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String charsForOtp = '1234567890';
  math.Random rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  String getRandomOtp(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => charsForOtp.codeUnitAt(rnd.nextInt(charsForOtp.length))));
  placeOrder() async {
    try {
      String? getOtp = getRandomOtp(5);


      update();
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('cart')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();
      QuerySnapshot queryForRestImage = await FirebaseFirestore.instance
          .collection('restaurants')
          .where("id", isEqualTo: query.docs[0].get('restaurant_id'))
          .get();
      if (query.docs.isNotEmpty) {
        FirebaseFirestore.instance.collection('orders').add({
          'restaurant': query.docs[0].get('restaurant'),
          'restaurant_id': query.docs[0].get('restaurant_id'),
          'isTakeAway': Get.find<CartLogic>().radioValue!,
          'restaurant_image': queryForRestImage.docs[0].get('image'),
          'total_price': Get.find<CartLogic>().totalPrice!.toPrecision(2),
          'total_discount': Get.find<CartLogic>().totalDiscount!.toPrecision(2),
          'coupon_discount': Get.find<CartLogic>().couponDiscount,
          'total_discount_percentage':
              ((double.parse(Get.find<CartLogic>().totalDiscount.toString()) /
                          double.parse(
                              Get.find<CartLogic>().totalPrice.toString())) *
                      100)
                  .toPrecision(2),
          'charity': Get.find<CartLogic>().hideCharity! ? 0 : 1,
          'net_price': Get.find<CartLogic>().netPrice!.toPrecision(2),
          'grand_total': Get.find<CartLogic>().grandTotal!.toPrecision(2),
          'product_list': List.generate(query.docs.length, (index) {
            return {
              'quantity': query.docs[index].get('quantity'),
              'original_price': query.docs[index].get('original_price'),
              'dis_price': query.docs[index].get('dis_price'),
              'discount': query.docs[index].get('discount'),
              'name':
                   query.docs[index].get('name'),
              'chef_note': query.docs[index].get('chef_note'),
              'category': query.docs[index].get('category'),
              'image': query.docs[index].get('image'),
              'product_id': query.docs[index].get('product_id'),
            };
          }),
          'customerName': Get.find<HomeLogic>().currentUserData!.get('name'),
          'uid': Get.find<HomeLogic>().currentUserData!.get('uid'),
          'date_time': DateTime.now(),
          'status': 'Pending',
          'review_status': 'pending',
          'otp': getOtp,
          'id': getRandomString(5),
        }).then((value) {
            Get.find<GeneralController>()
                                .tableBookingDocumentReference?.update({
'orderReference': value.id
                                }).then((value) {
                                  Get.find<GeneralController>()
                                .tableBookingDocumentReference=null;
                                });
        });
        // Get.find<GeneralController>().updateFormLoader(false);

        QuerySnapshot queryForFcm = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isEqualTo: queryForRestImage.docs[0].get('uid_id'))
            .get();
            //!-----------------------
        try {
          sendNotificationCall(
              queryForFcm.docs[0].get('token'),
              'Order received ${query.docs[0].get('name')} ',
              ' : ');
              print('notification for restuarent');
        } on FirebaseException catch (e) {
          print('for personal notifcation sending exception with messsage ${e.message}');
        }

        QuerySnapshot queryForFcmPersonal = await FirebaseFirestore.instance
            .collection('users')
            .where("uid",
                isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
            .get();
        try {
          sendNotificationCall(
              queryForFcmPersonal.docs[0].get('token'),
              'Sweet as! Your Restaurent order has been successfully placed with ${query.docs[0].get('restaurant')}',
              ' : ');
              print('notification send for place order to itself');
        } on FirebaseException catch (e) {
          print('notifcation sending exception with messsage ${e.message}');
          
        }

        ///---quantity-set
        query.docs.forEach((element) async {
          QuerySnapshot quantityQuery = await FirebaseFirestore.instance
              .collection('products')
              .where("id", isEqualTo: element.get('product_id'))
              .get();
          if (quantityQuery.docs.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('products')
                .doc(quantityQuery.docs[0].id)
                .update({
              'quantity': FieldValue.increment(
                  -int.parse((element.get('quantity')).toString())),
            });
          }
        });

        ///---delete-cart
        QuerySnapshot deleteQuery = await FirebaseFirestore.instance
            .collection('cart')
            .where("uid",
                isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
            .get();
        if (deleteQuery.docs.isNotEmpty) {
          deleteQuery.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection('cart')
                .doc(element.id)
                .delete();
          });
        }

        
        Get.find<HomeLogic>().getCartCount();
      }

      customConfirmDialog(Get.context!);
      Get.find<GeneralController>().updateFormLoader(false);
    } on FirebaseException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log(e.toString());
    }
  }

  BuildContext? referenceContext;
  updateReferenceContext(BuildContext newValue) {
    referenceContext = newValue;
    update();
  }

  String? restName;
  String? restTime;
  String? restAddress;
  getData() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('cart')
        .where("uid",
            isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
        .get();
    QuerySnapshot queryForRestImage = await FirebaseFirestore.instance
        .collection('restaurants')
        .where("id", isEqualTo: query.docs[0].get('restaurant_id'))
        .get();
    if (queryForRestImage.docs.isNotEmpty) {
      restName = queryForRestImage.docs[0].get('name');
      restAddress = queryForRestImage.docs[0].get('address');
      restTime =
          '${queryForRestImage.docs[0].get('open_time')} - ${queryForRestImage.docs[0].get('close_time')}';
      update();
    }
  }
}
