
import 'package:book_a_table/controllers/local_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/color.dart';
import '../../utils/constants.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${event.messageId}');
//   listenFcm(event);
// }

final getStorage = GetStorage();

class NotificationLogic extends GetxController {
  bool locationSubscribed = getStorage.read(locationKey) ?? true;
  bool favouriteSubscribed = getStorage.read(favouriteKey) ?? true;
  double lowerValue = getStorage.read(KMKey) ?? 0;
  double upperValue = 2;

  late FlutterLocalNotificationsPlugin fltrNotification;

/*
  void initilizeNotification(){

  var androidInitilize =  AndroidInitializationSettings('logo');

  var iOSinitilize =  IOSInitializationSettings();

  var initilizationsSettings =  InitializationSettings(
      android: androidInitilize, iOS: iOSinitilize);

  fltrNotification =  FlutterLocalNotificationsPlugin();

  fltrNotification.initialize(initilizationsSettings,onSelectNotification: onLocalNotificationSelected);

  Firebase.initializeApp().then((fbr) {

    _messaging.getToken().then((token) async {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance.subscribeToTopic('HAMZA').then((value) => null);



      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        /// call when app is in BG
        await Firebase.initializeApp();

        /// will call when user click on notification created by OS it self or using FCM when app was in BG
        FirebaseMessaging.onMessageOpenedApp.listen((event) {
          onFCMNotificationSelected(event.data.toString());
          // openApp();
        });

        /// generate notification your self
        FirebaseMessaging.onMessage.listen((event) {
          print('FirebaseMessaging.onMessage.listen');
          print("event.data ${event.data.toString()}");
          // TOASTS("Local Notification  ${event.data.toString()}");

          if (event.data.toString().contains("chatID")) {
            var currentRoute = Get.currentRoute;
            if (!currentRoute.contains("ChatRoom")) {
              _showLocalNotification(event);
            }
          } else {
            _showLocalNotification(event);
          }
        });
      }
    });
  });

}
*/

  void saveNotificationSettings() async {
    Get.dialog(const Center(
        child: CircularProgressIndicator(
      color: customThemeColor,
    )));

    if (locationSubscribed) {
      await LocalNotificationService.messaging.subscribeToTopic('Location');
      await LocalNotificationService.messaging
          .subscribeToTopic('${lowerValue.toInt()}');
      getStorage.write(locationKey, true);
      getStorage.write(KMKey, lowerValue);
    } else if (!locationSubscribed) {
      getStorage.write(locationKey, false);
      getStorage.write(KMKey, lowerValue);

      await LocalNotificationService.messaging.unsubscribeFromTopic('Location');
      await LocalNotificationService.messaging.unsubscribeFromTopic('0');
      await LocalNotificationService.messaging.unsubscribeFromTopic('1');
      await LocalNotificationService.messaging.unsubscribeFromTopic('2');
      await LocalNotificationService.messaging.unsubscribeFromTopic('3');
      await LocalNotificationService.messaging.unsubscribeFromTopic('4');
      await LocalNotificationService.messaging.unsubscribeFromTopic('5');
    }
    if (favouriteSubscribed) {
      getStorage.write(favouriteKey, true);

      var favData = await FirebaseFirestore.instance
          .collection('favourite')
          .where('clientId_uid', isEqualTo: getStorage.read('uid'))
          .get();
      for (int i = 0; i < favData.docs.length; i++) {
        LocalNotificationService.messaging
            .subscribeToTopic(favData.docs[i].get('restaurant_id').toString());
        FirebaseFirestore.instance
            .collection('favourite')
            .doc(favData.docs[i].id)
            .update({'isSubscribed': true});
      }
    } else if (!favouriteSubscribed) {
      getStorage.write(favouriteKey, false);
      var favData = await FirebaseFirestore.instance
          .collection('favourite')
          .where('clientId_uid', isEqualTo: getStorage.read('uid'))
          .get();
      for (int i = 0; i < favData.docs.length; i++) {
        LocalNotificationService.messaging.unsubscribeFromTopic(
            favData.docs[i].get('restaurant_id').toString());
        FirebaseFirestore.instance
            .collection('favourite')
            .doc(favData.docs[i].id)
            .update({'isSubscribed': false});
      }
    }
    if (Get.isDialogOpen != null) {
      Get.back();
    }

    locationSubscribed = getStorage.read(locationKey) ?? true;
    favouriteSubscribed = getStorage.read(favouriteKey) ?? true;
    lowerValue = getStorage.read(KMKey) ?? 0;
    update();
  }

/* Future _showLocalNotification(RemoteMessage event) async {
    listenFcm(event);
  }

  onFCMNotificationSelected(String payload) async {
    print("onFCMNotificationSelected");

    _openScreenForNotifications(payload);
  }

  _openScreenForNotifications(String payload) {
    payload = payload.replaceAll("{", "").replaceAll("}", "");
    var dataSp = payload.split(',');
    Map<String, String> mapData = Map();
    dataSp.forEach(
            (element) => mapData[element.split(':')[0]] = element.split(':')[1]);

    Map<String, String> lastmap = {};

    mapData.forEach((key, value) {
      print('"${key.trim()}"');
      print('"${value.trim()}"');

      lastmap['"${key.trim()}"'] = '"${value.trim()}"';
    });
    print("LAstMAp: $lastmap");

  }

  Future onLocalNotificationSelected(String payload) async {
    _openScreenForNotifications(payload);
  }
*/
}

/*
void listenFcm(RemoteMessage event) async {
  FlutterLocalNotificationsPlugin fltrNotification;

  var androidDetails =
  AndroidNotificationDetails("Channel ID", "Desi programmer",
      importance: Importance.max,
      // sound: RawResourceAndroidNotificationSound('alert'),
      sound: null,
      playSound: false,
      priority: Priority.max);
  var iSODetails = new IOSNotificationDetails();
  var generalNotificationDetails =   new NotificationDetails(android: androidDetails, iOS: iSODetails);
  var androidInitilize = new AndroidInitializationSettings('logo');
  var iOSinitilize = new IOSInitializationSettings();
  var initilizationsSettings = new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
  fltrNotification = new FlutterLocalNotificationsPlugin();
  fltrNotification.initialize(initilizationsSettings);


  await fltrNotification.show(
      0,/// we have to update this number on every notification
      event.notification.title,
      event.notification.body,
      generalNotificationDetails,
      payload: event.data.toString());
  // provider.increamentNotificationNumber();
}
*/
