import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../controllers/general_controller.dart';
import '../../route_generator.dart';
import '../../utils/color.dart';
import '../../widgets/custom_dialog.dart';
import '../home/logic.dart';
import 'state.dart';

class ProductDetailLogic extends GetxController {
  final state = ProductDetailState();

  int? cartCount = 1;
  int? maxCartCount = 0;
  updateCartCount(int? newValue) {
    cartCount = newValue;
    update();
  }

  double? averageRating = 0;
  currentProduct(DocumentSnapshot? productModel, String? collection) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(collection!)
        .where("id", isEqualTo: productModel!.get('id'))
        .get();

    if (query.docs.isNotEmpty) {
      log('PRODUCT---->>>${query.docs[0].get('name')}');
      if (query.docs[0].get('ratings').length > 0) {
        for (int i = 0; i < query.docs[0].get('ratings').length; i++) {
          averageRating = query.docs[0].get('ratings')[i] + averageRating;
        }
        averageRating = averageRating! / query.docs[0].get('ratings').length;
      }
      update();
    } else {}
  }

  getCartInfoForProduct(DocumentSnapshot? productModel) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('cart')
        .where("product_id", isEqualTo: productModel!.get('id'))
        .get();

    if (query.docs.isNotEmpty) {
      maxCartCount = int.parse(query.docs[0].get('quantity').toString());
      update();
    }
  }

  ///---random-string-open
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  math.Random rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  addToCart(BuildContext context, DocumentSnapshot? productModel) async {
    try {
      bool? forUpdate = false;
      bool? deletePreviousCart = false;
      String? forUpdateId;
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('cart')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();

      if (query.docs.isNotEmpty) {
        query.docs.forEach((element) {
          if (element.get('product_id').toString() ==
              productModel!.get('id').toString()) {
            forUpdate = true;
            forUpdateId = element.id;
            log('ExistingID--->>$forUpdateId');
            update();
          }

          if (element.get('restaurant_id').toString() !=
              productModel.get('restaurant_id').toString()) {
            deletePreviousCart = true;
            update();
          }
        });
        if (forUpdate!) {
          FirebaseFirestore.instance
              .collection('cart')
              .doc(forUpdateId)
              .update({
            'quantity': FieldValue.increment(cartCount!),
          });
          Get.find<GeneralController>().updateFormLoader(false);

          Get.snackbar('Cart Updated', '',
              colorText: Colors.white,
              backgroundColor: customThemeColor.withOpacity(0.7),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(15), onTap: (GetSnackBar snackBar) {
            Get.toNamed(PageRoutes.cart);
          });

          Get.find<HomeLogic>().getCartCount();
        } else if (!deletePreviousCart!) {
          ///---new-add
          FirebaseFirestore.instance.collection('cart').doc().set({
            'restaurant': productModel!.get('restaurant'),
            'restaurant_id': productModel.get('restaurant_id'),
            'restaurant_image': productModel.get('image'),
            'quantity': cartCount,
            'max_quantity': productModel.get('quantity'),
            'original_price': productModel.get('original_price'),
            'dis_price': productModel.get('dis_price'),
            'discount': productModel.get('discount'),
            'name': productModel.get('name'),
            'chef_note': productModel.get('chef_note'),
            'category': productModel.get('category'),
            'image': productModel.get('image'),
            'couponStatus' : productModel.get('couponStatus'),
            'couponCode': productModel.get('couponCode'),
            'couponValue': productModel.get('couponValue'),
            'couponType' :productModel.get('couponType'),
            'uid': Get.find<HomeLogic>().currentUserData!.get('uid'),
            'product_id': productModel.get('id'),
            'id': getRandomString(5),
            'isApplyCoupon' : false
          });
          Get.find<GeneralController>().updateFormLoader(false);
          Get.snackbar('Added To Cart', '',
              colorText: Colors.white,
              backgroundColor: customThemeColor.withOpacity(0.7),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(15), onTap: (GetSnackBar snackBar) {
            Get.toNamed(PageRoutes.cart);
          });

          Get.find<HomeLogic>().getCartCount();
        } else {
          Get.find<GeneralController>().updateFormLoader(false);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: 'INFO!',
                  titleColor: customDialogInfoColor,
                  descriptions:
                      'This Product Belongs To different Restaurant. If You Want To Add This Product Then Clear Your Cart Please',
                  text: 'Ok',
                  functionCall: () {
                    Navigator.pop(context);
                  },
                  img: 'assets/dialog_Info.svg',
                );
              });
        }
      } else {
        ///---new-add
        FirebaseFirestore.instance.collection('cart').doc().set({
          'restaurant': productModel!.get('restaurant'),
          'restaurant_id': productModel.get('restaurant_id'),
          'restaurant_image': productModel.get('image'),
          'quantity': cartCount,
          'max_quantity': productModel.get('quantity'),
          'original_price': productModel.get('original_price'),
          'dis_price': productModel.get('dis_price'),
          'discount': productModel.get('discount'),
          'name': productModel.get('name'),
          'chef_note': productModel.get('chef_note'),
          'category': productModel.get('category'),
          'image': productModel.get('image'),
          'uid': Get.find<HomeLogic>().currentUserData!.get('uid'),
          'product_id': productModel.get('id'),
          'id': getRandomString(5),
          'isApplyCoupon' : false,
          'couponStatus' : productModel.get('couponStatus'),
          'couponCode': productModel.get('couponCode'),
          'couponValue': productModel.get('couponValue'),
          'couponType' :productModel.get('couponType'),
        });
        Get.find<GeneralController>().updateFormLoader(false);
        Get.find<HomeLogic>().getCartCount();
        Get.snackbar('Added To Cart', '',
            colorText: Colors.white,
            backgroundColor: customThemeColor.withOpacity(0.7),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(15), onTap: (GetSnackBar snackBar) {
          Get.toNamed(PageRoutes.cart);
        });

        Get.find<HomeLogic>().getCartCount();
      }
      getCartInfoForProduct(productModel);
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
}
