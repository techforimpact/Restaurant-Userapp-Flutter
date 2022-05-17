
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';

class CouponsState {
  TextStyle? appBarTextStyle;
  TextStyle? titleTextStyle;
  TextStyle? subTitleTextStyle;
  TextStyle? subTitleTextStyleGreen;
  CouponsState() {
    ///Initialize variables
    appBarTextStyle = const TextStyle( fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',);

    titleTextStyle = const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: customThemeColor,
    fontFamily: 'Poppins',);
    
 
    subTitleTextStyle = const TextStyle( fontSize: 11, fontWeight: FontWeight.w600, color: customTextGreyColor,
    fontFamily: 'Poppins',);
    

    subTitleTextStyleGreen =const TextStyle( fontSize: 17, fontWeight: FontWeight.w900, color: customDialogErrorColor,
    fontFamily: 'Poppins',);
    

  }
}
