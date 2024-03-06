import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/authRepository/auth_repository.dart';
import '../repository/storyRepository/story_repository.dart';

class AchievementsController extends GetxController {
  List<Story> allStories = [];
  bool isLoading = false;
  final scrollController = ScrollController();
  final storyRepo = Get.put(StoryRepository());
  final authRepo = Get.put(AuthRepository());

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  getStories() async {
    setLoader(true);
    allStories = await storyRepo.getAchievementCompletedStories();
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
