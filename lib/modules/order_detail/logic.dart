import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class OrderDetailLogic extends GetxController {
  final state = OrderDetailState();

  DocumentSnapshot? currentRestaurant;
  getCurrentRestaurant(DocumentSnapshot? orderModel) async {
      print('data ${orderModel!.data()}');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('id', isEqualTo: orderModel.get('restaurant_id'))
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      currentRestaurant = querySnapshot.docs[0];
      update();
    }
  }
}
