import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:talecraft/controller/storyboard_controller.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../view/navBar/nav_bar.dart';

class StoryPublishController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController storyNameController = TextEditingController();
  final TextEditingController storyDescriptionController =
      TextEditingController();
  String imagePath = "";
  bool isImagePathEmptyValidator = false;
  List<Block> lastBlockList = [];
  List<String> endingsList = [];
  String? selectedEnding;

  @override
  void onInit() {
    super.onInit();

    lastBlockList.clear();
    endingsList.clear();
    getLastBlocks(Get.find<StoryboardController>().root);
  }

  void validateImageUpload() {
    if (imagePath.isEmpty) {
      isImagePathEmptyValidator = true;
    } else {
      isImagePathEmptyValidator = false;
    }
    update();
  }

  void publish() {
    validateImageUpload();
    if (formKey.currentState!.validate() && !isImagePathEmptyValidator) {
      AppWidgets.showToast(AppStrings.storyPublishedSuccessfully);
      Get.offAll(() => const NavBar());
    }
  }

  bool getLastBlocks(GraphNode<Block> block) {
    if (block.nextList.isEmpty) {
      lastBlockList.add(block.data!);
      endingsList.add(getFirstFewCharacters(block.data!.text));
      return block.data!.type == BlockType.story;
    } else {
      for (var branch in block.nextList) {
        if (!getLastBlocks(branch as GraphNode<Block>)) {
          return false;
        }
      }
      return true;
    }
  }

  String getFirstFewCharacters(String input) {
    return input.length > 10 ? input.substring(0, 10) : input;
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
              onPressed: (context) async {
                if (await Permission.camera.isGranted) {
                  takePhoto();
                } else {
                  final hasFilePermission = await requestPermission();
                  if (hasFilePermission) {
                    takePhoto();
                  } else {
                    AppWidgets.showSnackBar(AppStrings.permissionNotGranted);
                  }
                }
                Get.back();
              }),
          BottomSheetAction(
              title: AppWidgets.regularText(
                text: AppStrings.chooseFromGallery,
                size: 16,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
              onPressed: (context) async {
                if (await Permission.photos.isGranted) {
                  pickImageFromGallery();
                } else {
                  final hasFilePermission = await requestPermission();
                  if (hasFilePermission) {
                    pickImageFromGallery();
                  } else {
                    AppWidgets.showSnackBar(AppStrings.permissionNotGranted);
                  }
                }
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

  Future<bool> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.storage] == PermissionStatus.granted) {
      return true;
    } else if (statuses[Permission.camera] ==
            PermissionStatus.permanentlyDenied ||
        statuses[Permission.storage] == PermissionStatus.permanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
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
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String newPath = path.join(dir, 'story_cover_$timestamp.jpg');
        File(image.path).renameSync(newPath);

        imagePath = newPath;
        isImagePathEmptyValidator = false;
        imageCache.clear();
        imageCache.clearLiveImages();
        update();
      }
    } catch (e) {
      AppWidgets.showSnackBar(AppStrings.errorWhenTakingPicture);
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
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String newPath = path.join(dir, 'story_cover_$timestamp.jpg');
        File(image.path).renameSync(newPath);

        imagePath = newPath;
        isImagePathEmptyValidator = false;
        imageCache.clear();
        imageCache.clearLiveImages();
        update();
      }
    } catch (e) {
      AppWidgets.showSnackBar(AppStrings.errorWhenPickingFile);
    }
  }

  updateEndings(String? value) {
    selectedEnding = value;
    update();
  }
}
