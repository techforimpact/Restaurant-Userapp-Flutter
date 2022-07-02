
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../modules/login/logic.dart';
import '../modules/sign_up/logic.dart';
import '../route_generator.dart';
import '../utils/color.dart';
import 'general_controller.dart';

class FirebaseAuthentication {

  void signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        Get.find<GeneralController>()
            .boxStorage
            .write('uid', user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('userName', user.displayName);
        log('user exist');
        Get.find<GeneralController>().boxStorage.write('session', 'active');
        Get.find<GeneralController>().boxStorage.write('loginType', 'email');
        Get.find<GeneralController>().updateFormLoader(false);

        Get.offAllNamed(PageRoutes.home);
      } else {
        Get.find<GeneralController>().boxStorage.write('uid', user.uid);
        _firestore.collection('users').doc(user.uid).set({
          'name': 'Guest',
          'phone': user.phoneNumber ?? '',
          'image': user.photoURL ?? '',
          'address': '',
          'role': 'customer',
          'email': user.email,
          'uid': user.uid,
        });

        Get.find<GeneralController>().updateFormLoader(false);
        Get.find<GeneralController>().boxStorage.write('session', 'active');

        Get.offAllNamed(PageRoutes.home);
      }
      log('Google-->>${user.email}');
      // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
    }
  }

  void signInWithEmailAndPassword() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Get.find<LoginLogic>().emailController.text,
        password: Get.find<LoginLogic>().passwordController.text,
      ))
              .user;
            FirebaseFirestore.instance.collection('users').where('email',isEqualTo:  Get.find<LoginLogic>().emailController.text).get().then((value) {
              user?.updateDisplayName(value.docs[0].get('name')) ;
            });
      Get.find<GeneralController>().updateFormLoader(false);
      if (user != null) {
        log(user.uid.toString());
        Get.find<GeneralController>()
            .boxStorage
            .write('uid', user.uid.toString());
        Get.find<GeneralController>()
          .boxStorage
          .write('userName', user.displayName ?? 'annonymus').
        
          then((value) {
            print('complete ');
          }).catchError((value){
            print('error ');
          });   
        log('user exist');
        Get.find<GeneralController>().boxStorage.write('session', 'active');

        Get.find<GeneralController>().boxStorage.write('loginType', 'email');
        Get.offAllNamed(PageRoutes.home);
        Get.find<LoginLogic>().emailController.clear();
        Get.find<LoginLogic>().passwordController.clear();
        Get.find<LoginLogic>().phoneController.clear();
      } else {
        log('user not found');
        Get.find<GeneralController>().boxStorage.remove('session');
      }
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> signUp() async {
    try {
      print('email -----> ${Get.find<SignUpLogic>().emailController.text}');
      print('password -----> ${Get.find<SignUpLogic>().passwordController.text}');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Get.find<SignUpLogic>().emailController.text,
              password: Get.find<SignUpLogic>().passwordController.text)
          .then((user) {
        Get.find<GeneralController>().boxStorage.write('uid', user.user!.uid);
        Get.find<GeneralController>()
          .boxStorage
          .write('userName', Get.find<SignUpLogic>().nameController.text);
        _firestore.collection('users').doc(user.user!.uid).set({
          'name': Get.find<SignUpLogic>().nameController.text,
          'phone': Get.find<SignUpLogic>().phoneNumber,
          'address': Get.find<SignUpLogic>().addressController.text,
      
          'image': Get.find<SignUpLogic>().downloadURL ?? '',
          'email': Get.find<SignUpLogic>().emailController.text,
          'role': 'customer',
          'uid': user.user!.uid,
        });
   
      });
      Get.find<GeneralController>().updateFormLoader(false);
      Get.find<GeneralController>().boxStorage.write('session', 'active');

      Get.find<GeneralController>().boxStorage.write('loginType', 'email');

      Get.offAllNamed(PageRoutes.home);
      print('go to home page');
      Get.find<SignUpLogic>().emailController.clear();
      Get.find<SignUpLogic>().passwordController.clear();
      return true;
    } on FirebaseAuthException catch (e) {
      Get.find<GeneralController>().updateFormLoader(false);
      Get.snackbar(
        e.code,
        '',
        colorText: Colors.white,
        backgroundColor: customThemeColor.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      log('exception while sign up process ');
      log(e.message??'');
      return false;
    }
  }

  Future signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Get.find<GeneralController>().boxStorage.remove('uid');
    Get.find<GeneralController>().boxStorage.remove('session');
    Get.find<GeneralController>().boxStorage.remove('preferences');
    Get.find<GeneralController>().boxStorage.remove('loginType');
    Get.find<GeneralController>().boxStorage.remove('fcmToken');
    Get.offAllNamed(PageRoutes.login);
  }
}
