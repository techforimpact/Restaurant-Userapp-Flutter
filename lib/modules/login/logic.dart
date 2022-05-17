import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/general_controller.dart';
import '../../route_generator.dart';
import '../../widgets/custom_dialog.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final state = LoginState();

  String? loginPhoneNumber;

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AnimationController? loginTimerAnimationController;

  bool? otpSendCheckerLogin = false;
  updateOtpSendCheckerLogin(bool? newValue) {
    otpSendCheckerLogin = newValue;
    update();
  }

  String? loginOtp;
  String? verificationIDForVerify;

  Future<bool?> otpFunction(String? phone, BuildContext context) async {
    log('-----------------OtpFunctionStartHere-----------------');
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: phone!,
      timeout: const Duration(seconds: 55),
      verificationCompleted: (AuthCredential credential) async {
        log('Credential from verificationCompleted ---->> $credential');
      },
      verificationFailed: (FirebaseAuthException exception) {
        log('Exception ---->> ${exception.message}');
      },
      codeSent: (String? verificationId, [int? forceResendingToken]) {
        verificationIDForVerify = verificationId;
        log('verificationId ---->> $verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTP(BuildContext context, var otp, bool fromSignup) async {
    log('--------------VerifyOtpStartsHere--------------');
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDForVerify!,
        smsCode: otp,
      );

      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: user!.uid)
          .get();

      if (query.docs.isNotEmpty) {
        log('user exist');

        Get.find<GeneralController>().boxStorage.write('uid', user.uid);
        Get.find<GeneralController>().boxStorage.write('session', 'active');
        Get.find<GeneralController>().boxStorage.write('loginType', 'phone');
        Get.offAllNamed(PageRoutes.home);
        Get.find<GeneralController>().updateFormLoader(false);
      } else {
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': 'guest',
          'phone': loginPhoneNumber,
          'email': '',
          'image': '',
          'address': '',
          'lng': '',
          'lat': '',
          'role': 'customer',
          'uid': user.uid,
        });

 
        Get.find<GeneralController>().boxStorage.write('uid', user.uid);
        Get.find<GeneralController>().boxStorage.write('session', 'active');
        Get.find<GeneralController>().boxStorage.write('loginType', 'phone');
        Get.offAllNamed(PageRoutes.home);
        Get.find<GeneralController>().updateFormLoader(false);
      }

      log('Credential ---->> $credential');
    } catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'FAILED!',
              titleColor: Colors.red,
              descriptions: 'Incorrect OTP',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/dialog_error.svg',
            );
          });
      log('Exception --->> ${e}');
    }
  }
}
