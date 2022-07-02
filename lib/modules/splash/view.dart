import 'dart:async';


import 'package:book_a_table/modules/home/view.dart';
import 'package:book_a_table/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/general_controller.dart';
import '../login/view.dart';
import '../on_board/view.dart';
import 'logic.dart';
import 'state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashLogic logic = Get.put(SplashLogic());
  final SplashState state = Get.find<SplashLogic>().state;

  void navigator() {
    Get.offAll(const ScreenController());
  }

  /// Set timer SplashScreenTemplate1
  Future<Timer> _timer() async {
    return Timer(const Duration(milliseconds: 4300), navigator);
  }

  @override
  void initState() {
    super.initState();
    _timer();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,  
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: MediaQuery.of(context).size.width * .7,
          ),
         
        ],
      ),
    ));
  }
}

class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<GeneralController>().boxStorage.hasData('welcomeDone')) {
      if (Get.find<GeneralController>().boxStorage.hasData('session')) {
        return const Home();
      } else {
        return const LoginPage();
      }
    } else {
      return const OnBoarding();
    }
  }
}
