
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../../utils/text_style.dart';
import 'logic.dart';
import 'state.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({Key? key}) : super(key: key);

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final CouponsLogic logic = Get.put(CouponsLogic());
  final CouponsState state = Get.find<CouponsLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.getAllCoupons();
  }

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
            'Coupons',
            style: state.appBarTextStyle,
          ),
        ),
        body: GetBuilder<CouponsLogic>(
          builder: (data) {
            return data.docsList != null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: data.docsList!.isNotEmpty? ListView.builder(
                        itemCount: data.docsList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: customThemeColor.withOpacity(0.19),
                                  //     blurRadius: 40,
                                  //     spreadRadius: 0,
                                  //     offset: const Offset(
                                  //         0, 22), // changes position of shadow
                                  //   ),
                                  // ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: ListTile(
                                    leading: Image.asset(
                                      'assets/logo.png',
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.docsList![index]
                                                      .get('discountMethod')
                                                      .toString() ==
                                                  'Flat Discount'
                                              ? 'Rs ${data.docsList![index].get('discount')} off'
                                              : 'Rs ${data.docsList![index].get('discount')}% off',
                                          style: state.titleTextStyle,
                                        ),
                                        Text(
                                          'Code: ${data.docsList![index].get('discountCouponCode')}',
                                          style: state.subTitleTextStyleGreen,
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${data.docsList![index].get('message')}',
                                      style: state.subTitleTextStyle,
                                    ),
                                  )),
                            ),
                          );
                        }):const Padding(
                          padding:  EdgeInsets.only(top: 30),
                          child: Text(
                            'Record not found',
                            textAlign: TextAlign.center,
                            style: kPlaceStyle,
                          ),
                        )
                    
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: customThemeColor,
                    ),
                  );
          },
        ));
  }
}
