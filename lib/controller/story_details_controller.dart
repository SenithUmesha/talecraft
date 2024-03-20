import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../model/reader.dart';
import '../model/story.dart';
import '../repository/authRepository/auth_repository.dart';
import '../repository/storyRepository/story_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_widgets.dart';

class StoryDetailsController extends GetxController {
  bool isBookmarked = false;
  List<Story> storyList = [];
  List<Story> allStoryList = [];
  final storyRepo = Get.put(StoryRepository());
  final authRepo = Get.put(AuthRepository());
  bool isLoading = false;
  late Story story;
  List<String> achievementIds = [];
  GlobalKey read = GlobalKey();
  GlobalKey listen = GlobalKey();
  GlobalKey gesture = GlobalKey();
  final box = GetStorage();
  late TutorialCoachMark tutorialCoachMark;

  @override
  void onInit() {
    super.onInit();

    story = Get.arguments[0] as Story;
    String storyId = (Get.arguments[0] as Story).id!;

    getCurrentStory(storyId);
    getStories();
    getCurrentReader();
  }

  showTutorial(BuildContext context) {
    if (!box.hasData('hide_tutorials')) {
      box.write('hide_tutorials', true).then((value) {
        createTargets();
        tutorialCoachMark = TutorialCoachMark(
          targets: createTargets(),
        )..show(context: context);
      });
    }
  }

  List<TargetFocus> createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(keyTarget: read, color: AppColors.red, contents: [
        TargetContent(
          align: ContentAlign.top,
          padding: EdgeInsets.only(bottom: 100, left: 20),
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppWidgets.regularText(
                  text: "Read Story",
                  size: 20.0,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
                AppWidgets.regularText(
                  text: "Pick choices and read stories manually.",
                  size: 14.0,
                  color: AppColors.white,
                  weight: FontWeight.w400,
                ),
              ],
            );
          },
        ),
      ]),
    );

    targets.add(
      TargetFocus(keyTarget: listen, color: AppColors.green, contents: [
        TargetContent(
          align: ContentAlign.top,
          padding: EdgeInsets.only(bottom: 100, left: 20),
          builder: (context, controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppWidgets.regularText(
                  text: "Listen Story",
                  size: 20.0,
                  color: AppColors.white,
                  weight: FontWeight.w600,
                ),
                AppWidgets.regularText(
                  text:
                      "Listen to stories and pick choices by voice, from 1 to 10.",
                  size: 14.0,
                  color: AppColors.white,
                  weight: FontWeight.w400,
                ),
              ],
            );
          },
        ),
      ]),
    );

    targets.add(
        TargetFocus(keyTarget: gesture, color: AppColors.yellow, contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: EdgeInsets.only(bottom: 100, left: 20),
        builder: (context, controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppWidgets.regularText(
                text: "Gesture Story",
                size: 20.0,
                color: AppColors.white,
                weight: FontWeight.w600,
              ),
              AppWidgets.regularText(
                text:
                    "Listen to stories and pick choices by hand gestures, from 1 to 5.",
                size: 14.0,
                color: AppColors.white,
                weight: FontWeight.w400,
              ),
            ],
          );
        },
      ),
    ]));

    return targets;
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
