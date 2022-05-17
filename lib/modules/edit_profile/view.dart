import 'dart:developer';
import 'dart:io';


import 'package:book_a_table/modules/edit_profile/view_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../controllers/general_controller.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, this.userModel}) : super(key: key);

  final DocumentSnapshot? userModel;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileLogic logic = Get.put(EditProfileLogic());

  final EditProfileState state = Get.find<EditProfileLogic>().state;

  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<EditProfileLogic>().requestLocationPermission(context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Get.find<GeneralController>().updateFormLoader(false);
    });
    logic.setData(widget.userModel);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileLogic>(
      builder: (_editProfileLogic) => GetBuilder<GeneralController>(
        builder: (_generalController) => GestureDetector(
          onTap: () {
            Get.find<GeneralController>().focusOut(context);
          },
          child: ModalProgressHUD(
            inAsyncCall: _generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                leading: InkWell(
                  onTap: () async {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: customThemeColor,
                    size: 25,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _editProfileFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---image
                        InkWell(
                          onTap: () {
                            imagePickerDialog(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * .2,
                            decoration: BoxDecoration(
                                color: customTextGreyColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: (_editProfileLogic.downloadURL == null ||
                                    _editProfileLogic.downloadURL!.isEmpty)
                                ? _editProfileLogic.userImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _editProfileLogic.userImage!,
                                          fit: BoxFit.cover,
                                        ))
                                    : const Icon(
                                        Icons.add_a_photo,
                                        color: customThemeColor,
                                        size: 25,
                                      )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      _editProfileLogic.downloadURL!,
                                      fit: BoxFit.cover,
                                    )),
                          ),
                        ),
                        Text(
                          'Profile Image',
                          style: state.labelTextStyle,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---name-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _editProfileLogic.nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
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

                        ///---email-field
                        Get.find<GeneralController>()
                                    .boxStorage
                                    .read('loginType') ==
                                'email'
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                child: TextFormField(
                                  controller: _editProfileLogic.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: state.labelTextStyle,
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: customThemeColor)),
                                    errorBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Required';
                                    } else if (!GetUtils.isEmail(
                                        _editProfileLogic
                                            .emailController.text)) {
                                      return 'Enter Valid Email';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),

                        ///---phone-field
                        Get.find<GeneralController>()
                                    .boxStorage
                                    .read('loginType') ==
                                'phone'
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6F7FC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IntlPhoneField(
                                    initialCountryCode: 'IN',
                                    controller:
                                        _editProfileLogic.phoneController,
                                    style:
                                        const TextStyle( fontFamily: 'Poppins',color: Colors.black),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                      filled: true,
                                      fillColor: const Color(0xffF6F7FC),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      counterText: '',
                                      labelText: 'Phone Number',
                                      labelStyle: state.labelTextStyle,
                                      errorBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black
                                                  .withOpacity(0.5))),
                                    ),
                                    onChanged: (phone) {
                                      log(phone.completeNumber);
                                    },
                                    onCountryChanged: ( phone) {
                                      _editProfileLogic.phoneController.clear();
                                      setState(() {});
                                      log('Country code changed to: ' +
                                          phone.code.toString());
                                    },
                                  ),
                                ),
                              ),

                        ///---location
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                              Get.to(const MapEditView());
                            },
                            controller: _editProfileLogic.addressController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
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

                        ///---add-product-button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              _generalController.focusOut(context);
                              if (_editProfileFormKey.currentState!
                                  .validate()) {
                                _generalController.updateFormLoader(true);
                                _editProfileLogic.uploadFile(
                                    _editProfileLogic.userImage,
                                    context,
                                    widget.userModel!.id);
                              } else {
                                Get.snackbar(
                                  'Fill All Fields Please...',
                                  '',
                                  colorText: Colors.white,
                                  backgroundColor:
                                      customThemeColor.withOpacity(0.7),
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(15),
                                );
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
                                child: Text("UPDATE",
                                    style: state.buttonTextStyle),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List userImagesList = [];
  void imagePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      userImagesList = [];
                    });
                    userImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Camera,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    if (userImagesList != null) {
                      setState(() {
                        Get.find<EditProfileLogic>().userImage =
                            File(userImagesList[0].path);
                      });
                      log(userImagesList[0].path);
                    }
                  },
                  child: Text(
                    "Camera",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 18),
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      userImagesList = [];
                    });
                    userImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Gallery,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    if (userImagesList != null) {
                      setState(() {
                        Get.find<EditProfileLogic>().userImage =
                            File(userImagesList[0].path);
                      });
                      log(userImagesList[0].path);
                    }
                  },
                  child: Text(
                    "Gallery",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 18),
                  )),
            ],
          );
        });
  }
}
