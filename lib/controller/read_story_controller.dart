import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class ReadStoryController extends GetxController {
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        pickChoice();
      }
    });
  }

  void pickChoice() {
    var width = MediaQuery.of(Get.context!).size.width;
    showAdaptiveActionSheet(
        context: Get.context!,
        title: AppWidgets.regularText(
          text: AppStrings.whatToDoNext,
          size: 18,
          color: AppColors.black,
          weight: FontWeight.w600,
        ),
        androidBorderRadius: 30,
        actions: <BottomSheetAction>[
          BottomSheetAction(
              title: Container(
                width: width,
                height: width * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.black,
                ),
                child: Center(
                  child: AppWidgets.regularText(
                    text: "Press on through the desert",
                    size: 16,
                    color: AppColors.white,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              onPressed: (context) {
                Get.back();
              }),
          BottomSheetAction(
              title: Container(
                width: width,
                height: width * 0.14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.black,
                ),
                child: Center(
                  child: AppWidgets.regularText(
                    text: "Confront the sorcerer immediately",
                    size: 16,
                    color: AppColors.white,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              onPressed: (context) {
                Get.back();
              }),
        ],
        cancelAction: CancelAction(
          title: Container(),
          onPressed: (context) {},
        ));
  }
}
