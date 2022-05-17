import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'state.dart';

class RestaurantDetailLogic extends GetxController {
  final state = RestaurantDetailState();
  double? averageRating = 0;
  currentRestaurant(DocumentSnapshot? productModel) async {
    for (int i = 0; i < productModel!.get('ratings').length; i++) {
      averageRating = productModel.get('ratings')[i] + averageRating;
    }
    averageRating = (averageRating!) / productModel.get('ratings').length;
    if (averageRating.toString() == 'NaN') {
      averageRating = 0.0;
      log('averageRating--->>$averageRating');
    }
  }

  int? tabIndex = 0;
  updateTabIndex(int? newValue) {
    tabIndex = newValue;
    update();
  }

  ///-------MAP------

  final Completer<GoogleMapController> _controller = Completer();

  LatLng? center;
  updateCenter(LatLng? newValue) {
    center = newValue;
    update();
  }

  final Set<Marker> markers = {};

  final MapType currentMapType = MapType.normal;

  Future<void> onAddMarkerButtonPressed(
      BuildContext context, String name) async {
    markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(center.toString()),
        position: center!,
        infoWindow: InfoWindow(
          title: name,
          // snippet: '...',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/mapLocator.png')));
    update();
  }

  void onCameraMove(CameraPosition position) {
    center = position.target;
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
}
