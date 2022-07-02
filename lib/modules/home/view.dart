import 'package:book_a_table/controllers/general_controller.dart';
import 'package:book_a_table/modules/search/view.dart';
import 'package:book_a_table/route_generator.dart';
import 'package:book_a_table/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../../utils/text_style.dart';
import 'logic.dart';
import '../../widgets/restaurent_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeLogic _homeLogic = Get.find<HomeLogic>();
  final _generalController = Get.find<GeneralController>();

  final BookNowLogic bookNowLogic = Get.put(BookNowLogic());
  @override
  void initState() {
    _homeLogic.currentUser(context);
    Get.find<HomeLogic>().updateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          ///---gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                customThemeColor.withOpacity(0.3),
                customThemeColor.withOpacity(0.8),
                customThemeColor
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
          ),

          GetBuilder<BookNowLogic>(builder: (controller) {
            print(_homeLogic.totalCartCount);
            return AdvancedDrawer(
                backdropColor: Colors.transparent,
                controller: _homeLogic.advancedDrawerController,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                childDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                drawer: const MyCustomDrawer(),
                child: GestureDetector(
                  onTap: () {
                    _generalController.focusOut(context);
                  },
                  child: Stack(
                    children: [
                      Scaffold(
                        appBar: AppBar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          elevation: 0,
                          leading: InkWell(
                            onTap: () {
                              _homeLogic.handleMenuButtonPressed();
                            },
                            child: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable:
                                  _homeLogic.advancedDrawerController,
                              builder: (_, value, __) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 5, 5, 5),
                                  child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: value.visible
                                          ? const Icon(
                                              Icons.arrow_back,
                                              size: 25,
                                              color: customTextGreyColor,
                                            )
                                          : SvgPicture.asset(
                                              'assets/drawerIcon.svg')),
                                );
                              },
                            ),
                          ),
                          centerTitle: true,
                          actions: [
                            InkWell(
                              onTap: () async {
                                Get.toNamed(PageRoutes.cart);
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 15, 30, 5),
                                    child: SvgPicture.asset(
                                        'assets/shopping-cart.svg'),
                                  ),
                                  _homeLogic.totalCartCount == null
                                      ? const SizedBox()
                                      : Positioned(
                                          top: 5,
                                          right: 12,
                                          child: CircleAvatar(
                                            backgroundColor: customThemeColor,
                                            radius: 10,
                                            child: StreamBuilder<
                                                    QuerySnapshot<
                                                        Map<String, dynamic>>>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('cart')
                                                    .where("uid",
                                                        isEqualTo: Get.find<
                                                                GeneralController>()
                                                            .boxStorage
                                                            .read('uid'))
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return Text(
                                                    '${snapshot.data?.docs.length}',
                                                  );
                                                }),
                                          ))
                                ],
                              ),
                            )
                          ],
                        ),
                        body: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          child: ListView(
                            children: <Widget>[
                              // const CustomAppbar(),
                              const Text(
                                'Where would you like to eat today',
                                style: kGreetingsStyle,
                              ),

                              ///---search-bar
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 10),
                                child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 5, 0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.toNamed(PageRoutes.search);
                                              },
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.search,
                                                    color: customThemeColor,
                                                    size: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Search',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CategoryButton(
                                        icon: Icons.wifi,
                                        color: kGreen,
                                        onPressed: () {
                                          controller.isWifi =
                                              controller.isWifi ? false : true;
                                          controller.update();
                                          setState(() {});
                                        },
                                        isSelected: controller.isWifi),
                                    CategoryButton(
                                        icon: Icons.tv,
                                        color: kBlue,
                                        onPressed: () {
                                          controller.isTV =
                                              controller.isTV ? false : true;
                                          controller.update();
                                          setState(() {});
                                        },
                                        isSelected: controller.isTV),
                                    CategoryButton(
                                        icon: Icons.ac_unit,
                                        color: kOrange,
                                        onPressed: () {
                                          controller.isAC =
                                              controller.isAC ? false : true;
                                          controller.update();
                                          setState(() {});
                                        },
                                        isSelected: controller.isAC),
                                    CategoryButton(
                                        icon: Icons.child_friendly,
                                        color: Colors.red,
                                        onPressed: () {
                                          controller.isplay =
                                              controller.isplay ? false : true;
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
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: (MediaQuery.of(context).size.width / 2) -
                            (MediaQuery.of(context).size.width * .3 / 2),
                        child: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable:
                              Get.find<HomeLogic>().advancedDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: value.visible
                                  ? const SizedBox()
                                  : SafeArea(
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(PageRoutes.map);
                                        },
                                        child: Container(
                                          height: 44,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: customThemeColor
                                                      .withOpacity(0.19),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0,
                                                      5), // changes position of shadow
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/homeLocationIcon.svg',
                                                  color: AppColors.greenColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Map',
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          }),
        ],
      ),
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
