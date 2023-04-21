import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Nilinde/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();



  static Future init({bool initSchedule = false}) async {
    const iOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const android = AndroidInitializationSettings('launcher_notification');
    const macOS = MacOSInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: android, iOS:iOS, macOS: macOS,);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      print("detailsjjjjjjjjjjjjjjjjj:$details");
      //onNotifications.add(details.payload as String?);
    }
    await _notifications.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  static showNotification({String? title, String? body, String? payload}) async {
    final bigPicturePath = await Utils.downloadFile(
        "https://paytmblogcdn.paytm.com/wp-content/uploads/2021/07/SavingsAC_66_A-guide-to-Savings-account-benefits-types-advantages-_-disadvantages-and-more-380x220.png",
        "bigPicture");
    final largeIconPath = await Utils.downloadFile(
        "https://www.topsidefcu.org/sites/www.topsidefcu.org/files/images/Asset%201gas.png",
        "largeIcon");

     NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelShowBadge: true,
          "easyapproach", "easyapproach channel",
          "This is our channel",
          playSound: true,
          sound: const RawResourceAndroidNotificationSound("notification"),
          ticker: 'Ticker',
          icon:'launcher_notification',
          ledColor:Colors.orange,
          ledOnMs:3 ,
          ledOffMs:4,
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          styleInformation: BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              largeIcon: FilePathAndroidBitmap(largeIconPath),
              hideExpandedLargeIcon: false
          ),
        ),
        iOS: const IOSNotificationDetails(),
        macOS: const MacOSNotificationDetails(),
    );
    try{
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      _notifications.show(
          id, title, body, 
          notificationDetails,
          payload: payload
      );
    }catch (e){
      print("error:$e");
    }
  }
}
