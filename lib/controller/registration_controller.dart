import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
