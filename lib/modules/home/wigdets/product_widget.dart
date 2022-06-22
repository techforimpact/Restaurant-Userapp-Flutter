import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color.dart';
import '../../product_detail/view.dart';
import '../logic.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) => FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Wrap(
            children: List.generate(_homeLogic.productsShowList.length, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: InkWell(
                  onTap: () {
                    Get.to(ProductDetailPage(
                      isProduct: true,
                      productModel: _homeLogic.productsDocumentSnapshotList[index],
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
                      //     offset:
                      //         const Offset(0, 22), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          ///---image
                          Hero(
                            tag: '${_homeLogic.productsShowList[index]['image']}',
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(
                                    '${_homeLogic.productsShowList[index]['image']}',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///---name
                                  Text(
                                      '${_homeLogic.productsShowList[index]['name']}',
                                      style: _homeLogic.state.nameTextStyle),
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
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${_homeLogic.productsShowList[index]['quantity']} left',
                                              style: _homeLogic
                                                  .state.priceTextStyle),
                                        ),
                                      ),

                                      ///---distance
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '${_homeLogic.productsShowList[index]['distance']}km',
                                              style: _homeLogic
                                                  .state.priceTextStyle),
                                        ),
                                      ),

                                      ///---price
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              '\$${_homeLogic.productsShowList[index]['original_price']}',
                                              style: _homeLogic
                                                  .state.priceTextStyle!
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough)),
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
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${_homeLogic.productsShowList[index]['discount']}% off',
                                              style: _homeLogic
                                                  .state.priceTextStyle!
                                                  .copyWith(
                                                      color: Colors.green)),
                                        ),
                                      ),

                                      ///---price
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                                color: customThemeColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 2, 0, 2),
                                              child: Center(
                                                child: Text(
                                                    '\$${_homeLogic.productsShowList[index]['dis_price']}',
                                                    style: _homeLogic
                                                        .state.priceTextStyle!
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
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
            }),
          ),
        ),
        beginOffset: const Offset(0.3, 0.2),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
    // StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance
    //         .collection('products')
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         log('Waiting');
    //         return Padding(
    //           padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),
    //           child: SizedBox(
    //             height: 120,
    //             width: MediaQuery.of(context).size.width,
    //             child: SkeletonLoader(
    //               period: const Duration(seconds: 2),
    //               highlightColor: Colors.grey,
    //               direction: SkeletonDirection.ltr,
    //               builder: Container(
    //                 height: 120,
    //                 width: MediaQuery.of(context).size.width,
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(10)),
    //               ),
    //             ),
    //           ),
    //         );
    //       } else if (snapshot.hasData) {
    //         if (snapshot.data!.docs.isEmpty) {
    //           return Padding(
    //             padding: const EdgeInsets.only(top: 30),
    //             child: Text(
    //               'Record not found',
    //               textAlign: TextAlign.center,
    //               style: TextStyle( fontFamily: 'Poppins',
    //                   fontSize: 20,
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w600),
    //             ),
    //           );
    //         } else {
    //           return FadedSlideAnimation(
    //             child: SingleChildScrollView(
    //               child: Wrap(
    //                 children: List.generate(snapshot.data!.docs.length,
    //                     (index) {
    //                   return StreamBuilder<QuerySnapshot>(
    //                       stream: FirebaseFirestore.instance
    //                           .collection('restaurants')
    //                           .where('id',
    //                               isEqualTo: snapshot.data!.docs[index]
    //                                   .get('restaurant_id'))
    //                           .snapshots(),
    //                       builder: (context, snp) {
    //                         if (snp.connectionState ==
    //                                 ConnectionState.waiting ||
    //                             Get.find<HomeLogic>().latitude ==
    //                                 null) {
    //                           log('Waiting');
    //                           return Padding(
    //                             padding: const EdgeInsets.fromLTRB(
    //                                 18, 15, 18, 5),
    //                             child: SizedBox(
    //                               height: 120,
    //                               width:
    //                                   MediaQuery.of(context).size.width,
    //                               child: SkeletonLoader(
    //                                 period: const Duration(seconds: 2),
    //                                 highlightColor: Colors.grey,
    //                                 direction: SkeletonDirection.ltr,
    //                                 builder: Container(
    //                                   height: 120,
    //                                   width: MediaQuery.of(context)
    //                                       .size
    //                                       .width,
    //                                   decoration: BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius:
    //                                           BorderRadius.circular(
    //                                               10)),
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         } else if (snp.hasData &&
    //                             snp.data!.docs[0]
    //                                     .get('isActive')
    //                                     .toString() ==
    //                                 'true') {
    //                           int? distance =
    //                               (Geolocator.distanceBetween(
    //                                       Get.find<HomeLogic>()
    //                                           .latitude!,
    //                                       Get.find<HomeLogic>()
    //                                           .longitude!,
    //                                       double.parse(snp.data!.docs[0]
    //                                           .get('lat')
    //                                           .toString()),
    //                                       double.parse(snp.data!.docs[0]
    //                                           .get('lng')
    //                                           .toString())) ~/
    //                                   1000);
    //                           if (int.parse(snapshot.data!.docs[index]
    //                                   .get('quantity')
    //                                   .toString()) >
    //                               0) {
    //                             return Padding(
    //                               padding: const EdgeInsets.fromLTRB(
    //                                   15, 30, 15, 0),
    //                               child: InkWell(
    //                                 onTap: () {
    //                                   Get.to(ProductDetailPage(
    //                                     isProduct: true,
    //                                     productModel:
    //                                         snapshot.data!.docs[index],
    //                                   ));
    //                                 },
    //                                 child: Container(
    //                                   width: MediaQuery.of(context)
    //                                       .size
    //                                       .width,
    //                                   decoration: BoxDecoration(
    //                                     color: Colors.white,
    //                                     borderRadius:
    //                                         BorderRadius.circular(19),
    //                                     boxShadow: [
    //                                       BoxShadow(
    //                                         color: customThemeColor
    //                                             .withOpacity(0.19),
    //                                         blurRadius: 40,
    //                                         spreadRadius: 0,
    //                                         offset: const Offset(0,
    //                                             22), // changes position of shadow
    //                                       ),
    //                                     ],
    //                                   ),
    //                                   child: Padding(
    //                                     padding:
    //                                         const EdgeInsets.all(20.0),
    //                                     child: Row(
    //                                       children: [
    //                                         ///---image
    //                                         Hero(
    //                                           tag:
    //                                               '${snapshot.data!.docs[index].get('image')}',
    //                                           child: Material(
    //                                             color:
    //                                                 Colors.transparent,
    //                                             child: Container(
    //                                               height: 80,
    //                                               width: 80,
    //                                               decoration:
    //                                                   const BoxDecoration(
    //                                                       color: Colors
    //                                                           .grey,
    //                                                       shape: BoxShape
    //                                                           .circle),
    //                                               child: ClipRRect(
    //                                                 borderRadius:
    //                                                     BorderRadius
    //                                                         .circular(
    //                                                             40),
    //                                                 child:
    //                                                     Image.network(
    //                                                   '${snapshot.data!.docs[index].get('image')}',
    //                                                   fit: BoxFit.cover,
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ),
    //
    //                                         ///---detail
    //                                         Expanded(
    //                                             child: Align(
    //                                           alignment:
    //                                               Alignment.centerLeft,
    //                                           child: Padding(
    //                                             padding:
    //                                                 const EdgeInsets
    //                                                     .only(left: 20),
    //                                             child: Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment
    //                                                       .start,
    //                                               mainAxisAlignment:
    //                                                   MainAxisAlignment
    //                                                       .center,
    //                                               children: [
    //                                                 ///---name
    //                                                 Text(
    //                                                     '${snapshot.data!.docs[index].get('name')}',
    //                                                     style: _homeLogic
    //                                                         .state
    //                                                         .nameTextStyle),
    //                                                 SizedBox(
    //                                                   height: MediaQuery.of(
    //                                                               context)
    //                                                           .size
    //                                                           .height *
    //                                                       .01,
    //                                                 ),
    //
    //                                                 ///---quantity-discount
    //                                                 Row(
    //                                                   crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .center,
    //                                                   children: [
    //                                                     ///---quantity
    //                                                     Expanded(
    //                                                       child: Align(
    //                                                         alignment:
    //                                                             Alignment
    //                                                                 .centerLeft,
    //                                                         child: Text(
    //                                                             '${snapshot.data!.docs[index].get('quantity')} left',
    //                                                             style: _homeLogic
    //                                                                 .state
    //                                                                 .priceTextStyle),
    //                                                       ),
    //                                                     ),
    //
    //                                                     ///---distance
    //                                                     Expanded(
    //                                                       child: Align(
    //                                                         alignment:
    //                                                             Alignment
    //                                                                 .center,
    //                                                         child: Text(
    //                                                             '${distance}km',
    //                                                             style: _homeLogic
    //                                                                 .state
    //                                                                 .priceTextStyle),
    //                                                       ),
    //                                                     ),
    //
    //                                                     ///---price
    //                                                     Expanded(
    //                                                       child: Align(
    //                                                         alignment:
    //                                                             Alignment
    //                                                                 .center,
    //                                                         child: Text(
    //                                                             '\$${snapshot.data!.docs[index].get('original_price')}',
    //                                                             style: _homeLogic
    //                                                                 .state
    //                                                                 .priceTextStyle!
    //                                                                 .copyWith(decoration: TextDecoration.lineThrough)),
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 SizedBox(
    //                                                   height: MediaQuery.of(
    //                                                               context)
    //                                                           .size
    //                                                           .height *
    //                                                       .01,
    //                                                 ),
    //
    //                                                 ///---price
    //                                                 Row(
    //                                                   crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .center,
    //                                                   children: [
    //                                                     ///---discount
    //                                                     Expanded(
    //                                                       child: Align(
    //                                                         alignment:
    //                                                             Alignment
    //                                                                 .centerLeft,
    //                                                         child: Text(
    //                                                             '${snapshot.data!.docs[index].get('discount')}% off',
    //                                                             style: _homeLogic
    //                                                                 .state
    //                                                                 .priceTextStyle!
    //                                                                 .copyWith(color: Colors.green)),
    //                                                       ),
    //                                                     ),
    //
    //                                                     ///---price
    //                                                     Expanded(
    //                                                       child: Align(
    //                                                         alignment:
    //                                                             Alignment
    //                                                                 .centerRight,
    //                                                         child:
    //                                                             Container(
    //                                                           width: 70,
    //                                                           decoration: BoxDecoration(
    //                                                               borderRadius: BorderRadius.circular(
    //                                                                   19),
    //                                                               color:
    //                                                                   customThemeColor),
    //                                                           child:
    //                                                               Padding(
    //                                                             padding: const EdgeInsets.fromLTRB(
    //                                                                 0,
    //                                                                 2,
    //                                                                 0,
    //                                                                 2),
    //                                                             child:
    //                                                                 Center(
    //                                                               child: Text(
    //                                                                   '\$${snapshot.data!.docs[index].get('dis_price')}',
    //                                                                   style: _homeLogic.state.priceTextStyle!.copyWith(color: Colors.white)),
    //                                                             ),
    //                                                           ),
    //                                                         ),
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                         ))
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             );
    //                           } else {
    //                             return const SizedBox();
    //                           }
    //                         } else {
    //                           return const SizedBox();
    //                         }
    //                       });
    //                 }),
    //               ),
    //             ),
    //             beginOffset: const Offset(0.3, 0.2),
    //             endOffset: const Offset(0, 0),
    //             slideCurve: Curves.linearToEaseOut,
    //           );
    //         }
    //       } else {
    //         return Text(
    //           'Record not found',
    //           textAlign: TextAlign.center,
    //           style: GoogleFonts.poppins(
    //               fontSize: 20,
    //               color: Colors.black,
    //               fontWeight: FontWeight.w600),
    //         );
    //       }
    //     }));
  }
}
