import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../home/logic.dart';
import '../image_full_view/view.dart';
import '../product_detail/view.dart';
import '../book_table/view.dart';
import 'logic.dart';
import 'state.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({Key? key, this.restaurantModel})
      : super(key: key);
  final DocumentSnapshot? restaurantModel;

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final RestaurantDetailLogic logic = Get.put(RestaurantDetailLogic());
  final RestaurantDetailState state = Get.find<RestaurantDetailLogic>().state;
  bool? favourites = false;
  checkWishList(bool? newValue) {
    favourites = newValue;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.currentRestaurant(widget.restaurantModel);

    Get.find<RestaurantDetailLogic>().updateCenter(LatLng(
      double.parse(widget.restaurantModel!.get('lat').toString()),
      double.parse(widget.restaurantModel!.get('lng').toString()),
    ));
    Get.find<RestaurantDetailLogic>()
        .onAddMarkerButtonPressed(context, widget.restaurantModel!.get('name'));
    Get.find<GeneralController>().checkWishList(
        context, widget.restaurantModel!.get('id'), checkWishList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailLogic>(
      builder: (_restaurantDetailLogic) => Scaffold(
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
          actions: [
            InkWell(
              onTap: () {
                if (!favourites!) {
                  Get.find<GeneralController>().addToWishList(context,
                      widget.restaurantModel!.get('id'), 'restaurants');
                  setState(() {
                    favourites = true;
                  });
                } else {
                  Get.find<GeneralController>().deleteWishList(
                      context, widget.restaurantModel!.get('id'));
                  setState(() {
                    favourites = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                child: Icon(
                  favourites! ? Icons.favorite : Icons.favorite_border,
                  color: favourites! ? Colors.red : Colors.black,
                  size: 20,
                ),
              ),
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
            child: ListView(
              children: [
                ///---image
                Hero(
                    tag: '${widget.restaurantModel!.get('image')}',
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(ImageViewScreen(
                              networkImage:
                                  '${widget.restaurantModel!.get('image')}',
                            ));
                          },
                          child: Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                            //   boxShadow: [
                            //   BoxShadow(
                            //     color: customThemeColor.withOpacity(0.19),
                            //     blurRadius: 40,
                            //     spreadRadius: 0,
                            //     offset: const Offset(
                            //         0, 22), // changes position of shadow
                            //   ),
                            // ],
                             borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                '${widget.restaurantModel!.get('image')}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ))),

                ///---name
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text('${widget.restaurantModel!.get('name')}',
                      textAlign: TextAlign.center,
                      style: state.productNameStyle),
                ),

                ///---rating-discount
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.restaurantModel!.get('open_time')} - ${widget.restaurantModel!.get('close_time')}',
                                style: state.productPriceStyle!.copyWith(
                                    color: customTextGreyColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.star,
                              color: customThemeColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Text(
                                _restaurantDetailLogic.averageRating == 0.0
                                    ? 'Not Rated'
                                    : _restaurantDetailLogic.averageRating!
                                        .toStringAsPrecision(2),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                style: state.productPriceStyle!.copyWith(
                                    color: customTextGreyColor, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${(Geolocator.distanceBetween(Get.find<HomeLogic>().latitude!, Get.find<HomeLogic>().longitude!, double.parse(widget.restaurantModel!.get('lat').toString()), double.parse(widget.restaurantModel!.get('lng').toString())) ~/ 1000)}km',
                              style: state.productPriceStyle!.copyWith(
                                  color: customTextGreyColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///---tabs
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: DefaultTabController(
                        length: 3, // length of tabs
                        initialIndex: 0,
                        child: TabBar(
                          isScrollable: true,
                          labelStyle: const TextStyle( fontFamily: 'Poppins',
                              fontSize: 17, fontWeight: FontWeight.w700),
                          labelColor: Colors.white,
                          unselectedLabelColor: customThemeColor,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: customThemeColor,
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

                          onTap: (int? currentIndex) {
                            _restaurantDetailLogic.updateTabIndex(currentIndex);
                          },
                          //TABS USED
                          tabs: const [
                            Tab(
                              text: 'Menu',
                            ),
                            Tab(text: 'About'),
                            Tab(text: 'Book A Table'),
                          ],
                        )),
                  ),
                ),

                ///---tab-views
                if (_restaurantDetailLogic.tabIndex == 0)
                     FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('products')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData ) {
                              if (snapshot.data!.docs.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'products not found',
                                    textAlign: TextAlign.center,
                                    style: TextStyle( fontFamily: 'Poppins',
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              } else {
                                return FadedSlideAnimation(
                                  child: Wrap(
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      if (snapshot.data!.docs[index]
                                              .get('restaurant_id') ==
                                          widget.restaurantModel!.get('id')) {
                                        if (int.parse(snapshot.data!.docs[index]
                                                .get('quantity')
                                                .toString()) >
                                            0) {
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 30, 0, 0),
                                            child: InkWell(
                                              onTap: () {
                                                //!-------------
                                                Get.to(ProductDetailPage(
                                                  isProduct: true,
                                                  productModel: snapshot
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
                                                                  style: state
                                                                      .nameTextStyle),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
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
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          '${snapshot.data!.docs[index].get('quantity')} left',
                                                                          style:
                                                                              state.priceTextStyle),
                                                                    ),
                                                                  ),

                                                                  ///---discount
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          '${snapshot.data!.docs[index].get('discount')}% off',
                                                                          style: state
                                                                              .priceTextStyle!
                                                                              .copyWith(color: Colors.green)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
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
                                                                  ///---price
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: Text(
                                                                          'Rs ${snapshot.data!.docs[index].get('original_price')}',
                                                                          style: state
                                                                              .priceTextStyle!
                                                                              .copyWith(decoration: TextDecoration.lineThrough)),
                                                                    ),
                                                                  ),

                                                                  ///---price
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            70,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(19),
                                                                            color: customThemeColor),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              2,
                                                                              0,
                                                                              2),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text('Rs ${snapshot.data!.docs[index].get('dis_price')}', style: state.priceTextStyle!.copyWith(color: Colors.white)),
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
                                    }),
                                  ),
                                  beginOffset: const Offset(0, 0.3),
                                  endOffset: const Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                );
                              }
                            } else {
                              return 
                              const SizedBox();
                            }
                          }),
                 
                 
                if (_restaurantDetailLogic.tabIndex == 1)
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),

                      ///---about
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  '${widget.restaurantModel!.get('about')}',
                                  style: state.restaurantInfoValueTextStyle),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---phone
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Phone Number',
                              style: state.restaurantInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Get.find<GeneralController>().makePhoneCall(
                                      '${widget.restaurantModel!.get('phone')}');
                                },
                                child: Text(
                                    '${widget.restaurantModel!.get('phone')}',
                                    style: state.restaurantInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---website
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Website',
                              style: state.restaurantInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  launch(
                                      '${widget.restaurantModel!.get('website_address')}');
                                },
                                child: Text(
                                    '${widget.restaurantModel!.get('website_address')}',
                                    style: state.restaurantInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 17,
                      ),

                      ///---address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Address',
                              style: state.restaurantInfoLabelTextStyle),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      double.parse(widget.restaurantModel!
                                          .get('lat')
                                          .toString()),
                                      double.parse(widget.restaurantModel!
                                          .get('lng')
                                          .toString()),
                                      'Here');
                                },
                                child: Text(
                                    '${widget.restaurantModel!.get('address')}',
                                    textDirection: TextDirection.rtl,
                                    style: state.restaurantInfoValueTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ///---map
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            onMapCreated: _restaurantDetailLogic.onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _restaurantDetailLogic.center!,
                              zoom: 15.0,
                            ),
                            mapType: _restaurantDetailLogic.currentMapType,
                            markers: _restaurantDetailLogic.markers,
                            onCameraMove: _restaurantDetailLogic.onCameraMove,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                if (_restaurantDetailLogic.tabIndex == 2)                
                SizedBox(
                  height: 650,
                  child: BookingTable(restaurantModel: widget.restaurantModel!,isProductInclude: false,))
         

             
              ],
            ),
          ),
        ),
      ),
    );
  }
}
