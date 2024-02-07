import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class StoryPublishController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController storyNameController = TextEditingController();
  final TextEditingController storyDescriptionController =
      TextEditingController();
  String imagePath = "";
  bool isImagePathEmpty = false;

  void validateImageUpload() {
    if (imagePath.isEmpty) {
      isImagePathEmpty = true;
    } else {
      isImagePathEmpty = false;
    }
    update();
  }

  void publish() {
    validateImageUpload();
    if (formKey.currentState!.validate()) {
      AppWidgets.showToast(AppStrings.storyPublishedSuccessfully);
    }
  }

  void uploadImage() {
    showAdaptiveActionSheet(
        context: Get.context!,
        title: AppWidgets.regularText(
          text: AppStrings.chooseimagesource,
          size: 18,
          color: AppColors.black,
          weight: FontWeight.w600,
        ),
        androidBorderRadius: 30,
        actions: <BottomSheetAction>[
          BottomSheetAction(
              title: AppWidgets.regularText(
                text: AppStrings.takePhoto,
                size: 16,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
              onPressed: (context) {
                takePhoto();
                Get.back();
              }),
          BottomSheetAction(
              title: AppWidgets.regularText(
                text: AppStrings.chooseFromGallery,
                size: 16,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
              onPressed: (context) {
                pickImageFromGallery();
                Get.back();
              }),
        ],
        cancelAction: CancelAction(
          title: AppWidgets.regularText(
            text: AppStrings.cancel,
            size: 16,
            color: AppColors.grey,
            weight: FontWeight.w400,
          ),
        ));
  }

  void takePhoto() async {
    try {
      XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 1000,
          maxWidth: 1000);

      if (image != null) {
        String dir = path.dirname(image.path);
        String newPath = path.join(dir, 'story_cover.jpg');
        File(image.path).renameSync(newPath);

        imagePath = newPath;
        isImagePathEmpty = false;
        imageCache.clear();
        imageCache.clearLiveImages();
        update();
      }
    } catch (e) {
      AppWidgets.showSnackBar(AppStrings.pleaseTryAgain);
    }
  }

  void pickImageFromGallery() async {
    try {
      XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 1000,
          maxWidth: 1000);
      if (image != null) {
        String dir = path.dirname(image.path);
        String newPath = path.join(dir, 'story_cover.jpg');
        File(image.path).renameSync(newPath);

        imagePath = newPath;
        isImagePathEmpty = false;
        imageCache.clear();
        imageCache.clearLiveImages();
        update();
      }
    } catch (e) {
      AppWidgets.showSnackBar(AppStrings.pleaseTryAgain);
    }
  }
}
