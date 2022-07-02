import 'dart:developer';
import 'dart:math' hide log;

import 'package:book_a_table/controllers/general_controller.dart';
import 'package:book_a_table/controllers/index_notifier.dart';
import 'package:book_a_table/firebase_options.dart';
import 'package:book_a_table/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'controllers/local_notification.dart';
import 'modules/home/logic.dart';
import 'modules/sign_up/logic.dart';
import 'modules/splash/view.dart';
import 'route_generator.dart';
import 'utils/constants.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await GetStorage.init();
  showNotification(message);

  print('A bg message just showed up :  ${message.messageId}');
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var a = await Geolocator.getCurrentPosition();

  return await Geolocator.getCurrentPosition();
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

void showNotification(RemoteMessage message) {
  final getStorage = GetStorage();
  var isfavourite = getStorage.read<bool>(favouriteKey) ?? false;
  var locationSubscribed = getStorage.read<bool>(locationKey) ?? true;
  var restId = message.notification!.body!.split(':')[0].trim();
  // var messageBody= message.notification!.body!.split(':')[1].trim();

  double upperValue = getStorage.read(KMKey) * 1000;
  print('upper bound value $upperValue');
  if (isfavourite) {
    log(message.notification.toString());
    //!------when both on
    if (locationSubscribed) {
      //!---------send notification for distence
      var restLat = 0.0;
      var restLong = 0.0;
      //get the current position
      _determinePosition().then((postion) {
        var userLat = postion.altitude;
        var userLong = postion.longitude;
        FirebaseFirestore.instance
            .collection('restaurants')
            .where('id', isEqualTo: restId)
            .get()
            .then((value) {
          var listOfDocs = value.docs;

          for (var e in listOfDocs) {
            restLat = double.parse(e.data()['lat']);
            restLong = double.parse(e.data()['lng']);
            print('userLat: $userLat, userLong: $userLong');
            print('restLat: $restLat, restLong: $restLong');
            var distence =
                calculateDistance(restLat, restLong, userLat, userLong);
            print('distence is $distence');
            if (upperValue > distence) {
              LocalNotificationService.display(message);
            }
          }
        });
      });
      //!---------send notification for favourite
      if (message.notification != null) {
        FirebaseFirestore.instance
            .collection('wishList')
            .where('uid', isEqualTo: getStorage.read('uid'))
            .get()
            .then((value) {
          var listOfDocs = value.docs;
          log('foreground messages--after- ${listOfDocs.length}-->>');

          for (var e in listOfDocs) {
            var id = e.data()['w_id'] as String;
            id.trim();
            print('id: $id, id: $restId');
            if (id == restId) {
              LocalNotificationService.display(message);
            }
          }
        });
        log('foreground messages----->>');

        log(message.notification!.body.toString());
        log(message.notification!.title.toString());
      }
    } else {
      LocalNotificationService.display(message);
      //to send only one notification return here
      return;
    }
    //!------when only favourite on
    if (message.notification != null) {
      FirebaseFirestore.instance
          .collection('wishList')
          .where('uid', isEqualTo: getStorage.read('uid'))
          .get()
          .then((value) {
        var listOfDocs = value.docs;
        log('foreground messages--after- ${listOfDocs.length}-->>');

        for (var e in listOfDocs) {
          var id = e.data()['w_id'] as String;
          id.trim();
          print('id: $id, id: $restId');
          if (id == restId) {
            LocalNotificationService.display(message);
          }
        }
      });
      log('foreground messages----->>');

      log(message.notification!.body.toString());
      log(message.notification!.title.toString());
    }
  } else //!------when only distence on
  if (locationSubscribed) {
    var restLat = 0.0;
    var restLong = 0.0;
    //get the current position
    _determinePosition().then((postion) {
      var userLat = postion.altitude;
      var userLong = postion.longitude;
      FirebaseFirestore.instance
          .collection('restaurants')
          .where('id', isEqualTo: restId)
          .get()
          .then((value) {
        var listOfDocs = value.docs;

        for (var e in listOfDocs) {
          restLat = double.parse(e.data()['lat']);
          restLong = double.parse(e.data()['lng']);
          print('userLat: $userLat, userLong: $userLong');
          print('restLat: $restLat, restLong: $restLong');
          var distence =
              calculateDistance(restLat, restLong, userLat, userLong);
          print('distence is $distence');
          if (upperValue > distence) {
            LocalNotificationService.display(message);
          }
        }
      });
    });
  } else {
    LocalNotificationService.display(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await LocalNotificationService.messaging.subscribeToTopic('coupon');

  Get.put(IndexController());
  Get.put(GeneralController());
  Get.put(SignUpLogic());
  Get.put(HomeLogic());

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(const InitClass());
}

class InitClass extends StatefulWidget {
  const InitClass({Key? key}) : super(key: key);

  @override
  _InitClassState createState() => _InitClassState();
}

class _InitClassState extends State<InitClass> {
  final HomeLogic logic = Get.find<HomeLogic>();

  @override
  void initState() {
    Get.find<HomeLogic>().requestLocationPermission(context);
    logic.currentUser(context);

    logic.getCartCount();
    logic.getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      themeMode: ThemeMode.light,
      theme: lightTheme(),
      getPages: routes(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// on app closed
    FirebaseMessaging.instance.getInitialMessage();

    ///forground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('A bg message just showed up :  ${message.messageId}');
      try {
        showNotification(message);
      } catch (e) {}
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notifications--->>$message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}
