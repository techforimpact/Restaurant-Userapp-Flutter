import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';
import 'view_phone_login.dart';

class LoginState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? doNotTextStyle;
  TextStyle? registerTextStyle;
  LoginState() {
    ///Initialize variables
    labelTextStyle =  TextStyle(          fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4),
    fontFamily: 'Poppins',);
    

    buttonTextStyle = const TextStyle(         fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black,
    fontFamily: 'Poppins',);
    

    doNotTextStyle = const TextStyle(         fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black38,
    fontFamily: 'Poppins',);
    

    registerTextStyle = const TextStyle(         fontSize: 15, fontWeight: FontWeight.normal, color: customThemeColor,
    fontFamily: 'Poppins',);
    
  }
}
