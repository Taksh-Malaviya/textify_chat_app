import 'dart:developer';

import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/register_controller.dart';
import 'package:chat_app/screen/view/splash/extantion.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../../modal/user_model.dart';
import '../../../../routes/routes.dart';
import '../../../../services/firestore_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    LoginController controller = Get.put(LoginController());
    GlobalKey<FormState> formkey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/signin1.png",
                height: 100,
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Text(
            "Hello",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 64.sp,
            ),
          ),
          Text(
            "Sign in to your account",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.normal,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 41.h),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: email,
                          validator: (val) => val!.isEmpty
                              ? "Required email."
                              : (!val.isVerifyEmail())
                                  ? "Email is not valid"
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'E-mail',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: pass,
                          validator: (val) =>
                              val!.isEmpty ? "Required password." : null,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot your password?",
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: const Color(0xffbebebe),
                          ),
                        ),
                      ),
                      SizedBox(height: 33.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Sign in",
                            style: GoogleFonts.lato(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                await controller.Loginuser(
                                  email: email.text,
                                  password: pass.text,
                                );
                              } else {
                                log("error");
                              }
                            },
                            child: Container(
                              height: 34.h,
                              width: 56.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF97794),
                                    Color(0xff623AA2),
                                  ],
                                  stops: [0, 1],
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  "assets/images/signin2.png",
                  height: 172.h,
                ),
              ),
              Positioned(
                bottom: 80.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SignInButton(
                      Buttons.google,
                      text: "Sign in with Google",
                      onPressed: () async {
                        var userCredential =
                            await AuthService.authService.signInWithGoogle();

                        if (userCredential.user != null) {
                          String token =
                              await FirebaseMessaging.instance.getToken() ?? "";
                          log("=====================");
                          log("Token = $token");
                          log("=====================");
                          await FireStoreService.fireStoreService.addUsers(
                            user: UserModel(
                              id: "",
                              name: userCredential.user!.displayName ?? "",
                              email: userCredential.user!.email ?? "",
                              password: "",
                              token: token,
                            ),
                          );

                          Get.offNamed(Routes.home);
                        } else {
                          Get.snackbar("Error", "Something went wrong");
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: GoogleFonts.lato(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.register),
                          child: Text(
                            "Create",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
