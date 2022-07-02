import 'package:flutter/material.dart';

import '../../utils/color.dart';

class CartState {
  TextStyle? appBarTextStyle;
  TextStyle? swipeTextStyle;
  TextStyle? productNameTextStyle;
  TextStyle? productPriceTextStyle;
  TextStyle? productQuantityTextStyle;
  TextStyle? billValueTextStyle;
  TextStyle? billLabelTextStyle;
  TextStyle? discountPercentTextStyle;
  TextStyle? grandTotalTextStyle;
  TextStyle? buttonTextStyle;
  TextStyle? billLabelTextStyleWithCustomColor;
  CartState() {
    ///Initialize variables
    appBarTextStyle =const TextStyle(color: customTextGreyColor, fontSize: 28, fontWeight: FontWeight.w800,
    fontFamily: 'Poppins',

); 
    

    swipeTextStyle =const TextStyle(color: customTextGreyColor,fontSize: 10, fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',

); 
    
    
    productNameTextStyle = const TextStyle(color: customTextGreyColor,fontSize: 17, fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',

); 
 
    productPriceTextStyle =const TextStyle(color: customTextGreyColor,fontSize: 15, fontWeight: FontWeight.w700, 
    fontFamily: 'Poppins',

); 
    
    productQuantityTextStyle = const TextStyle(color: customTextGreyColor,  fontSize: 13, fontWeight: FontWeight.w600, 
    fontFamily: 'Poppins',

); 
    
   
    billValueTextStyle =  const TextStyle(color: customTextGreyColor,    fontSize: 15, fontWeight: FontWeight.w700, 
    fontFamily: 'Poppins',

); 
    
  
    billLabelTextStyle = billValueTextStyle =  const TextStyle(color: customTextGreyColor,    fontSize: 17, fontWeight: FontWeight.w700, 
    fontFamily: 'Poppins',

); 
    
    
    discountPercentTextStyle = const TextStyle( fontSize: 15, fontWeight: FontWeight.w700, color: Colors.green ,
    fontFamily: 'Poppins',

); 
    
   
    grandTotalTextStyle =  const TextStyle(  fontSize: 25, fontWeight: FontWeight.w900, color: customThemeColor,
    fontFamily: 'Poppins',

); 
    
   
    buttonTextStyle = const TextStyle(  fontSize: 17, fontWeight: FontWeight.w900, color: Colors.black,
    fontFamily: 'Poppins',

); 
     
    billLabelTextStyleWithCustomColor = const TextStyle(  fontSize: 15, fontWeight: FontWeight.w700, color: customThemeColor,
    fontFamily: 'Poppins', 

); 
  
  }
}
