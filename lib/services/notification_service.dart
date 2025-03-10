import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static NotificationService notificationService = NotificationService._();

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isDenied) {
      await requestPermission();
    }
  }

  Future<void> initNotification() async {
    await requestPermission();

    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iOS = const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await plugin
        .initialize(initializationSettings)
        .then(
          (value) => log("Notification Init Done..."),
        )
        .onError(
          (error, _) => log("ERROR : $error"),
        );
  }

  Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      '101',
      'Chat App',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      // iOS: iOS,
    );

    await plugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    AndroidNotificationDetails androidDetail = const AndroidNotificationDetails(
      '101',
      'Message Chat App',
      priority: Priority.high,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetail,
    );

    await plugin.zonedSchedule(
      18,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showPeriodicNotification({
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Message Chat App',
      priority: Priority.high,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await plugin.periodicallyShow(
      101,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String url,
  }) async {
    http.Response res = await http.get(Uri.parse(url));

    Directory directory = await getApplicationSupportDirectory();

    File file = File("${directory.path}/img.png");

    file.writeAsBytesSync(res.bodyBytes);

    AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
      '101',
      'Message Chat App',
      priority: Priority.high,
      importance: Importance.max,
      largeIcon: FilePathAndroidBitmap(file.path),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(file.path),
      ),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetail,
    );

    await plugin.show(101, title, body, notificationDetails);
  }
}
