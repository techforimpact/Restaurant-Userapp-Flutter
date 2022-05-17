import 'package:flutter/material.dart';

import '../../utils/color.dart';

class SignUpState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? doNotTextStyle;
  TextStyle? registerTextStyle;
  SignUpState() {
    ///Initialize variables
    labelTextStyle = TextStyle( fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4));
    buttonTextStyle = const TextStyle( fontFamily: 'Poppins',
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black);
    doNotTextStyle = const TextStyle( fontFamily: 'Poppins',
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black38);
    registerTextStyle = const TextStyle( fontFamily: 'Poppins',
        fontSize: 15, fontWeight: FontWeight.normal, color: customThemeColor);
  }
}
