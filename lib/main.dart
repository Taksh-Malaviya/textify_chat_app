import 'package:chat_app/my_app.dart';
import 'package:chat_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding();

  await GetStorage.init();
  ThemeController themeController = Get.put(ThemeController());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TimeZone Init
  tz.initializeTimeZones();

  // Notification Init
  await NotificationService.notificationService.initNotification();

  runApp(
    MyApp(),
  );
}
