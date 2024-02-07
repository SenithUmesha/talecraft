import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_strings.dart';

import '../utils/app_colors.dart';
import '../utils/app_widgets.dart';

class NavBarController extends GetxController with GetTickerProviderStateMixin {
  int bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.bookmark_rounded,
    Icons.search_rounded,
    Icons.person_rounded,
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void updateIndex(int index) {
    if (bottomNavIndex == 4 && index != 4) {
      showExitConfirmationDialog(index);
    } else {
      bottomNavIndex = index;
      update();
    }
  }

  showExitConfirmationDialog(int index) {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppWidgets.regularText(
            text: "Warning",
            size: 20.0,
            color: AppColors.black,
            weight: FontWeight.w600,
          ),
          content: AppWidgets.regularText(
            text:
                "Please save your progress before going back.\n\nAre you sure you want to leave?",
            size: 16.0,
            color: AppColors.black,
            weight: FontWeight.w400,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: AppWidgets.regularText(
                text: AppStrings.no,
                size: 16.0,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.black)),
              onPressed: () {
                bottomNavIndex = index;
                update();
                Get.back();
              },
              child: AppWidgets.regularText(
                text: AppStrings.yes,
                size: 16.0,
                color: AppColors.white,
                weight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }
}
