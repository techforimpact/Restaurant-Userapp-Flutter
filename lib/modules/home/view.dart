// ignore_for_file: prefer_const_constructors

import 'package:book_a_table/modules/home/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../../widgets/custom_appbar.dart';
import '../product_detail/view.dart';

import 'wigdets/restaurent_list.dart';
import 'wigdets/top_fillters.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  PageController pageController = PageController(viewportFraction: .8);
  late PageController _pageController;
  int? prevPage;
  final HomeLogic logic = Get.find<HomeLogic>();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
        builder: (controller) => Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  CustomAppbar(),
                  //Top Categories:
                  const TopMenuCategories(),
                  Expanded(
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Top Offers",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                        ),
                        //Top offers
                        _topOffers(),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Restaurents",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                        ),
                        //restaurents
                        RestaurentListWidget(),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
//---------------customAppBar------------

//---------------------------
  Widget _topOffers() {
    return GetBuilder<HomeLogic>(
      builder: (_homeLogic) {
       
        return 
        SizedBox(
            height: 350,
            child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _homeLogic.productsShowList.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(ProductDetailPage(
                        isProduct: true,
                        productModel:
                            _homeLogic.productsDocumentSnapshotList[index],
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 250,
                          width: 100,
                          color: AppColors.greenColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Hero(
                                tag:
                                    '${_homeLogic.productsShowList[index]['image']}',
                                child: SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      '${_homeLogic.productsShowList[index]['image']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),

                              ///---distence-discount

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ///---quantity
                                  Text(
                                      '${_homeLogic.productsShowList[index]['quantity']} left',
                                      style: _homeLogic.state.priceTextStyle!
                                          .copyWith(color: Colors.black)),

                                  ///---distance
                                  Text(
                                      '${_homeLogic.productsShowList[index]['distance']}km',
                                      style: _homeLogic.state.priceTextStyle!
                                          .copyWith(color: Colors.black)),
                                ],
                              ),

                              ///---rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                      Text(
                                          '${double.parse(_homeLogic.restaurentDocumentSnapshotList[index].get('ratings').length.toString()) == 0.0 ? 'Not Rated' : _homeLogic.restaurentShowList[index]['avg_rating']}',
                                          style: _homeLogic
                                              .state.priceTextStyle!
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),

                                  ///---discount
                                  Text(
                                      '${_homeLogic.productsShowList[index]['discount']}% off',
                                      style: _homeLogic.state.priceTextStyle!
                                          .copyWith(color: Colors.green)),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    _homeLogic.productsDocumentSnapshotList[index]
                                        .get('name'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  SizedBox(),
                                ],
                              ),

                              ///---price
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Rs${_homeLogic.productsShowList[index]['original_price']}',
                                        style: _homeLogic.state.priceTextStyle!
                                            .copyWith(
                                                color: Colors.black,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.redColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        )),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Text(
                                      "R${_homeLogic.productsDocumentSnapshotList[index].get('original_price')}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }));
   
      },
    );
  }
}
