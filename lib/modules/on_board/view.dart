import 'package:book_a_table/controllers/general_controller.dart';
import 'package:book_a_table/modules/login/view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  int _current = 0;

  final CarouselController _controller = CarouselController();

  List<int> list = [1, 2, 3];
  bool isCompleted = false;

  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 1, end: 1).animate(_animationController);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(33.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              CarouselSlider(
                items: [
                  Column(
                    children: [
                      SizedBox(
                          height: 200,
                          child: ScaleTransition(
                            scale: _animation,
                            child: SvgPicture.asset(
                                'assets/onboarding/onboarding1.svg'),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Find Your Nearest Restaurants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                              height: 200,
                              child: SvgPicture.asset(
                                  'assets/onboarding/onboarding2.1.svg')),
                          SizedBox(
                              height: 200,
                              child: SvgPicture.asset(
                                  'assets/onboarding/onboarding2.2.svg')),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Never wait for your food again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: SvgPicture.asset(
                              'assets/onboarding/onboarding3.svg')),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          'Filter you nearest cafes according to your needs.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ],
                carouselController: _controller,
                options: CarouselOptions(
                    height: 350,
                    reverse: false,
                    autoPlayInterval: Duration(seconds: 2),
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      if (index == 2) {
                        isCompleted = true;
                      }
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: list.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Color(0xffF28844))
                              .withOpacity(_current == entry.key ? 0.9 : 0.0)),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 43,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) {
                    //     return LoginPage();
                    //   },
                    // ));
                    if (isCompleted) {
                          Get.find<GeneralController>()
                                .boxStorage
                                .write('welcomeDone', 'true');
                      Get.offAll(LoginPage());
                      
                    }else{
                    _controller.nextPage();

                    }
                  },
                  child:Text(isCompleted? 'Get Started':'Next') ,
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffF28844),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                ),
              ),
              Spacer(),
              Visibility(
                visible: !isCompleted,
                child: InkWell(
                    onTap: () {
                       Get.find<GeneralController>()
                                .boxStorage
                                .write('welcomeDone', 'true');
                      Get.offAll(LoginPage());
                    },
                    child: Text('Skip')),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
