
import 'package:book_a_table/controllers/auth_controller.dart';
import 'package:book_a_table/controllers/general_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../route_generator.dart';
import '../../utils/color.dart';
import '../../utils/text_style.dart';
import '../edit_profile/view.dart';
import '../home/logic.dart';
import '../image_full_view/view.dart';
import 'logic.dart';
import 'state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileLogic logic = Get.put(ProfileLogic());
  final ProfileState state = Get.find<ProfileLogic>().state;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) => Scaffold(
      
        body: 
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: ListView(
                children: [
                  ///---heading
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Text(
                          'My Profile',
                          style: state.headingTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: GestureDetector(
                          onTap: (){
                            Get.find<GeneralController>().firebaseAuthentication.signOut();
                          },
                          child: Icon(Icons.logout_rounded)),
                      ),
                    ],
                  ),

                  ///---info-detail
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal details',
                          style: kTopHeadingStyle,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                             
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///---image
                                _homeLogic.currentUserData?.get('image') == ''
                                    ? const SizedBox()
                                    : Hero(
                                        tag:
                                            '${_homeLogic.currentUserData?.get('image')}',
                                        child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(ImageViewScreen(
                                                  networkImage:
                                                      '${_homeLogic.currentUserData?.get('image')}',
                                                ));
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                height: 90,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .23,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                    '${_homeLogic.currentUserData?.get('image')}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ))),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///---name
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_homeLogic.currentUserData ?.get('name')}',
                                          style: state.nameTextStyle,
                                        ),
                                        Text(
                                          '${_homeLogic.currentUserData ?.get('email')}',
                                          style: state.detailTextStyle,
                                        ),
                                        Divider(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),

                                    ///---phone
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_homeLogic.currentUserData!.get('phone')}',
                                          style: state.detailTextStyle,
                                        ),
                                        Divider(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),

                                    ///---phone
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_homeLogic.currentUserData!.get('address')}',
                                          style: state.detailTextStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  ///---pending-review
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(PageRoutes.pendingReview);
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                      
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Pending Reviews',
                                  style: state.tileTitleTextStyle,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///---saved-cards
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(PageRoutes.savedCards);
                      },
                      child: Container(
                        height: 60,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'My Saved Cards',
                                  style: state.tileTitleTextStyle,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///---notifications
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(PageRoutes.notifications);
                      },
                      child: Container(
                        height: 60,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Notifications',
                                  style: state.tileTitleTextStyle,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,)
                ],
              )),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
          child: InkWell(
            onTap: () {
              //!--------
              Get.to(EditProfilePage(
                userModel: _homeLogic.currentUserData,
              ));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: customThemeColor,
                  borderRadius: BorderRadius.circular(30)),
              child:  Center(
                child:  Text(
                  'Update',
                  style: kTopHeadingStyle.copyWith(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
