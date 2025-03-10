import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class LoginController extends GetxController {
  Future<void> Loginuser({
    required String email,
    required String password,
  }) async {
    String msg = await AuthService.authService
        .loginUser(email: email, password: password);

    if (msg == "Success") {
      Get.snackbar("Success", "Login Successfully",
          backgroundColor: Colors.green);
      Get.offNamed(Routes.home);
    } else {
      Get.snackbar("Error", msg, backgroundColor: Colors.red);
    }
  }
}
