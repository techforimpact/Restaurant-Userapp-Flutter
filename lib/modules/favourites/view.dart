
import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../home/logic.dart';
import '../product_detail/view.dart';
import '../restaurant_detail/view.dart';
import 'logic.dart';
import 'state.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final FavouritesLogic logic = Get.put(FavouritesLogic());

  final FavouritesState state = Get.find<FavouritesLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 15,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Favourites',
          style: state.appBarTextStyle,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            ///---wishlist-list for only current user
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('wishList')
                    .where('uid',
                        isEqualTo: Get.find<GeneralController>()
                            .boxStorage
                            .read('uid'))
                    .snapshots(),
                builder: (context, wishListSnapshot) {
                  if (wishListSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    log('Waiting');
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),
                      child: SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: SkeletonLoader(
                          period: const Duration(seconds: 2),
                          highlightColor: Colors.grey,
                          direction: SkeletonDirection.ltr,
                          builder: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    );
                  } else if (wishListSnapshot.hasData) {
                    if (wishListSnapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Record not found',
                          textAlign: TextAlign.center,
                          style: TextStyle( fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      );
                    } else {
                      return Wrap(
                        children: List.generate(
                            wishListSnapshot.data!.docs.length, (index) {
                          if (wishListSnapshot.data!.docs[index].get('type') ==
                              'products') {
                            print(wishListSnapshot.data!.docs[index].data());

                            //product wish list
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('products')
                                    .where('id',
                                        isEqualTo: wishListSnapshot
                                            .data!.docs[index]
                                            .get('w_id'))
                                    .snapshots(),
                                builder: (context, productsSnapshot) {
                                  if (productsSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    log('Waiting');
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 15, 18, 5),
                                      child: SizedBox(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SkeletonLoader(
                                          period: const Duration(seconds: 2),
                                          highlightColor: Colors.grey,
                                          direction: SkeletonDirection.ltr,
                                          builder: Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (productsSnapshot.hasData) {
                                    //restaurants wish list
                                    return FadedSlideAnimation(
                                      child: Wrap(
                                        children: List.generate(
                                            productsSnapshot.data!.docs.length,
                                            (index) {
                                          log('restaurants wish length length length ${productsSnapshot.data!.docs[index].data()}');

                                          return StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('restaurants')
                                                  .where('id',
                                                      isEqualTo: productsSnapshot
                                                          .data!.docs[index]
                                                          .get('restaurant_id'))
                                                  .snapshots(),
                                              builder: (context,
                                                  restaurantsSnapshot) {
                                                if (restaurantsSnapshot
                                                    .hasData) {
                                                  int? distance = (Geolocator.distanceBetween(
                                                          Get.find<HomeLogic>()
                                                              .latitude!,
                                                          Get.find<HomeLogic>()
                                                              .longitude!,
                                                          double.parse(
                                                              restaurantsSnapshot
                                                                  .data!.docs[0]
                                                                  .get('lat')
                                                                  .toString()),
                                                          double.parse(
                                                              restaurantsSnapshot
                                                                  .data!.docs[0]
                                                                  .get('lng')
                                                                  .toString())) ~/
                                                      1000);
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 30, 15, 0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            ProductDetailPage(
                                                          isProduct: true,
                                                          productModel:
                                                              productsSnapshot
                                                                  .data!
                                                                  .docs[index],
                                                        ));
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(19),
                                                          // boxShadow: [
                                                          //   BoxShadow(
                                                          //     color: customThemeColor
                                                          //         .withOpacity(
                                                          //             0.19),
                                                          //     blurRadius: 40,
                                                          //     spreadRadius: 0,
                                                          //     offset: const Offset(
                                                          //         0,
                                                          //         22), // changes position of shadow
                                                          //   ),
                                                          // ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Row(
                                                            children: [
                                                              ///---image
                                                              Hero(
                                                                tag:
                                                                    '${productsSnapshot.data!.docs[index].get('image')}',
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      Container(
                                                                    height: 80,
                                                                    width: 80,
                                                                    decoration: const BoxDecoration(
                                                                        color: Colors
                                                                            .grey,
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40),
                                                                      child: Image
                                                                          .network(
                                                                        '${productsSnapshot.data!.docs[index].get('image')}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              ///---detail
                                                              Expanded(
                                                                  child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 20),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ///---name
                                                                      Text(
                                                                          '${productsSnapshot.data!.docs[index].get('name')}',
                                                                          style: const TextStyle( fontFamily: 'Poppins',
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                              color: customTextGreyColor)),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            .01,
                                                                      ),

                                                                      ///---quantity-discount
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          ///---quantity
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text('${productsSnapshot.data!.docs[index].get('quantity')} left', style: TextStyle( fontFamily: 'Poppins',fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor.withOpacity(0.5))),
                                                                            ),
                                                                          ),

                                                                          ///---distance
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text('${distance}km', style: TextStyle( fontFamily: 'Poppins',fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor.withOpacity(0.5))),
                                                                            ),
                                                                          ),

                                                                          ///---price
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text('Rs${productsSnapshot.data!.docs[index].get('original_price')}', style: TextStyle( fontFamily: 'Poppins',fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor.withOpacity(0.5)).copyWith(decoration: TextDecoration.lineThrough)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            .01,
                                                                      ),

                                                                      ///---price
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          ///---discount
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text('${productsSnapshot.data!.docs[index].get('discount')}% off', style: TextStyle( fontFamily: 'Poppins',fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor.withOpacity(0.5)).copyWith(color: Colors.green)),
                                                                            ),
                                                                          ),

                                                                          ///---price
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Container(
                                                                                width: 70,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: customThemeColor),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                                                  child: Center(
                                                                                    child: Text('Rs${productsSnapshot.data!.docs[index].get('dis_price')}', style: TextStyle( fontFamily: 'Poppins',fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor.withOpacity(0.5)).copyWith(color: Colors.white)),
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
                                              });
                                        }),
                                      ),
                                      beginOffset: const Offset(0.3, 0.2),
                                      endOffset: const Offset(0, 0),
                                      slideCurve: Curves.linearToEaseOut,
                                    );
                                  } else {
                                    return Text(
                                      'Record not found',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }
                                });
                          } else  {
                            //restaurants wish list
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('restaurants')
                                    .where('id',
                                        isEqualTo: wishListSnapshot
                                            .data!.docs[index]
                                            .get('w_id'))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    log('Waiting');
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 15, 18, 5),
                                      child: SizedBox(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SkeletonLoader(
                                          period: const Duration(seconds: 2),
                                          highlightColor: Colors.grey,
                                          direction: SkeletonDirection.ltr,
                                          builder: Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    return FadedSlideAnimation(
                                      child: Wrap(
                                        children: List.generate(
                                            snapshot.data!.docs.length,
                                            (index) {
                                          log('restaurants length length length  ${snapshot.data!.docs.length}');

                                          // double? avgRating = 0;
                                          // List.generate(
                                          //     snapshot.data!.docs[index]
                                          //         .get('ratings')
                                          //         .length,
                                          //     (innerIndex) => avgRating =
                                          //         avgRating! +
                                          //             snapshot.data!.docs[index]
                                          //                     .get('ratings')[
                                          //                 innerIndex]);
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 30, 15, 0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(RestaurantDetailPage(
                                                  restaurantModel: snapshot
                                                      .data!.docs[index],
                                                ));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(19),
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Row(
                                                    children: [
                                                      ///---image
                                                      Hero(
                                                        tag:
                                                            '${snapshot.data!.docs[index].get('image')}',
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              child:
                                                                  Image.network(
                                                                '${snapshot.data!.docs[index].get('image')}',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ///---detail
                                                      Expanded(
                                                          child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ///---name
                                                              Text(
                                                                  '${snapshot.data!.docs[index].get('name')}',
                                                                  style: const TextStyle( fontFamily: 'Poppins',
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color:
                                                                          customTextGreyColor)),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .01,
                                                              ),

                                                              ///---timings
                                                              Text(
                                                                  '${snapshot.data!.docs[index].get('open_time')} - ${snapshot.data!.docs[index].get('close_time')}',
                                                                  style: TextStyle( fontFamily: 'Poppins',
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: customTextGreyColor
                                                                          .withOpacity(
                                                                              0.5))),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .01,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  ///---distance
                                                                  Text(
                                                                      '${(Geolocator.distanceBetween(Get.find<HomeLogic>().latitude!, Get.find<HomeLogic>().longitude!, double.parse(snapshot.data!.docs[0].get('lat').toString()), double.parse(snapshot.data!.docs[0].get('lng').toString())) ~/ 1000)}km',
                                                                      style: TextStyle( fontFamily: 'Poppins',
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              customTextGreyColor.withOpacity(0.5))),

                                                                  ///---rating
                                                                  // Row(
                                                                  //   children: [
                                                                  //     const Icon(
                                                                  //       Icons
                                                                  //           .star,
                                                                  //       color: Colors
                                                                  //           .yellow,
                                                                  //       size:
                                                                  //           20,
                                                                  //     ),
                                                                  //     Text(
                                                                  //         '${avgRating == 0.0 ? 'Not Rated' : (avgRating! / snapshot.data!.docs[index].get('total_rates')).toPrecision(1)}',
                                                                  //         style: TextStyle( fontFamily: 'Poppins',
                                                                  //             fontSize: 14,
                                                                  //             fontWeight: FontWeight.w700,
                                                                  //             color: customTextGreyColor.withOpacity(0.5))),
                                                                  //   ],
                                                                  // ),
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
                                        }),
                                      ),
                                      beginOffset: const Offset(0.3, 0.2),
                                      endOffset: const Offset(0, 0),
                                      slideCurve: Curves.linearToEaseOut,
                                    );
                                  } else {
                                    return Text(
                                      'Record not found',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }
                                });
                          } 
                        }),
                      );
                    }
                  } else {
                    return Text(
                      'Record not found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    );
                  }
                }),

            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
          ],
        ),
      ),
    );
  }
}
