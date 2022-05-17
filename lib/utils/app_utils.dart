import 'package:flutter/material.dart';

num offsetToOpacity({required double currentOffset, double returnMax = 1,required double maxOffset}) {
  return (currentOffset * returnMax) / maxOffset;
}

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300]!, blurRadius: 10, offset: const Offset(0, 10))
];

