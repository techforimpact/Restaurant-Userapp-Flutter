import 'package:book_a_table/utils/text_style.dart';
import 'package:flutter/material.dart';


class ProductDetailState {
  TextStyle? productNameStyle;
  TextStyle? restaurantNameStyle;
  TextStyle? productPriceStyle;
  TextStyle? productDescStyle;
  TextStyle? cartButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? descTextStyle;

  ProductDetailState() {
    ///Initialize variables
    productNameStyle = headerStyle;
    restaurantNameStyle = headerStyle.copyWith(fontWeight: FontWeight.w800);

    productPriceStyle = headerStyle;
    
    
    productDescStyle = subtitleStyle;

    cartButtonStyle = subtitleStyle;

    headingTextStyle = subtitleStyle;

    descTextStyle =subtitleStyle;
 
  }
}
