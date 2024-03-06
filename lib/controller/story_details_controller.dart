import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/reader.dart';
import '../model/story.dart';
import '../repository/authRepository/auth_repository.dart';
import '../repository/storyRepository/story_repository.dart';

class StoryDetailsController extends GetxController {
  bool isBookmarked = false;
  List<Story> storyList = [];
  List<Story> allStoryList = [];
  final storyRepo = Get.put(StoryRepository());
  final authRepo = Get.put(AuthRepository());
  bool isLoading = false;
  late Story story;
  List<String> achievementIds = [];

  @override
  void onInit() {
    super.onInit();

    story = Get.arguments[0] as Story;
    String storyId = (Get.arguments[0] as Story).id!;

    getCurrentStory(storyId);
    getStories();
    getCurrentReader();
  }

  Future<void> updateIsBookmarked() async {
    setLoader(true);
    isBookmarked = !(isBookmarked);
    await authRepo.addIdToBookmarkedStories(story);
    update();
    setLoader(false);
  }

  getCurrentReader() async {
    final user = FirebaseAuth.instance.currentUser;
    Reader reader = await authRepo.fetchUser(user!.email!);
    isBookmarked = reader.bookmarkedStories!.contains(Get.arguments[0].id);
    update();
  }

  getStories() async {
    update();
    storyList.clear();
    allStoryList.clear();
    setLoader(true);
    allStoryList = await storyRepo.getMoreStories(Get.arguments[0].authorId!);
    storyList.addAll(allStoryList);
    storyList.removeWhere((story) => story.id == Get.arguments[0].id);
    update();
    setLoader(false);
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getCurrentStory(String storyId) async {
    setLoader(true);
    achievementIds = await authRepo.getAchievementCompletedStoryIds();
    story = (await storyRepo.getCurrentStory(storyId))!;

    if (achievementIds.contains(story.id) && story.achievementDone == null) {
      story.achievementDone = true;
    }

    update();
    setLoader(false);
  }
}
