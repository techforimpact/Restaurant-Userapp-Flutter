import 'package:book_a_table/controllers/index_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PageIndicator extends StatelessWidget{
  const PageIndicator({Key? key}) : super(key: key);


  _indicator(bool isActive){

    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.transparent,
        border: Border.all(
          color: Colors.black,
          width: 1,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final currentIndex = Get.find<IndexController>().index;

    var arr = ['a','b','c'];

    List<Widget> _buildIndicator(){

      List<Widget> indicators = [];

      for (int i = 0; i < arr.length; i++){

        indicators.add(i == currentIndex ? _indicator(true) : _indicator(false));

        
      }

      //indicators.add(0 == currentIndex ? _indicator(true) : _indicator(false));
      //indicators.add(1 == currentIndex ? _indicator(true) : _indicator(false));


      return indicators;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: _buildIndicator(),
      ),
    );
  }


}