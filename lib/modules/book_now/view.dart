import 'package:book_a_table/modules/book_now/widget/restaurent_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../../utils/text_style.dart';
import '../../widgets/custom_appbar.dart';
import '../home/logic.dart';
import 'logic.dart';

class TakeAway extends StatefulWidget {
  const TakeAway({Key? key}) : super(key: key);

  @override
  State<TakeAway> createState() => _TakeAwayState();
}

class _TakeAwayState extends State<TakeAway> {
  final HomeLogic logic = Get.find<HomeLogic>();
  final BookNowLogic bookNowLogic = Get.put(BookNowLogic());
  @override
  void initState() {
     Get.find<HomeLogic>().updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<BookNowLogic>(builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: ListView(
            children: <Widget>[
             const CustomAppbar(),
              const Text(
                'Where would you like to eat today',
                style: kGreetingsStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Our Amenities",
                    style: TextStyle(fontSize: 18),
                  )),

              const SizedBox(
                height: 8,
              ),

              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CategoryButton(
                        icon: Icons.wifi,
                        color: kGreen,
                        onPressed: () {
                          controller.isWifi = controller.isWifi ? false : true;
                          controller.update();
                          setState(() {});
                        },
                        isSelected: controller.isWifi),
                    CategoryButton(
                        icon: Icons.tv,
                        color: kBlue,
                        onPressed: () {
                          controller.isTV = controller.isTV ? false : true;
                          controller.update();
                          setState(() {});
                        },
                        isSelected: controller.isTV),
                    CategoryButton(
                        icon: Icons.ac_unit,
                        color: kOrange,
                        onPressed: () {
                          controller.isAC = controller.isAC ? false : true;
                          controller.update();
                          setState(() {});
                        },
                        isSelected: controller.isAC),
                    CategoryButton(
                        icon: Icons.child_friendly,
                        color: Colors.red,
                        onPressed: () {
                          controller.isplay = controller.isplay ? false : true;
                          controller.update();
                          setState(() {});
                        },
                        isSelected: controller.isplay),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Our Top Restaurants',
                style: kTopHeadingStyle,
              ),
              const SizedBox(
                height: 15,
              ),
              //!-------------------------
              const BookNowRestaurentListWidget()
            ],
          ),
        );
      }),
    );
  }



}

//---------------------category button-------------

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
        width: 60,
        height: 60,
      ),
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }
}
