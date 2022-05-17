
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class OffsetController extends GetxController {

  double _page = 0;

  double get page => _page;

  OffsetController(PageController pageController){

    pageController.addListener(() {

      _page = pageController.page?? 0;
      update();
    });
  }
}