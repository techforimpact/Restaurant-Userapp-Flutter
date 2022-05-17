import 'package:flutter/material.dart';

import '../../utils/text_style.dart';


class ProfileState {
  TextStyle? updateButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? subHeadingTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? detailTextStyle;
  TextStyle? tileTitleTextStyle = kTopHeadingStyle;
  ProfileState() {
    ///Initialize variables
    updateButtonStyle = kTopHeadingStyle;
    headingTextStyle = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 1.2,
    color: Colors.black,
    letterSpacing: 0.8);
    subHeadingTextStyle =  const TextStyle(
    fontFamily: 'Poppins',
      fontSize: 18, fontWeight: FontWeight.w700,);
    
   
    nameTextStyle = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18, fontWeight: FontWeight.w900,);
    
 
    detailTextStyle =   TextStyle(
    fontFamily: 'Poppins',
     fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.5));
    
  
    tileTitleTextStyle =kTopHeadingStyle;}
}
