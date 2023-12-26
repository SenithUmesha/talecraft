import 'dart:async';

import 'package:get/get.dart';
import 'package:talecraft/view/navBar/nav_bar.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextPage();
  }

  void navigateToNextPage() {
    Timer(const Duration(seconds: 2), () {
      // Get.offAll(Login());
      Get.offAll(() => const NavBar());
    });
  }
}
