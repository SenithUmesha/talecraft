import 'package:get/get.dart';

import '../model/story.dart';
import '../repository/storyRepository/story_repository.dart';

class StoryDetailsController extends GetxController {
  bool isBookmarked = false;
  List<Story> storyList = [];
  List<Story> allStoryList = [];
  final storyRepo = Get.put(StoryRepository());
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  void updateIsBookmarked(Story story) {
    // story.isBookmarked = !(story.isBookmarked ?? false);
    // update();
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
