import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/reader.dart';
import '../repository/authRepository/auth_repository.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../view/navBar/nav_bar.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authRepo = Get.put(AuthRepository());
  final box = GetStorage();
  String code = "+91";
  bool passwordObscureText = true;
  bool isLoading = false;

  void showPassword() {
    passwordObscureText = !passwordObscureText;
    update();
  }

  login() async {
    setLoader(true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        Reader reader = await authRepo.fetchUser(emailController.text.trim());
        box.write('current_user', reader);
        Get.offAll(() => const NavBar());
      });
    } on FirebaseAuthException catch (e) {
      AppWidgets.showSnackBar(AppStrings.error, e.message.toString());
    }
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
