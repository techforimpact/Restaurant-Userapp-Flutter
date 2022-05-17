import 'package:flutter/material.dart';

import '../../utils/color.dart';

class SavedCardsState {
  TextStyle? headingTextStyle;
  TextStyle? updateButtonStyle;
  SavedCardsState() {
    ///Initialize variables
    headingTextStyle =  const TextStyle(
    fontFamily: 'Poppins',

        fontSize: 34, fontWeight: FontWeight.w800, color: customThemeColor);
    

    updateButtonStyle =  const TextStyle(
    fontFamily: 'Poppins',

         fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
    
    
  }
}
