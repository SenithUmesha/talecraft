import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../utils/loading_overlay.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoadingOverlay loadingOverlay = LoadingOverlay();

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
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
