import 'package:animation_wrappers/animations/faded_slide_animation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color.dart';
import '../../restaurant_detail/view.dart';
import '../logic.dart';

class RestaurentListWidget extends StatefulWidget {
  const RestaurentListWidget({Key? key}) : super(key: key);

  @override
  _RestaurentListWidgetState createState() => _RestaurentListWidgetState();
}

class _RestaurentListWidgetState extends State<RestaurentListWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) => FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Wrap(
            children: List.generate(_homeLogic.restaurentShowList.length, (index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: InkWell(
                  onTap: () {
                    Get.to(RestaurantDetailPage(
                      restaurantModel:
                          _homeLogic.restaurentDocumentSnapshotList[index],
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
                            tag:
                                '${_homeLogic.restaurentShowList[index]['image']}',
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
                                    '${_homeLogic.restaurentShowList[index]['image']}',
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
                                      '${_homeLogic.restaurentShowList[index]['name']}',
                                      style: _homeLogic.state.nameTextStyle),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),

                                  ///---timings
                                  Text(
                                      '${_homeLogic.restaurentShowList[index]['open_time']} - ${_homeLogic.restaurentShowList[index]['close_time']}',
                                      style: _homeLogic.state.priceTextStyle),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///---distance
                                      Text(
                                          '${_homeLogic.restaurentShowList[index]['distance']}km',
                                          style:
                                              _homeLogic.state.priceTextStyle),

                                      ///---rating
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 20,
                                          ),
                                          Text(
                                              '${double.parse(_homeLogic.restaurentShowList[index]['avg_rating'].toString()) == 0.0 ? 'Not Rated' : _homeLogic.restaurentShowList[index]['avg_rating']}',
                                              style: _homeLogic
                                                  .state.priceTextStyle),
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
            }),
          ),
        ),
        beginOffset: const Offset(0.3, 0.2),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
