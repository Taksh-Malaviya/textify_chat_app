import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modal/user_model.dart';
import '../services/firestore_services.dart';

class RegisterController extends GetxController {
  Future<void> addNewuser({
    required String email,
    required String password,
    required String name,
  }) async {
    String msg = await AuthService.authService
        .registerUser(email: email, password: password);

    if (msg == "Success") {
      Get.back();
      await FireStoreService.fireStoreService.addUsers(
        user: UserModel(
          id: "",
          name: name,
          email: email,
          password: password,
          token: await FCMService.fcmService.getAccessToken(),
        ),
      );
    } else {
      Get.snackbar(
        "Error",
        msg,
        backgroundColor: Colors.red,
      );
    }
  }
}
