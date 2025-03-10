import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _isDarkMode = false.obs;

  @override
  void onInit() {
    _isDarkMode.value = _box.read('isDarkMode') ?? false;
    super.onInit();
  }

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get theme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _box.write('isDarkMode', _isDarkMode.value);
  }
}
