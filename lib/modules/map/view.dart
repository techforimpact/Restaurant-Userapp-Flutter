// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';
import '../home/logic.dart';
import '../restaurant_detail/view.dart';
import 'logic.dart';
import 'state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapLogic logic = Get.put(MapLogic());
  final MapState state = Get.find<MapLogic>().state;
  GoogleMapController? _controller;
  BitmapDescriptor? customIcon;
  bool isMapCreated = false;
  String? _mapStyle;
  List<Marker> allMarkers = [];

  PageController? _pageController;

  int? prevPage;

  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/mapLocator.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/mapLocator.png');
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller!.setMapStyle(mapStyle);
  }

  _restaurantList(index, QueryDocumentSnapshot snapshot) {
    String _id = snapshot.id;
    String _image = snapshot.get('image') ?? '';
    String _title = snapshot.get('name');
    String _address = snapshot.get('address');
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext? context, Widget? widget) {
        double value = 1;
        if (_pageController!.position.haveDimensions) {
          value = _pageController!.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: 180.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: InkWell(
          onTap: () {
            //!---
            Get.to(RestaurantDetailPage(
              restaurantModel: snapshot,
            ));
          },
          child: Container(
         
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              // boxShadow: [
              //   BoxShadow(
              //     color: customThemeColor.withOpacity(0.19),
              //     blurRadius: 40,
              //     spreadRadius: 0,
              //     offset: const Offset(0, 15), // changes position of shadow
              //   ),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "hero-grid-$_id",
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: AssetImage('assets/splash_01.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _title.length > 13
                              ? '${_title.substring(0, 13)}...'
                              : _title,
                          softWrap: true,
                          maxLines: 2,
                          style: TextStyle( fontFamily: 'Poppins',
                          overflow: TextOverflow.ellipsis,
                              
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: customGreenColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Icon(
                                Icons.location_on,
                                size: 25.0,
                                color: customThemeColor,
                              ),
                              SizedBox(
                                width: 140.0,
                                child: Text(
                                  _address,
                                  style: TextStyle( fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      color: const Color(0xffBDBDBD)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  List<QueryDocumentSnapshot> allSnapshot = [];

  @override
  Widget build(BuildContext context) {
    var homeController = Get.find<HomeLogic>();

    createMarker(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1E2026),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('restaurants')
              .where('isActive', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  )),
                ],
              );
            } else if (snapshot.hasData) {
              var docList = snapshot.data!.docs;
              for (var element in docList) {
                allSnapshot.add(element);
                allMarkers.add(Marker(
                    onTap: () {
                      //-----------
                      _pageController!.jumpToPage(docList.indexOf(element));
                    },
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                    markerId: MarkerId(element.get('name')),
                    draggable: false,
                    infoWindow: InfoWindow(
                        onTap: () {
                          //!-----------
                          // Get.to(RestaurantDetailPage(
                          //   restaurantModel: element,
                          // ));
                        },
                        title: element.get('name'),
                        snippet: element.get('address')),
                    position: LatLng(
                        double.parse(element.get('lat').toString()),
                        double.parse(element.get('lng').toString()))));
              }
              return Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: snapshot.data!.docs.isEmpty
                        ? GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(homeController.latitude!,
                                    homeController.longitude!),
                                zoom: 13.0),
                            markers: Set.from(allMarkers),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                              // _controller.setMapStyle(_mapStyle);
                            },
                          )
                        : GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(snapshot.data!.docs[0]
                                        .get('lat')
                                        .toString()),
                                    double.parse(snapshot.data!.docs[0]
                                        .get('lng')
                                        .toString())),
                                zoom: 13.0),
                            markers: Set.from(allMarkers),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                              // _controller.setMapStyle(_mapStyle);
                            },
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _restaurantList(
                              index, snapshot.data!.docs[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  moveCamera() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            double.parse(allSnapshot[_pageController!.page!.toInt()]
                .get('lat')
                .toString()),
            double.parse(allSnapshot[_pageController!.page!.toInt()]
                .get('lng')
                .toString())),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
