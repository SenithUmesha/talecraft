import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String code = "+91";
  bool passwordObscureText = true;
  bool isLoading = false;

  void showPassword() {
    passwordObscureText = !passwordObscureText;
    update();
  }
}
