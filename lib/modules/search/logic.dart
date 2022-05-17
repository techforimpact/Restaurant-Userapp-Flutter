import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'state.dart';

class SearchLogic extends GetxController {
  final state = SearchState();

  // List<DocumentSnapshot> queryResultSet = [];
  List<DocumentSnapshot> queryResultForProductSet = [];
  List<DocumentSnapshot> queryResultForRestaurantSet = [];
  // List<DocumentSnapshot> tempSearchStore = [];
  List<DocumentSnapshot> tempSearchForProductStore = [];
  List<DocumentSnapshot> tempSearchForRestaurantStore = [];

  initiateSearch(value) {
    String? capitalizedValue;
    if (value.length == 0) {
      // queryResultSet = [];
      queryResultForProductSet = [];
      queryResultForRestaurantSet = [];
      // tempSearchStore = [];
      tempSearchForProductStore = [];
      tempSearchForRestaurantStore = [];
      update();
    } else {
      capitalizedValue =
          value.substring(0, 1).toUpperCase() + value.substring(1);
    }

    // if (Get.find<HomeLogic>().filterRadioValue != 0) {
    // if (queryResultSet.isEmpty && value.length == 1) {
    //   SearchProductService()
    //       .searchByName(
    //           value,
    //           Get.find<HomeLogic>().filterRadioValue == 1
    //               ? 'products'
    //               : Get.find<HomeLogic>().filterRadioValue == 2
    //                   ? 'restaurants'
    //                   : '')
    //       .then((QuerySnapshot docs) {
    //     for (int i = 0; i < docs.docs.length; ++i) {
    //       queryResultSet.add(docs.docs[i]);
    //       tempSearchStore.add(docs.docs[i]);
    //       update();
    //     }
    //   });
    // } else {
    //   tempSearchStore = [];
    //   queryResultSet.forEach((element) {
    //     if (element.get('name').startsWith(capitalizedValue)) {
    //       tempSearchStore.add(element);
    //       update();
    //     }
    //   });
    // }
    // } else {
    if (queryResultForRestaurantSet.isEmpty && value.length == 1) {
      SearchProductService()
          .searchByName(value, 'restaurants')
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultForRestaurantSet.add(docs.docs[i]);
          tempSearchForRestaurantStore.add(docs.docs[i]);
          update();
        }
      });
      SearchProductService()
          .searchByName(value, 'products')
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          // if (Get.find<HomeLogic>().filterRadioValue == 0) {
          queryResultForProductSet.add(docs.docs[i]);
          tempSearchForProductStore.add(docs.docs[i]);
          update();
          // } else {
          //   List cat = docs.docs[i]['category'];
          //   update();
          //   if (cat.contains(Get.find<HomeLogic>().filterString)) {
          //     queryResultForProductSet.add(docs.docs[i]);
          //     tempSearchForProductStore.add(docs.docs[i]);
          //     update();
          //   }
          // }
        }
      });
    } else {
      tempSearchForProductStore = [];
      tempSearchForRestaurantStore = [];
      for (var element in queryResultForRestaurantSet) {
        if (element.get('name').startsWith(capitalizedValue)) {
          tempSearchForRestaurantStore.add(element);
          update();
        }
      }
      // if (Get.find<HomeLogic>().filterRadioValue == 0) {
      for (var element in queryResultForProductSet) {
        if (element.get('name').startsWith(capitalizedValue)) {
          tempSearchForProductStore.add(element);
          update();
        }
      }
      // } else {
      //   for (var element in queryResultForProductSet) {
      //     if (element.get('name').startsWith(capitalizedValue)) {
      //       List cat = element.get('category');
      //       update();
      //       if (cat.contains(Get.find<HomeLogic>().filterString)) {
      //         tempSearchForProductStore.add(element);
      //         update();
      //       }
      //     }
      //   }
      // }
    }
    // }
  }
}

class SearchProductService {
  searchByName(String searchField, String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('search_key',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }
}
