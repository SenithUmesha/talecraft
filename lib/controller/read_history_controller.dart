import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/storyRepository/story_repository.dart';

class ReadHistoryController extends GetxController {
  List<Story> readList = [];
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
    readList = await storyRepo.getCompletedStories();
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
