import 'package:flutter/material.dart';

import '../../utils/color.dart';

class OrderDetailState {
  TextStyle? appBarTextStyle;
  TextStyle? restaurantNameTextStyle;
  TextStyle? otpTextStyle;
  TextStyle? productNameTextStyle;
  TextStyle? productPriceTextStyle;
  TextStyle? billValueTextStyle;
  TextStyle? billLabelTextStyle;
  TextStyle? discountPercentTextStyle;
  TextStyle? grandTotalTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? restaurantInfoLabelTextStyle;
  TextStyle? restaurantInfoValueTextStyle;
  OrderDetailState() {
    ///Initialize variables
    appBarTextStyle = const TextStyle(         fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',);
    
    
    restaurantNameTextStyle = const TextStyle(         fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',);
    

    otpTextStyle = const TextStyle(          fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white,
    fontFamily: 'Poppins',);

    productNameTextStyle =  const TextStyle(   fontSize: 17, fontWeight: FontWeight.w600, color: customTextGreyColor,
    fontFamily: 'Poppins',);          
    
    
    productPriceTextStyle =  const TextStyle(     fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
    
    
    billValueTextStyle =  const TextStyle(     fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
    
 
    billLabelTextStyle =  const TextStyle(       fontSize: 17, fontWeight: FontWeight.w900, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
    

    discountPercentTextStyle = const TextStyle(     fontSize: 15, fontWeight: FontWeight.w700, color: Colors.green,
    fontFamily: 'Poppins',); 
    
   
    grandTotalTextStyle =  const TextStyle(      fontSize: 25, fontWeight: FontWeight.w900, color: customThemeColor,
    fontFamily: 'Poppins',); 
    
    buttonTextStyle = const TextStyle(        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black,
    fontFamily: 'Poppins',); 

    restaurantInfoLabelTextStyle = const TextStyle(      fontSize: 13, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
    
    restaurantInfoValueTextStyle =  const TextStyle(       fontSize: 13, fontWeight: FontWeight.w600, color: customTextGreyColor,
    fontFamily: 'Poppins',); 
 
  }
}
