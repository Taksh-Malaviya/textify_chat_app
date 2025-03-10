import 'package:chat_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';

final ThemeController themeController = Get.put(ThemeController());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => child!,
      child: Obx(() {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.theme,
          getPages: Routes.getPages,
        );
      }),
    );
  }
}
