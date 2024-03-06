import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/authRepository/auth_repository.dart';
import '../repository/storyRepository/story_repository.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  final allStoriesScrollController = ScrollController();
  final recommendedScrollController = ScrollController();
  final continueScrollController = ScrollController();
  final publishedScrollController = ScrollController();
  List<Story> recommendedStoriesList = [];
  List<Story> continueStoriesList = [];
  List<Story> yourStoriesList = [];
  List<String> achievementIds = [];
  List<Story> allStories = [];
  final storyRepo = Get.put(StoryRepository());
  final authRepo = Get.put(AuthRepository());
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

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  void markAchievementDone(List<Story> stories) {
    for (Story story in stories) {
      if (achievementIds.contains(story.id) && story.achievementDone == null) {
        story.achievementDone = true;
      }
    }
  }

  getStories() async {
    setLoader(true);
    achievementIds = await authRepo.getAchievementCompletedStoryIds();
    allStories = await storyRepo.getAllStories();
    yourStoriesList = await storyRepo.getPublishedStories();
    continueStoriesList = await storyRepo.getReadingStories();
    markAchievementDone(recommendedStoriesList);
    markAchievementDone(allStories);
    markAchievementDone(continueStoriesList);
    markAchievementDone(yourStoriesList);
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
