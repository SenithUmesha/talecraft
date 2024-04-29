import 'dart:developer';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:talecraft/controller/storyboard_controller.dart';
import 'package:talecraft/model/story.dart';
import 'package:talecraft/repository/storyRepository/story_repository.dart';

import '../model/block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../view/navBar/nav_bar.dart';
import 'nav_bar_controller.dart';

class StoryPublishController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController storyNameController = TextEditingController();
  final TextEditingController readTimeController = TextEditingController();
  final TextEditingController storyDescriptionController =
      TextEditingController();
  String imagePath = "";
  bool isImagePathEmptyValidator = false;
  List<Block> lastBlockList = [];
  List<String> endingsList = [];
  String? selectedEnding;
  List<String> allGenres = [
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Fantasy",
    "Sci-Fi",
    "AI",
    "Thriller"
  ];
  List<String> selectedGenres = [];
  bool genreValidationError = false;
  final box = GetStorage();
  final storyRepo = Get.put(StoryRepository());
  bool isLoading = false;

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

  void validateGenres() {
    if (selectedGenres.isEmpty) {
      genreValidationError = true;
    } else {
      genreValidationError = false;
    }
    update();
  }

  Future<void> publish() async {
    validateImageUpload();
    validateGenres();
    if (formKey.currentState!.validate() &&
        !isImagePathEmptyValidator &&
        !genreValidationError) {
      setLoader(true);
      final user = FirebaseAuth.instance.currentUser;
      int position = endingsList.indexOf(selectedEnding!);
      Map<String, dynamic> graphJson = box.read('saved_graph');
      Story story = Story(
          id: "",
          name: storyNameController.text.trim(),
          authorId: user?.uid,
          authorName: user?.displayName,
          description: storyDescriptionController.text.trim(),
          readTime: "${readTimeController.text} min read",
          rating: 0.0,
          noOfRatings: 0,
          image: await storyRepo.uploadImage(imagePath),
          genres: selectedGenres,
          achievementEndingId: lastBlockList[position].id,
          storyJson: graphJson,
          createdAt: DateTime.now());

      await storyRepo.createStory(story);

      setLoader(false);

      AppWidgets.showToast(AppStrings.storyPublishedSuccessfully);
      Get.isRegistered<NavBarController>()
          ? Get.find<NavBarController>().updateIndex(0)
          : Get.put(NavBarController()).updateIndex(0);
      Get.offAll(() => const NavBar());
    }
  }

  Widget buildChoiceChip(String label) {
    return ChoiceChip(
      label: AppWidgets.regularText(
        text: label,
        size: 12.0,
        color: AppColors.black,
        weight: FontWeight.w400,
      ),
      selected: selectedGenres.contains(label),
      onSelected: (selected) {
        if (selected) {
          selectedGenres.add(label);
        } else {
          selectedGenres.remove(label);
        }
        update();
      },
    );
  }

  bool getLastBlocks(GraphNode<Block> block) {
    if (block.nextList.isEmpty) {
      lastBlockList.add(block.data!);
      endingsList.add(getFirstFewCharacters(block.data!.text, block.data!.id));
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

  String getFirstFewCharacters(String text, int id) {
    return text.length > 30
        ? "${text.substring(0, 30)}... - ${id.toString().substring(12, 16)}"
        : "$text - $id";
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
                if (await getCamaraPermission()) {
                  takePhoto();
                  Get.back();
                } else {
                  Get.back();
                  AppWidgets.showSnackBar(
                      AppStrings.error, AppStrings.permissionNotGranted);
                }
              }),
          BottomSheetAction(
              title: AppWidgets.regularText(
                text: AppStrings.chooseFromGallery,
                size: 16,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
              onPressed: (context) async {
                if (await getStoragePermission()) {
                  pickImageFromGallery();
                  Get.back();
                } else {
                  Get.back();
                  AppWidgets.showSnackBar(
                      AppStrings.error, AppStrings.permissionNotGranted);
                }
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

  Future<bool> getCamaraPermission() async {
    var permission = await Permission.camera.status;

    if (permission == PermissionStatus.denied) {
      permission = await Permission.camera.request();

      if (permission == PermissionStatus.denied) {
        log('Camara permission is denied');
        return false;
      } else {
        log('Camara permission is denied');
        return true;
      }
    } else {
      log('Camara permission is denied');
      return true;
    }
  }

  Future<bool> getStoragePermission() async {
    var permission = await Permission.storage.status;

    if (permission == PermissionStatus.denied) {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permission = await Permission.storage.request();
        } else {
          permission = await Permission.photos.request();
        }
      } else {
        permission = await Permission.storage.request();
      }

      if (permission == PermissionStatus.denied) {
        log('storage permission is denied');
        return false;
      } else if (permission == PermissionStatus.granted) {
        log('storage permission is denied');
        return true;
      } else {
        log('storage permission is denied');
        return false;
      }
    } else {
      log('storage permission is denied');
      return true;
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
      AppWidgets.showSnackBar(
          AppStrings.error, AppStrings.errorWhenTakingPicture);
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
      AppWidgets.showSnackBar(
          AppStrings.error, AppStrings.errorWhenPickingFile);
    }
  }

  updateEndings(String? value) {
    selectedEnding = value;
    update();
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
