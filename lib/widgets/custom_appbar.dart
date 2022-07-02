import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../modules/home/logic.dart';
import '../modules/search/view.dart';
import '../route_generator.dart';
import '../utils/color.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  final HomeLogic _homeLogic = Get.find<HomeLogic>();
  @override
  Widget build(BuildContext context) {
    _homeLogic.currentUser(context);
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _homeLogic.handleMenuButtonPressed();
            },
            child: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _homeLogic.advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: value.visible
                        ? const Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: customTextGreyColor,
                          )
                        : SvgPicture.asset('assets/drawerIcon.svg'));
              },
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                  color: AppColors.greenLightColor,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const SearchPage());
                      },
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
         
          SizedBox(
            width: 50,
            height: 30,
            child: InkWell(
              onTap: () async {
                Get.toNamed(PageRoutes.cart);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 20,
                    child: Icon(Icons.shopping_cart,size: 30,)),
                  GetBuilder<HomeLogic>(builder: (controller) {
                    return _homeLogic.totalCartCount == null
                        ? const SizedBox()
                        : Positioned(
                            top: 8,
                            right: 16,
                            child: CircleAvatar(
                                backgroundColor: customThemeColor,
                                radius: 10,
                                child: Text(
                                  '${controller.totalCartCount}',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 10),
                                )));
                  }),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(PageRoutes.map);
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: customThemeColor.withOpacity(0.19),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 15), // changes position of shadow
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/images/map_locator.png',)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
