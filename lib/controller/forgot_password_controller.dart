import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/repository/authRepository/auth_repository.dart';

import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  final authRepo = Get.put(AuthRepository());

  forgotPassword() async {
    setLoader(true);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailController.text.trim(),
      )
          .then((value) async {
        Get.back();
        AppWidgets.showSnackBar(
            AppStrings.success, AppStrings.checkEmailForPasswordChangeLink);
      });
    } on FirebaseAuthException catch (e) {
      AppWidgets.showSnackBar(AppStrings.error, e.message.toString());
    } catch (e) {
      print(e);
    }
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
