import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class CouponsLogic extends GetxController {
  final state = CouponsState();

  FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot>? docsList;

  void getAllCoupons() async {
    QuerySnapshot data = await firebaseFirestoreInstance
        .collection('coupon')
        .where('isValid', isEqualTo: true)
        .get();

    docsList = data.docs;
    update();
  }
}
