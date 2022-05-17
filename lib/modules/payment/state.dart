import 'package:flutter/material.dart';

import '../../utils/color.dart';

class PaymentState {
  TextStyle? appBarTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? headingTextStyle;
  TextStyle? titleTextStyle;

  PaymentState() {
    ///Initialize variables
    appBarTextStyle =  const TextStyle(        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
    
 
    buttonTextStyle =const TextStyle(        fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black,
    fontFamily: 'Poppins',); 
    
  
    headingTextStyle = const TextStyle(        fontSize: 17, fontWeight: FontWeight.w900, color: customTextGreyColor,
    fontFamily: 'Poppins',); 

    titleTextStyle = const TextStyle(       fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black,
    fontFamily: 'Poppins',); 
    
   
  }
}
