import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

import '../repository/storyRepository/story_repository.dart';

class SearchStoryController extends GetxController {
  List<Story> allStories = [];
  List<Story> searchList = [];
  bool isLoading = false;
  final scrollController = ScrollController();
  final storyRepo = Get.put(StoryRepository());
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  getStories() async {
    setLoader(true);
    allStories = await storyRepo.getAllStories();
    searchList = List.from(allStories);
    update();
    setLoader(false);
  }

  searchStories(String query) {
    String lowercasedQuery = query.toLowerCase();
    searchList = allStories
        .where((story) => story.name!.toLowerCase().contains(lowercasedQuery))
        .toList();
    update();
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
