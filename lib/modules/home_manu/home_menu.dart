// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:barcode_flutter/barcode_flutter.dart';

import 'dart:math' as math;

import 'package:book_a_table/modules/home/view.dart';
import 'package:book_a_table/modules/profile/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color.dart';
import '../../widgets/app_clipper.dart';
import '../book_now/view.dart';
import '../home/logic.dart';
import '../map/view.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  //this padding is for the left menu icon that is animated every time an item is selected on the left menu
  var paddingLeft = 0.0;

  //references the current selected left menu item
  int current = 0;

  int? prevPage;
  final HomeLogic homeLogic = Get.find<HomeLogic>();


  //switches the current view of home page
  Widget? currentWidget;

  var loyaltyText = "Earn Points";

  bool currentSet = false;

  bool shouldShowFloat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: currentSet ? currentWidget : const TakeAway(),
            ),
           
            Positioned(
              top: MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: -math.pi / 2,
                alignment: Alignment.topLeft,
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                    color: AppColors.greenColor,

                      child: Row(
                        children: [
                          buildMenu("Home", 0),
                          buildMenu("Near Me", 1),
                          buildMenu("Profile", 2),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.only(left: paddingLeft),
                      width: 270,
                      height: 55,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipPath(
                              clipper: AppClipper(),
                              child: Container(
                                width: 150,
                                height: 60,
                                color: AppColors.greenColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Transform.rotate(
                                angle: math.pi / 2,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 30),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //left green menu

  Widget buildMenu(String menu, int index) {
    return GestureDetector(
      onTap: () {
        //when one of the menu items are clicked:
        setState(() {
          paddingLeft = index * MediaQuery.of(context).size.height / 3;
          currentSet = true;
          if (index == 2) {
            shouldShowFloat = false;

            currentWidget = const ProfilePage();
          }   else if (index == 1) {
            shouldShowFloat = false;

            currentWidget = const MapPage();
          } else if (index == 0) {
            shouldShowFloat = false;

            currentWidget = const TakeAway();
          }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.height / 3,
        padding: const EdgeInsets.only(top: 0),
        child: Center(
          child: index == 2
              ? Transform.rotate(
                  angle: math.pi / 2,
                  child: Container(
                    width: 30,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                  ))
              : Text(
                  menu,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      ),
    );
  }
}


//this is the category button inside the book now widget, shows Amenities

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;
  final bool isSelected;

  const CategoryButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onPressed.call();
      },
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      fillColor: isSelected ? color.withAlpha(100) : kLightGrey,
      constraints: const BoxConstraints.tightFor(
        width: 70,
        height: 75,
      ),
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }
}
