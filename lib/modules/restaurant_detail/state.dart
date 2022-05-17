import 'package:flutter/material.dart';

import '../../utils/color.dart';

class RestaurantDetailState {
  TextStyle? productNameStyle;
  TextStyle? productPriceStyle;
  TextStyle? productDescStyle;
  TextStyle? cartButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? descTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? restaurantInfoLabelTextStyle;
  TextStyle? restaurantInfoValueTextStyle;
  RestaurantDetailState() {
    ///Initialize variables
    productNameStyle =const TextStyle(
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w800, fontSize: 28, color: customTextGreyColor);
    
    
    
    productPriceStyle = const TextStyle(
    fontFamily: 'Poppins',

      fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white);
    
     
    productDescStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontWeight: FontWeight.w400, fontSize: 15, color: customTextGreyColor);
    

    cartButtonStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
    
     

    headingTextStyle = const TextStyle(
    fontFamily: 'Poppins',

        fontWeight: FontWeight.w900, fontSize: 17, color: customTextGreyColor);
    
  
    descTextStyle = const TextStyle(
    fontFamily: 'Poppins',

    fontWeight: FontWeight.w600, fontSize: 15, color: customTextGreyColor);
    
     
    nameTextStyle = const TextStyle(
    fontFamily: 'Poppins',

   fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    

    priceTextStyle =  TextStyle(
    fontFamily: 'Poppins',

      fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
  
    restaurantInfoLabelTextStyle = const TextStyle(
    fontFamily: 'Poppins',

        fontSize: 13, fontWeight: FontWeight.w800, color: customTextGreyColor);
    
    
    restaurantInfoValueTextStyle = const TextStyle(
    fontFamily: 'Poppins',

       fontSize: 13, fontWeight: FontWeight.w600, color: customTextGreyColor);
    

  }
}
