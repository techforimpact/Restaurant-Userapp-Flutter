import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class BookNowLogic  extends GetxController{

  ///--------category list filter
  bool isAC=false;
  bool isTV=false;
  bool isWifi=false;
  bool isplay= false;

  void setIsAC(bool ac){
    isAC=ac;
  }

  void setIsTV(bool tv){
    isTV=tv;
  }
  void setIsWifi(bool wifi){
    isWifi=wifi;
  }
  void setIsPlay(bool play){
    isplay=play;
  }
 

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>  getRestaurentList() async{
    QuerySnapshot<Map<String, dynamic>> queryRef;
  queryRef=  await FirebaseFirestore.instance.collection('restaurants').where('isAC',isEqualTo: isAC? isAC:null ).where('isWifi',isEqualTo: isWifi ?isWifi :null ).where('isTV',isEqualTo: isTV? isTV:null ).where('isplay',isEqualTo: isplay?isplay:null ).where('isActive',isEqualTo: true )
    .get();
    return queryRef.docs;
  }
}