import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/storyRepository/story_repository.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  final recommendedScrollController = ScrollController();
  final continueScrollController = ScrollController();
  final publishedScrollController = ScrollController();
  List<Story> recommendedStoriesList = [];
  List<Story> continueStoriesList = [];
  List<Story> yourStoriesList = [];
  final storyRepo = Get.put(StoryRepository());
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

  getStories() async {
    setLoader(true);
    yourStoriesList = await storyRepo.getPublishedStories();
    continueStoriesList = await storyRepo.getReadingStories();
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
