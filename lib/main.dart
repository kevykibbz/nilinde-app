import 'dart:async';
import 'package:Nilinde/config/config.dart';
import 'package:Nilinde/config/themes.dart';
import 'package:Nilinde/pages/firebase/firebaseauth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Nilinde/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Nilinde/no%20internet/no_internet.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Nilinde/pages/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Nilinde/Notifications/openedNotification.dart';
import 'package:Nilinde/services/notificationService.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepository()));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    runApp(MyApp(
      appTheme: AppTheme(),
      appName: MyConfig.appName,
    ));
  });
}

Future<void> backgroundHandler(RemoteMessage message) async {
  final routeName = message.data["route"];
  Get.toNamed(routeName);
  if (routeName != null) {
    Get.toNamed(routeName);
  }
}

class MyApp extends StatefulWidget {
  final String appName;
  final AppTheme appTheme;
  const MyApp({super.key, required this.appName, required this.appTheme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late StreamSubscription subscription;
  var isDeviceConnected = false;

  final themedata = GetStorage();

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen((onClickedNotification));
  }

  void onClickedNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const OpenedNotificationPage()));
  }

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        Get.to(() => const NoConnection());
      } else {
        Get.back();
      }
    });
  }

  @override
  initState() {
    NotificationApi.init();
    getConnectivity();
    listenNotifications();
    super.initState();

    ///give you message when user taps in terminated state
    _firebaseMessaging.getInitialMessage().then((message) async {
      final routeName = message?.data["route"];
      if (routeName != null) {
        Get.toNamed(routeName);
      }
    });

    //foreground
    FirebaseMessaging.onMessage.listen((message) {
      int badgeCount = int.tryParse(message.data['badge'] ?? '0') ?? 0;
      if (badgeCount > 0) {
        SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
            label: MyConfig.appName,
            primaryColor: Theme.of(context).primaryColor.value,
          ),
        );
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).colorScheme.secondary),
        );
        _setNotificationBadge(badgeCount);
      }
      NotificationApi.showNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          payload: "sarah.abs");
    });

    //background and not terminated and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeName = message.data["route"];
      if (routeName != null) {
        Get.toNamed(routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themedata.read("darkmode") ?? false;
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseMessaging.getToken().then((token) {
      //print("tokennnnnnnnnn:$token");
    });
    return GetMaterialApp(
      title: widget.appName,
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? widget.appTheme.dark : widget.appTheme.light,
      darkTheme: widget.appTheme.dark,
      themeMode: ThemeMode.light,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 800),
      home: SplashScreen(title: widget.appName),
    );
  }

  _setNotificationBadge(int badgeCount) async {
    if (badgeCount > 0) {
      await FlutterAppBadger.updateBadgeCount(badgeCount);
    } else {
      await FlutterAppBadger.removeBadge();
    }
  }
}
