
//this are the top categories inside the Home Widget:
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_utils.dart';
import '../../../utils/color.dart';
import '../logic.dart';



class TopMenuCategories extends StatefulWidget {
  const TopMenuCategories({Key? key}) : super(key: key);

  @override
  _TopMenuCategories createState() => _TopMenuCategories();
}

class _TopMenuCategories extends State<TopMenuCategories> {
    HomeLogic logic=Get.find<HomeLogic>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(builder: (controller) {
        return     SizedBox(
      height: 110,
      child:    ListView(
        scrollDirection: Axis.horizontal,
      children: [
        GestureDetector(
          onTap: () {
                          controller.update();

            setState(() {
             controller.isBurger = controller.isBurger? false:true;
             
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20, top: 5),
                decoration: BoxDecoration(
                    color: controller.isBurger
                        ? AppColors.greenColor
                        : Colors.white /*Color.fromRGBO(240, 219, 187, 1)*/,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/images/burger_icon.png',
                ),
                height: 70,
                width: 70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                 'Burgers',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
                          controller.update();

            setState(() {
             controller.isPizza = controller.isPizza? false:true;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20, top: 5),
                decoration: BoxDecoration(
                    color: controller.isPizza
                        ? AppColors.greenColor
                        : Colors.white /*Color.fromRGBO(240, 219, 187, 1)*/,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/images/pizza_icon.png',
                ),
                height: 70,
                width: 70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                 'Pizza',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
                          controller.update();

            setState(() {
             controller.isSushi = controller.isSushi? false:true;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20, top: 5),
                decoration: BoxDecoration(
                    color: controller.isSushi
                        ? AppColors.greenColor
                        : Colors.white /*Color.fromRGBO(240, 219, 187, 1)*/,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/images/sushi_icon.png',
                ),
                height: 70,
                width: 70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                 'Sushi',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
                          controller.update();

            setState(() {
             controller.isDesert = controller.isDesert? false:true;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20, top: 5),
                decoration: BoxDecoration(
                    color: controller.isDesert
                        ? AppColors.greenColor
                        : Colors.white /*Color.fromRGBO(240, 219, 187, 1)*/,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/images/desert_icon.png',
                ),
                height: 70,
                width: 70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                 'Desert',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
                          controller.update();

            setState(() {
             controller.isDrinks = controller.isDrinks? false:true;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 20, top: 5),
                decoration: BoxDecoration(
                    color: controller.isDrinks
                        ? AppColors.greenColor
                        : Colors.white /*Color.fromRGBO(240, 219, 187, 1)*/,
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  'assets/images/drinks_icon.png',
                ),
                height: 70,
                width: 70,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                 'Drinks',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      
      ],
    )
 
    );
      
    },);
 
  }

 
}
