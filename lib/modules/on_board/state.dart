import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardState {
  TextStyle? mainHeading;
  TextStyle? subHeading;
  TextStyle? mainTitle;
  TextStyle? subTitle;
  OnBoardState() {
    ///Initialize variables
    mainHeading = GoogleFonts.nunito(
        fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white);
    mainTitle = GoogleFonts.nunito(
        fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white);
    subHeading = GoogleFonts.nunito(
        fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white);
    subTitle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white);
  }
}
