// ignore_for_file: prefer_const_constructors

import 'package:book_a_table/controllers/general_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../utils/color.dart';
import '../home/logic.dart';

class BookingTable extends StatefulWidget {
  const BookingTable(
      {Key? key, required this.restaurantModel, required this.isProductInclude})
      : super(key: key);
  final DocumentSnapshot restaurantModel;
  final bool isProductInclude;
  @override
  State<BookingTable> createState() => _BookingTableState();
}

class _BookingTableState extends State<BookingTable> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  GetStorage boxStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    var data = widget.restaurantModel.get('close_time');
    var closingDate = DateFormat('jm').parse(data);
    var opningDate =
        DateFormat('jm').parse(widget.restaurantModel.get('open_time'));
   //!--- if ending time greater then starting time then it wil be error
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 60,
        bookingEnd: DateTime(
            now.year, now.month, now.day, closingDate.hour, closingDate.minute),
        bookingStart: DateTime(
            now.year, now.month, now.day, opningDate.hour, opningDate.minute));
        //     mockBookingService = BookingService(
        // serviceName: 'Mock Service',
        // serviceDuration: 60,
        // bookingEnd: DateTime(
        //     now.year, now.month, now.day, 18, 0),
        // bookingStart: DateTime(
        //     now.year, now.month, now.day, 10, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {

    return FirebaseFirestore.instance
        .collection('tableBooking')
        .where('restaurant', isEqualTo: widget.restaurantModel.get('name'))
        .snapshots();
    // return widget.restaurantModel.reference.collection('tableBooking').snapshots();
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
        ///---random-string-open
  
  String charsForOtp = '1234567890';
  math.Random rnd = math.Random();
String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  String getRandomOtp(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => charsForOtp.codeUnitAt(rnd.nextInt(charsForOtp.length))));
      String? getOtp = getRandomOtp(5);
   
    final _formKey = GlobalKey<FormState>();
    TextEditingController textEditingController = TextEditingController();
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: textEditingController,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Enter no of guests",
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: customThemeColor)),
                        errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field Required';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          FirebaseFirestore.instance
                              .collection('tableBooking')
                              .add({
                            'bookingStart':
                                newBooking.bookingStart.microsecondsSinceEpoch,
                            'bookingEnd':
                                newBooking.bookingEnd.microsecondsSinceEpoch,
                            'customerName': Get.find<HomeLogic>()
                                .currentUserData!
                                .get('name'),
                            'uid': Get.find<HomeLogic>()
                                .currentUserData!
                                .get('uid'),
                            'person': textEditingController.text,
          'otp': getOtp,
          'date_time': DateTime.now(),
          'id': getRandomString(5),

                            'orderReference': '',
                            'status': 'Pending',
                            'restaurant':
                                widget.restaurantModel.get('name'),
                            'restaurant_id':
                                widget.restaurantModel.get('id'),
                            'restaurant_image':
                                widget.restaurantModel.get('image')
                          }).then((value) {
                            if (widget.isProductInclude) {
                              Get.find<GeneralController>()
                                  .tableBookingDocumentReference = value;
                              Get.find<GeneralController>().update();
                            }
                          });
                          Get.back();
                          Get.back();
                        }
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: customThemeColor,
                          borderRadius: BorderRadius.circular(30),
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
                        child: Center(
                          child: Text(
                            "Book Table",
                          ),
                        ),
                      ),
                    ),
                  ),
               
                ],
              ),
            ),
          );
        });

    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    if (streamResult == null) {
      print('stream is null');
    } else {
      print('stream is not null');

      var s = streamResult as QuerySnapshot<Map<String, dynamic>>;
      s.docs.forEach((event) {
        print('in the for each');
        converted.add(DateTimeRange(
            start:
                DateTime.fromMicrosecondsSinceEpoch(event.get('bookingStart')),
            end: DateTime.fromMicrosecondsSinceEpoch(event.get('bookingEnd'))));
      });
    }
    print(converted);
    return converted;
  }


               
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: 
        AppBar(
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
            'Orders',
            style: const TextStyle(        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor,
    fontFamily: 'Poppins',),
          ),
        ),
  
      body: Center(
        child: BookingCalendar(
          
          bookingGridCrossAxisCount: 3,
          bookingGridChildAspectRatio: 1,
          bookingService: mockBookingService,
          bookingButtonColor: AppColors.greenColor,
          
          bookingButtonText: 'Book Now',
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,

        ),
      ),
    );
  }
}
