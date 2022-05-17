import 'package:flutter/material.dart';

import '../../utils/color.dart';

class SearchState {
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  SearchState() {
    ///Initialize variables
    nameTextStyle =  const TextStyle(
    fontFamily: 'Poppins',

          fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    
    const TextStyle( fontFamily: 'Poppins',
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    priceTextStyle =  TextStyle(
    fontFamily: 'Poppins',

       fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
    
    
  }
}
