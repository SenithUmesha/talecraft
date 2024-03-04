import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../view/login/login.dart';
import '../view/navBar/nav_bar.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextPage();
  }

  void navigateToNextPage() {
    Timer(const Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Get.offAll(() => Login());
        } else {
          Get.offAll(() => const NavBar());
        }
      });
    });
  }
}
