import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import '../../widgets/custom_dotted_divider.dart';
import '../image_full_view/view.dart';
import 'logic.dart';
import 'state.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({Key? key, this.orderModel}) : super(key: key);
  DocumentSnapshot? orderModel;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderDetailLogic logic = Get.put(OrderDetailLogic());
  final OrderDetailState state = Get.find<OrderDetailLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.getCurrentRestaurant(widget.orderModel);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailLogic>(
      builder: (_orderDetailLogic) => Scaffold(
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
            'Order',
            style: state.appBarTextStyle,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: ListView(
              children: [
                ///---image
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Hero(
                      tag: '${widget.orderModel!.get('restaurant_image')}',
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.to(ImageViewScreen(
                                networkImage:
                                    '${widget.orderModel!.get('restaurant_image')}',
                              ));
                            },
                            child: Container(
                              height: 220,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: customThemeColor.withOpacity(0.19),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                  offset: const Offset(
                                      0, 22), // changes position of shadow
                                ),
                              ], borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  '${widget.orderModel!.get('restaurant_image')}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ))),
                ),

                ///---name
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: Text('${widget.orderModel!.get('restaurant')}',
                      textAlign: TextAlign.center,
                      style: state.restaurantNameTextStyle),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     blurRadius: 40,
                        //     spreadRadius: 0,
                        //     offset: const Offset(
                        //         0, 22), // changes position of shadow
                        //   ),
                        // ]
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Take Away?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle( fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.greenColor)),
                              Text(
                                  widget.orderModel!
                                              .get('isTakeAway')
                                              .toString() ==
                                          'true'
                                      ? 'Yes'
                                      : 'No',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle( fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: customTextGreyColor)),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                ),

                ///---restaurant-detail
                _orderDetailLogic.currentRestaurant == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                        child: Column(
                          children: [
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
                                            '${_orderDetailLogic.currentRestaurant!.get('phone')}');
                                      },
                                      child: Text(
                                          '${_orderDetailLogic.currentRestaurant!.get('phone')}',
                                          style: state
                                              .restaurantInfoValueTextStyle),
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
                                            '${_orderDetailLogic.currentRestaurant!.get('website_address')}');
                                      },
                                      child: Text(
                                          '${_orderDetailLogic.currentRestaurant!.get('website_address')}',
                                          style: state
                                              .restaurantInfoValueTextStyle),
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
                                            double.parse(_orderDetailLogic
                                                .currentRestaurant!
                                                .get('lat')
                                                .toString()),
                                            double.parse(_orderDetailLogic
                                                .currentRestaurant!
                                                .get('lng')
                                                .toString()),
                                            'Here');
                                      },
                                      child: Text(
                                          '${_orderDetailLogic.currentRestaurant!.get('address')}',
                                          textDirection: TextDirection.rtl,
                                          style: state
                                              .restaurantInfoValueTextStyle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                const SizedBox(
                  height: 30,
                ),

                ///---otp
                Center(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .5,
                    decoration: BoxDecoration(
                        color: customThemeColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text(
                        'Order OTP: ${widget.orderModel!.get('otp')}',
                        style: state.otpTextStyle,
                      ),
                    ),
                  ),
                ),

                ///---products
                Wrap(
                  children: List.generate(
                      widget.orderModel!.get('product_list').length, (index) {
                    return FadedSlideAnimation(
                      beginOffset: const Offset(0, 0.3),
                      endOffset: const Offset(0, 0),
                      slideCurve: Curves.linearToEaseOut,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                                  tag: '${widget.orderModel!.get('product_list')[index]['image']}',
                                  child: Material(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child:  Image.network(
                                                '${widget.orderModel!.get('product_list')[index]['image']}',
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
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ///---name
                                        Text(
                                            '${widget.orderModel!.get('product_list')[index]['name']}',
                                            style: state.productNameTextStyle),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01,
                                        ),

                                        ///---price
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ///---original-price
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'Rs ${widget.orderModel!.get('product_list')[index]['original_price']}',
                                                    style: state
                                                        .productPriceTextStyle!
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)),
                                              ),
                                            ),

                                            ///---dis_price
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    'Rs ${widget.orderModel!.get('product_list')[index]['dis_price']}',
                                                    style: state
                                                        .productPriceTextStyle!
                                                        .copyWith(
                                                            color:
                                                                customThemeColor)),
                                              ),
                                            ),

                                            ///---quantity
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                      color: customThemeColor),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 2, 0, 2),
                                                    child: Center(
                                                      child: Text(
                                                          'Qty ${widget.orderModel!.get('product_list')[index]['quantity']}',
                                                          style: state
                                                              .productPriceTextStyle!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white)),
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
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * .45,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///---total-price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: state.billLabelTextStyle,
                      ),
                      Text(
                        'Rs ${double.parse(widget.orderModel!.get('total_price').toString()).toPrecision(2)}',
                        style: state.billValueTextStyle,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  ///---total-discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total Discount',
                            style: state.billLabelTextStyle,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            '${widget.orderModel!.get('total_discount_percentage')}%',
                            style: state.discountPercentTextStyle,
                          ),
                        ],
                      ),
                      Text(
                        'Rs ${(double.parse(widget.orderModel!.get('total_discount').toString()) - double.parse(widget.orderModel!.get('coupon_discount').toString())).toPrecision(2)}',
                        style: state.billValueTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  ///---net-price
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Net Price',
                  //       style: state.billLabelTextStyle,
                  //     ),
                  //     Text(
                  //       'Rs ${widget.orderModel!.get('net_price')}',
                  //       style: state.billValueTextStyle,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),

                  ///---donation-price
                  // widget.orderModel!.get('charity').toString() == '0'
                  //     ? const SizedBox()
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Charity Partner Donation',
                  //             style: state.billLabelTextStyle,
                  //           ),
                  //           Text(
                  //             'Rs ${widget.orderModel!.get('charity')}',
                  //             style: state.billValueTextStyle,
                  //           ),
                  //         ],
                  //       ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  MySeparator(
                    color: customTextGreyColor.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  ///---grand-total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grand Total',
                        style: state.grandTotalTextStyle,
                      ),
                      Text(
                        'Rs ${(double.parse(widget.orderModel!.get('grand_total').toString()) - double.parse(widget.orderModel!.get('coupon_discount').toString())).toPrecision(4)}',
                        style: state.grandTotalTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ///---button
                  widget.orderModel!.get('status') == 'Complete'
                      ? Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Order Completed Successfully',
                              style: state.buttonTextStyle,
                            ),
                          ),
                        )
                      : Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              '${widget.orderModel!.get('status')}',
                              style: state.buttonTextStyle,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
