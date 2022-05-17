
import 'package:flutter/material.dart';


class HomeState {
  TextStyle? drawerTitleTextStyle;
  TextStyle? homeHeadingTextStyle;
  TextStyle? homeSubHeadingTextStyle;

  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  HomeState() {
    ///Initialize variables
    drawerTitleTextStyle =  const TextStyle(      fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black,
    fontFamily: 'Poppins',);
    
   
    homeHeadingTextStyle =  const TextStyle(       fontWeight: FontWeight.w800, fontSize: 34, color: Colors.black,
    fontFamily: 'Poppins',);
    

    homeSubHeadingTextStyle = const TextStyle(       fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black,
    fontFamily: 'Poppins',);
    

    nameTextStyle = const TextStyle(        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black,
    fontFamily: 'Poppins',);
    

    priceTextStyle =  TextStyle(        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black.withOpacity(0.5),
    fontFamily: 'Poppins',);
    

  }
}
