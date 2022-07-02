
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../controllers/general_controller.dart';
import '../../route_generator.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';
import 'view_phone_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic logic = Get.put(LoginLogic());
  final LoginState state = Get.find<LoginLogic>().state;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool? obscureText = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
      builder: (_loginLogic) => GestureDetector(
        onTap: () {
          Get.find<GeneralController>().focusOut(context);
        },
        child: GetBuilder<GeneralController>(
          builder: (_generalController) => ModalProgressHUD(
            inAsyncCall: _generalController.formLoader!,
            progressIndicator:  const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: MediaQuery.of(context).size.width * .4,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---email-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _loginLogic.emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder:  const UnderlineInputBorder(
                                  borderSide:
                                       BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else if (!GetUtils.isEmail(
                                  _loginLogic.emailController.text)) {
                                return 'Enter Valid Email';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---password-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _loginLogic.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Colors.black,
                            obscureText: obscureText!,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: state.labelTextStyle,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText!;
                                  });
                                },
                                child: Icon(
                                  !obscureText!
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: customThemeColor,
                                  size: 25,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder:  const UnderlineInputBorder(
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        ///---login-button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              _generalController.focusOut(context);
                              if (_loginFormKey.currentState!.validate()) {
                                _generalController.updateFormLoader(true);
                                _generalController.firebaseAuthentication
                                    .signInWithEmailAndPassword();
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
                                child:
                                    Text("Login", style: state.buttonTextStyle),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Forget password? ",
                                style: state.doNotTextStyle),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(PageRoutes.forgetPassword);
                              },
                              child: Text("Get Password",
                                  style: state.registerTextStyle),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New to Book-a-table? ",
                                style: state.doNotTextStyle),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(PageRoutes.signUp);
                              },
                              child: Text("Register",
                                  style: state.registerTextStyle),
                            )
                          ],
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Divider(
                                  color: customThemeColor.withOpacity(0.9),
                                  height: 50,
                                )),
                          ),
                          Text(
                            "OR",
                            style: state.doNotTextStyle,
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: Divider(
                                  color: customThemeColor.withOpacity(0.9),
                                  height: 50,
                                )),
                          ),
                        ]),

                        ///---phone-signIn
                        InkWell(
                          onTap: () {
                            Get.toNamed(PageRoutes.phoneLogin);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               const Icon(
                                Icons.phone,
                                color: customThemeColor,
                              ),
                              Text(" Sign In with Phone Number",
                                  style: state.registerTextStyle)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  _generalController.updateFormLoader(true);
                                  _generalController.firebaseAuthentication
                                      .signInWithGoogle();
                                },
                                child: Image.asset(
                                  'assets/google.png',
                                  height: 50,
                                  width: 70,
                                ),
                              )),
                            ),
                         
                          ],
                        ),
                        SizedBox(height: 20,),
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
}
