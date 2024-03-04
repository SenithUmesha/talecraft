import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;
  bool isLoading = false;

  void showPassword(bool obscureText, int index) {
    if (index == 4) {
      passwordObscureText = !obscureText;
    } else {
      confirmPasswordObscureText = !obscureText;
    }
    update();
  }

  register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppWidgets.showSnackBar(AppStrings.error, AppStrings.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        AppWidgets.showSnackBar(
            AppStrings.error, AppStrings.accountAlreadyExists);
      } else {
        AppWidgets.showSnackBar(AppStrings.error, e.message.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
