import 'package:flutter/material.dart';

import '../../utils/color.dart';

class RatingReviewState {
  TextStyle? headingTextStyle;
  TextStyle? titleTextStyle;
  TextStyle? buttonTextStyle;
  RatingReviewState() {
    ///Initialize variables
    headingTextStyle = const TextStyle(
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w800, fontSize: 28, color: customTextGreyColor);
    
    titleTextStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontWeight: FontWeight.w700, fontSize: 20, color: customTextGreyColor);

    buttonTextStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white);
    

  }
}
