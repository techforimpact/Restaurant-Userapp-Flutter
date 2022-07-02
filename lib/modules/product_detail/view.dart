
import 'package:book_a_table/controllers/general_controller.dart';
import 'package:book_a_table/modules/home/logic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../route_generator.dart';
import '../../utils/color.dart';
import '../image_full_view/view.dart';
import '../restaurant_detail/view.dart';
import 'logic.dart';
import 'state.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage(
      {Key? key,
      this.productModel,
      this.isProduct=true,
      this.index,
      this.mapProductModel,
      this.imageForBag})
      : super(key: key);

  final DocumentSnapshot? productModel;
  final Map<String, dynamic>? mapProductModel;
  final bool? isProduct;
  final int? index;
  final String? imageForBag;
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductDetailLogic logic = Get.put(ProductDetailLogic());
  final ProductDetailState state = Get.find<ProductDetailLogic>().state;
  final _generalController = Get.find<GeneralController>();
  bool? favourites = false;
  checkWishList(bool? newValue) {
    favourites = newValue;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _generalController.updateFormLoader(false);
    logic.getCartInfoForProduct(widget.productModel);
    logic.currentProduct(
        widget.productModel, 'products' );
    Get.find<GeneralController>()
        .checkWishList(context, widget.productModel!.get('id'), checkWishList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailLogic>(
      builder: (_productDetailLogic) => ModalProgressHUD(
        inAsyncCall: _generalController.formLoader!,
        progressIndicator: const CircularProgressIndicator(
          color: customThemeColor,
        ),
        child: Scaffold(
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
            actions: [
              InkWell(
                onTap: () {
                  if (!favourites!) {
                    Get.find<GeneralController>().addToWishList(
                        context, widget.productModel!.get('id'),'products' );
                    setState(() {
                      favourites = true;
                    });
                  } else {
                    Get.find<GeneralController>().deleteWishList(
                        context, widget.productModel!.get('id'));
                    setState(() {
                      favourites = false;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                  child: AnimatedSwitcher(
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      favourites! ? Icons.favorite : Icons.favorite_border,
                      color: favourites! ? Colors.red : Colors.black,
                      size: 20,
                      key: ValueKey<bool>(favourites!),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: ListView(
                children: [
                  ///---image
                  widget.isProduct!
                      ? Hero(
                          tag: '${widget.productModel!.get('image')}',
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.to(ImageViewScreen(
                                    networkImage:
                                        '${widget.productModel!.get('image')}',
                                  ));
                                },
                                child: Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                  //   boxShadow: [
                                  //   BoxShadow(
                                  //     color: customThemeColor.withOpacity(0.19),
                                  //     blurRadius: 40,
                                  //     spreadRadius: 0,
                                  //     offset: const Offset(
                                  //         0, 22), // changes position of shadow
                                  //   ),
                                  // ],
                                   borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      '${widget.productModel!.get('image')}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )))
                      : Hero(
                          tag: 'assets/bite-bag-full.png${widget.index}',
                          child: Material(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .45,
                                  width: MediaQuery.of(context).size.width * .9,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/bite-bag-full.png',
                                        fit: BoxFit.fill,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 40),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                                    widget.productModel!.get('image'),
                                                    height: 120,
                                                    width: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  ///---name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Text(
                       
                            '${widget.productModel!.get('name')}'
                            
                            ,
                        textAlign: TextAlign.center,
                        style: state.productNameStyle),
                  ),

                  ///---restaurant
                  InkWell(
                    onTap: () async {
                      _generalController.updateFormLoader(true);
                      QuerySnapshot query = await FirebaseFirestore.instance
                          .collection('restaurants')
                          .where("id",
                              isEqualTo:
                                  widget.productModel!.get('restaurant_id'))
                          .get();
                      if (query.docs.isNotEmpty) {
                        Get.to(RestaurantDetailPage(
                          restaurantModel: query.docs[0],
                        ));
                        _generalController.updateFormLoader(false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('${widget.productModel!.get('restaurant')}',
                          textAlign: TextAlign.center,
                          style: state.restaurantNameStyle),
                    ),
                  ),

                  ///---price
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                                color: customThemeColor),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Center(
                                child: Text(
                                    'Rs ${widget.productModel!.get('dis_price')}',
                                    style: state.productPriceStyle),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                              'Rs ${widget.productModel!.get('original_price')}',
                              style: state.productPriceStyle!.copyWith(
                                  color: customTextGreyColor,
                                  decoration: TextDecoration.lineThrough)),
                        ),
                      ],
                    ),
                  ),

                  ///---rating-discount
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.star,
                                color: customThemeColor,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                _productDetailLogic.averageRating!
                                    .toStringAsPrecision(2),
                                style: state.productPriceStyle!.copyWith(
                                    color: customTextGreyColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                              '${widget.productModel!.get('discount')}% off',
                              style: state.productPriceStyle!
                                  .copyWith(color: Colors.green, fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                              '${widget.productModel!.get('quantity')} left',
                              style: state.productPriceStyle!.copyWith(
                                  color: customTextGreyColor, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),

                  ///---categories
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category',
                            textAlign: TextAlign.start,
                            style: state.headingTextStyle),
                        Wrap(
                          children: List.generate(
                              widget.productModel!.get('category').length,
                              (index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                              child: Text(
                                  '${widget.productModel!.get('category')[index]}',
                                  textAlign: TextAlign.start,
                                  style: state.descTextStyle),
                            );
                          }),
                        )
                      ],
                    ),
                  ),

                  ///---chef's-note
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chef\'s Note',
                            textAlign: TextAlign.start,
                            style: state.headingTextStyle),
                        Text('${widget.productModel!.get('chef_note')}',
                            textAlign: TextAlign.start,
                            style: state.descTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: customThemeColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (_productDetailLogic.cartCount! > 1) {
                        _productDetailLogic.updateCartCount(
                            _productDetailLogic.cartCount! - 1);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_productDetailLogic.maxCartCount! <
                          (int.parse(widget.productModel!
                              .get('quantity')
                              .toString()))) {
                                print('add to the cart');
                        _generalController.updateFormLoader(true);
                        _productDetailLogic.addToCart(
                            context, widget.productModel);
                            Get.find<HomeLogic>().update;
                      } else {
                        Get.snackbar('Already Added', '',
                            colorText: Colors.white,
                            backgroundColor: customThemeColor.withOpacity(0.7),
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(15),
                            onTap: (GetSnackBar snackBar) {
                          Get.toNamed(PageRoutes.cart);
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Add ${_productDetailLogic.cartCount} to cart',
                        style: state.cartButtonStyle,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('11111111111');
                      print(_productDetailLogic.cartCount!);
                      print(int.parse(widget.productModel!
                                  .get('quantity')
                                  .toString()));
                      if (_productDetailLogic.cartCount! <
                          (int.parse(widget.productModel!
                                  .get('quantity')
                                  .toString()) -
                              _productDetailLogic.maxCartCount!)) {
                        _productDetailLogic.updateCartCount(
                            _productDetailLogic.cartCount! + 1);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
