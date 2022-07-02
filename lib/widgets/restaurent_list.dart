import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart' as geo_locator;

import '../utils/color.dart';
import '../modules/home/logic.dart';
import '../modules/restaurant_detail/view.dart';

class BookNowRestaurentListWidget extends StatefulWidget {
  const BookNowRestaurentListWidget({Key? key}) : super(key: key);

  @override
  _BookNowRestaurentListWidgetState createState() =>
      _BookNowRestaurentListWidgetState();
}

class _BookNowRestaurentListWidgetState
    extends State<BookNowRestaurentListWidget> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<BookNowLogic>(
        builder: (_bookNowLogic) => FutureBuilder<List<CustomDocument>>(
            future: _bookNowLogic.getRestaurentList(),
            builder: (context, snapshot) {
              if (snapshot.hasData ) {
                var data = snapshot.data!;
           
                return FadedSlideAnimation(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(data.length, (index) {
                        
                     
                        double avgRating = 0.0;
                        List.generate(
                            data[index].restaurentDocumentSnapshot.get('ratings').length,
                            (innerIndex) => avgRating = avgRating +
                                data[index].restaurentDocumentSnapshot.get('ratings')[innerIndex]);
                            
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Get.to(RestaurantDetailPage(
                                restaurantModel: data[index].restaurentDocumentSnapshot,
                              ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    ///---image
                                    Hero(
                                      tag: '${data[index].restaurentShowList['image']}',
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
                                            child: data[index].restaurentShowList['image']==null? const Text(''): Image.network(
                                              '${data[index].restaurentShowList['image']}',
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
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ///---name
                                            Text('${data[index].restaurentShowList['name']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .01,
                                            ),

                                            ///---timings
                                            Text(
                                                '${data[index].restaurentDocumentSnapshot['open_time']} - ${data[index].restaurentDocumentSnapshot['close_time']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppColors.redColor,
                                                )),
                                            SizedBox(
                                              height: MediaQuery.of(context)
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
                                                Expanded(
                                                  child: Text(
                                                    '${data[index].restaurentShowList['distance']  } km',
                                                  ),
                                                ),

                                                ///---rating
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${avgRating == 0.0 ? 'Not Rated' : avgRating}',
                                                        ),
                                                      ),
                                                    ],
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
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
 bool isAC=false;
  bool isTV=false;
  bool isWifi=false;
  bool isplay= false;

  void setIsAC(bool ac){
    isAC=ac;
  }

  void setIsTV(bool tv){
    isTV=tv;
  }
  void setIsWifi(bool wifi){
    isWifi=wifi;
  }
  void setIsPlay(bool play){
    isplay=play;
  }