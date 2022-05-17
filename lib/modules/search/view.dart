
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../home/logic.dart';
import '../product_detail/view.dart';
import '../restaurant_detail/view.dart';
import 'logic.dart';
import 'state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchLogic logic = Get.put(SearchLogic());
  final SearchState state = Get.find<SearchLogic>().state;
  final _generalController = Get.find<GeneralController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchLogic>(
      builder: (_searchLogic) => Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                style: const TextStyle( fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
                onChanged: (val) {
                  _searchLogic.initiateSearch(val);
                },
                autofocus: true,
                decoration: InputDecoration(
                    prefixIcon: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _generalController.focusOut(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                    hintText: 'Search by name',
                    hintStyle: TextStyle( fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withOpacity(0.5)),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),

            ///---for-both
            SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    children: List.generate(
                        _searchLogic.tempSearchForProductStore.length, (index) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('restaurants')
                              .where('id',
                                  isEqualTo: _searchLogic
                                      .tempSearchForProductStore[index]
                                      .get('restaurant_id'))
                              .snapshots(),
                          builder: (context, snp) {
                            if (snp.hasData) {
                              int? distance = (Geolocator.distanceBetween(
                                      Get.find<HomeLogic>().latitude!,
                                      Get.find<HomeLogic>().longitude!,
                                      double.parse(snp.data!.docs[0]
                                          .get('lat')
                                          .toString()),
                                      double.parse(snp.data!.docs[0]
                                          .get('lng')
                                          .toString())) ~/
                                  1000);
                              if (int.parse(_searchLogic
                                      .tempSearchForProductStore[index]
                                      .get('quantity')
                                      .toString()) >
                                  0) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 30, 15, 0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(ProductDetailPage(
                                        isProduct: true,
                                        productModel: _searchLogic
                                            .tempSearchForProductStore[index],
                                      ));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(19),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: customThemeColor
                                        //         .withOpacity(0.19),
                                        //     blurRadius: 40,
                                        //     spreadRadius: 0,
                                        //     offset: const Offset(0,
                                        //         22), // changes position of shadow
                                        //   ),
                                        // ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            ///---image
                                            Hero(
                                              tag:
                                                  '${_searchLogic.tempSearchForProductStore[index].get('image')}',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.grey,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: Image.network(
                                                      '${_searchLogic.tempSearchForProductStore[index].get('image')}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            ///---detail
                                            Expanded(
                                                child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ///---name
                                                    Text(
                                                        '${_searchLogic.tempSearchForProductStore[index].get('name')}',
                                                        style: state
                                                            .nameTextStyle),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .01,
                                                    ),

                                                    ///---quantity-discount
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ///---quantity
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                '${_searchLogic.tempSearchForProductStore[index].get('quantity')} left',
                                                                style: state
                                                                    .priceTextStyle),
                                                          ),
                                                        ),

                                                        ///---distance
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                '${distance}km',
                                                                style: state
                                                                    .priceTextStyle),
                                                          ),
                                                        ),

                                                        ///---price
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                                'Rs${_searchLogic.tempSearchForProductStore[index].get('original_price')}',
                                                                style: state
                                                                    .priceTextStyle!
                                                                    .copyWith(
                                                                        decoration:
                                                                            TextDecoration.lineThrough)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .01,
                                                    ),

                                                    ///---price
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ///---discount
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                '${_searchLogic.tempSearchForProductStore[index].get('discount')}% off',
                                                                style: state
                                                                    .priceTextStyle!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .green)),
                                                          ),
                                                        ),

                                                        ///---price
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              width: 70,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              19),
                                                                  color:
                                                                      customThemeColor),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        2,
                                                                        0,
                                                                        2),
                                                                child: Center(
                                                                  child: Text(
                                                                      'Rs${_searchLogic.tempSearchForProductStore[index].get('dis_price')}',
                                                                      style: state
                                                                          .priceTextStyle!
                                                                          .copyWith(
                                                                              color: Colors.white)),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            } else {
                              return const SizedBox();
                            }
                          });
                    }),
                  ),
                  Wrap(
                    children: _searchLogic.tempSearchForRestaurantStore
                        .map((element) {
                      double? avgRating = 0;
                      List.generate(
                          element.get('ratings').length,
                          (innerIndex) => avgRating =
                              avgRating! + element.get('ratings')[innerIndex]);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                        child: InkWell(
                          onTap: () {
                            Get.to(RestaurantDetailPage(
                              restaurantModel: element,
                            ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: customThemeColor.withOpacity(0.19),
                              //     blurRadius: 40,
                              //     spreadRadius: 0,
                              //     offset: const Offset(
                              //         0, 22), // changes position of shadow
                              //   ),
                              // ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  ///---image
                                  Hero(
                                    tag: '${element.get('image')}',
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Image.network(
                                            '${element.get('image')}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///---detail
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ///---name
                                          Text('${element.get('name')}',
                                              style: state.nameTextStyle),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          ),

                                          ///---timings
                                          Text(
                                              '${element.get('open_time')} - ${element.get('close_time')}',
                                              style: state.priceTextStyle),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///---distance
                                              Text(
                                                  '${(Geolocator.distanceBetween(Get.find<HomeLogic>().latitude!, Get.find<HomeLogic>().longitude!, double.parse(element.get('lat').toString()), double.parse(element.get('lng').toString())) ~/ 1000)}km',
                                                  style: state.priceTextStyle),

                                              ///---rating
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                      '${avgRating == 0.0 ? 'Not Rated' : (avgRating! / element.get('total_rates')).toPrecision(1)}',
                                                      style:
                                                          state.priceTextStyle),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  _searchLogic.tempSearchForRestaurantStore.isEmpty &&
                          _searchLogic.tempSearchForProductStore.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            Image.asset('assets/noSearchEmoji.png'),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'Try searching for the Product or Restaurent with a different keyword',
                                textAlign: TextAlign.center,
                                style: TextStyle( fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    color: customTextGreyColor),
                              ),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
