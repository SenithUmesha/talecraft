import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/splash_controller.dart';
import '../../utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetBuilder<SplashController>(
          init: SplashController(),
          builder: (controller) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.transparentAppIcon,
                    scale: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
