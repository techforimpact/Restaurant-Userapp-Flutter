import 'package:flutter/material.dart';

import '../../utils/color.dart';


class ForgetPasswordState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? doNotTextStyle;
  TextStyle? registerTextStyle;
  ForgetPasswordState() {
    ///Initialize variables
    labelTextStyle =  TextStyle(    fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4),
    fontFamily: 'Poppins',);

    buttonTextStyle = const TextStyle(      fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black,
    fontFamily: 'Poppins',);

    doNotTextStyle = const TextStyle(      fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black38,
    fontFamily: 'Poppins',);
    

    registerTextStyle = const TextStyle(        fontSize: 15, fontWeight: FontWeight.normal, color: customThemeColor,
    fontFamily: 'Poppins',);
  
  }
}
