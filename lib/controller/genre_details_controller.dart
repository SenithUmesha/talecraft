import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/storyRepository/story_repository.dart';

class GenreDetailsController extends GetxController {
  List<Story> allStories = [];
  bool isLoading = false;
  final scrollController = ScrollController();
  final storyRepo = Get.put(StoryRepository());

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  getStories() async {
    setLoader(true);
    allStories = await storyRepo.getStoriesByGenre(Get.arguments[0]);
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
