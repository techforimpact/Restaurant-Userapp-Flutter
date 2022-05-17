import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'dart:math' as math;

import '../../controllers/general_controller.dart';
import '../../route_generator.dart';
import '../../utils/color.dart';
import 'logic.dart';
import 'state.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final OnBoardLogic logic = Get.put(OnBoardLogic());

  final OnBoardState state = Get.find<OnBoardLogic>().state;

  int page = 0;
  LiquidController? liquidController;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      math.max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            pages: [
              ///---first
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: customThemeColor,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Kia Ora !",
                              style: state.mainHeading,
                            ),
                            Text(
                              "Welcome to Book-a-Bite",
                              style: state.mainTitle,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/onBoard_01.png',
                            width: MediaQuery.of(context).size.width * .95,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/onBoardBottom_01.png',
                          width: MediaQuery.of(context).size.width * .5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///---second
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: customGreenColor,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Save Food.\nShop Local.\nSpend Less.",
                              textAlign: TextAlign.center,
                              style: state.subHeading,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Reduce food waste and your\ncarbon footprint by saving\nfood "
                              "from your local\nBite Hubs",
                              textAlign: TextAlign.center,
                              style: state.subTitle,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/onBoard_02.png',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///---third
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: customThemeColor,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Earn Points.\nGet Rewards.\nCollect Badges.",
                              textAlign: TextAlign.center,
                              style: state.subHeading,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Earn points in our Zero Hero"
                              "\nrewards scheme and collect"
                              "\nvouchers towards future purchases",
                              textAlign: TextAlign.center,
                              style: state.subTitle,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/onBoard_03.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///---forth
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: customGreenColor,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Bite Alert.",
                              textAlign: TextAlign.center,
                              style: state.subHeading,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Get Bite alert notifications when"
                              "\nyou favourite a Bite Hub on the"
                              "\napp so you never miss out !!",
                              textAlign: TextAlign.center,
                              style: state.subTitle,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/onBoard_04.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .6,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///---fifth
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: customGreenColor,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Get NFT Rewards",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              
                              "Collect Zero Hero points and \n participate in our campaigns to unlock \n exclusive NFT rewards",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/onBoard_05.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .7,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            fullTransitionValue: 200,
            enableSideReveal: false,
            enableLoop: false,
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            slidePercentCallback: slidePercentCallback,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Spacer(),
                page == 4
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            Get.find<GeneralController>()
                                .boxStorage
                                .write('welcomeDone', 'true');
                            Get.offAllNamed(PageRoutes.login);
                          },
                          child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .4,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                'Get Started',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(5, _buildDot),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    log('ControllerIndex--->>>${liquidController!.currentPage.toString()}');
    log('PageIndex--->>>${lpage.toString()}');
    setState(() {
      page = lpage;
    });
  }

  slidePercentCallback(double hor, double ver) {
    // log(hor.toInt().toString() + "    " + ver.toString());
  }
}
