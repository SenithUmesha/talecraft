import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  List<String> completedStoryIds = [];
  List<List<String>> recommendedStoriesGenreList = [];
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
  final box = GetStorage();

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
    completedStoryIds = await authRepo.getCompletedStoryIds();

    if (completedStoryIds.isNotEmpty &&
        !box.hasData('recommendedStoriesList')) {
      recommendedStoriesGenreList = await storyRepo.getCompletedStoriesGenres();
      recommendedStoriesList = await storyRepo
          .getStoriesByGenresAndExcludeCompleted(
              getMostCommonGenres(recommendedStoriesGenreList),
              completedStoryIds)
          .then((value) {
        recommendedStoriesList.isNotEmpty
            ? box.write(
                'recommendedStoriesList',
                recommendedStoriesList
                    .map((story) => story.toBoxJson())
                    .toList())
            : null;

        return value;
      });
    } else {
      if (box.hasData('recommendedStoriesList')) {
        recommendedStoriesList =
            (box.read<List<Map<String, dynamic>>>('recommendedStoriesList') ??
                    [])
                .map((json) => Story.fromJson(json))
                .toList();
      }
    }

    markAchievementDone(allStories);
    markAchievementDone(continueStoriesList);
    markAchievementDone(yourStoriesList);
    markAchievementDone(recommendedStoriesList);
    update();
    setLoader(false);
  }

  List<String> getMostCommonGenres(List<List<String>> genreLists) {
    List<String> allGenres = genreLists.expand((list) => list).toList();

    Map<String, int> genreCounts = {};
    for (String genre in allGenres) {
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }

    int maxCount = 0;
    List<String> mostCommonGenres = [];
    genreCounts.forEach((genre, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonGenres = [genre];
      } else if (count == maxCount) {
        mostCommonGenres.add(genre);
      }
    });

    return mostCommonGenres;
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
