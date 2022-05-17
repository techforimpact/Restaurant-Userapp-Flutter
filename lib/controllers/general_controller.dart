import 'dart:developer';

import 'package:book_a_table/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/color.dart';

class GeneralController extends GetxController {
  GetStorage boxStorage = GetStorage();
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  DocumentReference<Map<String, dynamic>> ?tableBookingDocumentReference;
  focusOut(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  bool? formLoader = false;
  updateFormLoader(bool? newValue) {
    formLoader = newValue;
    update();
  }

  Future<void> makePhoneCall(String? phoneNumber) async {
    final uri = 'tel:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  checkWishList(BuildContext context, String? id, Function? checkChange) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();

      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          if (element.get('w_id').toString() == id) {
            checkChange!(true);
            update();
          }
        }
      } else {}
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

  deleteWishList(
    BuildContext context,
    String? id,
  ) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where('w_id', isEqualTo: id)
          .get();
      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          FirebaseFirestore.instance
              .collection('wishList')
              .doc(element.id)
              .delete();
        }
      }
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

  addToWishList(BuildContext context, String? id, String? type) async {
    try {
      bool? forNew = true;
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('wishList')
          .where("uid",
              isEqualTo: Get.find<GeneralController>().boxStorage.read('uid'))
          .get();

      if (query.docs.isNotEmpty) {
        for (var element in query.docs) {
          if (element.get('w_id').toString() == id) {
            forNew = false;
            update();
            Get.snackbar(
              'Already Added',
              '',
              colorText: Colors.white,
              backgroundColor: customThemeColor.withOpacity(0.7),
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(15),
            );
          }
        }
        if (forNew!) {
          FirebaseFirestore.instance.collection('wishList').doc().set({
            'w_id': id,
            'uid': Get.find<GeneralController>().boxStorage.read('uid'),
            'type': type
          });
          Get.snackbar(
            'Added To Favorites',
            '',
            colorText: Colors.white,
            backgroundColor: customThemeColor.withOpacity(0.7),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(15),
          );
        }
      } else {
        FirebaseFirestore.instance.collection('wishList').doc().set({
          'w_id': id,
          'uid': Get.find<GeneralController>().boxStorage.read('uid'),
          'type': type
        });
        Get.snackbar(
          'Added To Favorites',
          '',
          colorText: Colors.white,
          backgroundColor: customThemeColor.withOpacity(0.7),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      }
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
