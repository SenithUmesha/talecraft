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

  @override
  void onInit() {
    super.onInit();
    getStories();
    getCurrentReader();
  }

  Future<void> updateIsBookmarked(Story story) async {
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
}
