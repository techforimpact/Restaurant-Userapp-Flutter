import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'state.dart';

class RatingReviewLogic extends GetxController {
  final state = RatingReviewState();
  
  var focusNode=FocusNode();
  TextEditingController reviewController = TextEditingController();
  double? ratingValue = 0;
  updateRatingValue(double? newValue) {
    ratingValue = newValue;
    update();
  }
}
