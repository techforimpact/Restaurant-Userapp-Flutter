import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashState {
  TextStyle? splashTitleTextStyle;
  SplashState() {
    ///Initialize variables
    splashTitleTextStyle = const TextStyle( fontFamily: 'Poppins',
      fontSize: 30,
      fontWeight: FontWeight.w700,
    );
  }
}
