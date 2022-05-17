import 'package:flutter/material.dart';
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
  final HomeLogic logic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return    Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
                text: "Hello\n",
                style: const TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text: logic.currentUserData!.get('name'),
                      style: const TextStyle(
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ))
                ]),
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
          const SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () async {
              Get.toNamed(PageRoutes.cart);
            },
            child: Stack(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(5, 15, 30, 5),
                    child: Icon(Icons.shopping_cart)),
                logic.totalCartCount == null
                    ? const SizedBox()
                    : Positioned(
                        top: 5,
                        right: 12,
                        child: CircleAvatar(
                          backgroundColor: customThemeColor,
                          radius: 10,
                          child: 
                              GetBuilder<HomeLogic>(builder: (controller){
   return Text(
                            '${controller.totalCartCount}',
                            style: const TextStyle( fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 10),
                          );
                              })
                          
                        ))
              ],
            ),
          )
        ],
      ),
    );
 
  }
}

