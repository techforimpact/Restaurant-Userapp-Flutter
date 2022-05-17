import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  EditProfileState() {
    ///Initialize variables
    labelTextStyle = TextStyle(  fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4),
    fontFamily: 'Poppins',);
  
    buttonTextStyle =const TextStyle(   fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white,
    fontFamily: 'Poppins',);
    
   
  }
}
