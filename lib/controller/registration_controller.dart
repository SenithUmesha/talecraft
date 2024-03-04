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
    setLoader(true);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        User? user = value.user;
        await user?.updateDisplayName(nameController.text.trim());

        AppWidgets.showSnackBar(
            AppStrings.success, AppStrings.accountCreationSuccess);
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
