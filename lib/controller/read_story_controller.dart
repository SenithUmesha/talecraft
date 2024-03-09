import 'dart:async';
import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/saved_progress.dart';
import 'package:talecraft/model/story.dart';

import '../model/block.dart';
import '../repository/authRepository/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class ReadStoryController extends GetxController {
  bool isLoading = false;
  final scrollController = ScrollController();
  List<Widget> widgetList = [];
  late GraphNode<Block> root;
  late Story story;
  final confettiController = ConfettiController();
  List<GraphNode>? currentChoiceList;
  final authRepo = Get.put(AuthRepository());
  ProgressState status = ProgressState.DocDoesNotExist;
  SavedProgress? progress;

  @override
  void onInit() {
    super.onInit();
    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    story = Get.arguments[0];
    jsonToGraph(root, story.storyJson!);
    startStoryProcess();
  }

  void rateStory() {
    Timer(const Duration(seconds: 1), () {
      showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (context) => AppWidgets.showRatingDialog(story),
      );
    });
  }

  Future<void> startStoryProcess() async {
    status = await authRepo.checkSavedProgress(story.id!);
    progress = await authRepo.getSavedProgress(story.id!);
    addStoryBlock(root);
    status == ProgressState.DocDoesNotExist ? createSaveProgress() : null;
    log("Progress State: ${status.toString()}");
  }

  Future<void> createSaveProgress() async {
    await authRepo.createSavedProgress(SavedProgress(
        id: story.id,
        pickedChoices: [],
        isCompleted: false,
        achievementDone: false));
  }

  void jsonToGraph(GraphNode<Block> block, Map<String, dynamic> json) {
    block.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        jsonToGraph(nextNode, nextNodeJson as Map<String, dynamic>);
        block.addNext(nextNode);
      }
    }
  }

  Future<void> addStoryBlock(GraphNode<Block> block) async {
    var width = MediaQuery.of(Get.context!).size.width;
    widgetList.add(AppWidgets.regularText(
        text: block.data!.text,
        size: 17.0,
        alignment: TextAlign.justify,
        color: AppColors.black,
        weight: FontWeight.w500,
        height: 2.0));

    if (!block.nextList.isEmpty) {
      addChoiceBlock(block.nextList);
    } else {
      if (status != ProgressState.Completed) {
        await authRepo.addCompletedToSavedProgress(story.id!);
        rateStory();
      }

      widgetList.add(Container(
        width: width,
        margin: const EdgeInsets.only(top: 30, bottom: 15),
        child: Center(
          child: AppWidgets.regularText(
            text: AppStrings.theEnd,
            alignment: TextAlign.center,
            size: 14,
            color: AppColors.black,
            weight: FontWeight.w600,
          ),
        ),
      ));
    }

    update();
    scrollDown();
  }

  int hasMatchingChoices(List<GraphNode> nextList) {
    for (int i = 0; i < progress!.pickedChoices!.length; i++) {
      int pickedChoiceId = progress!.pickedChoices![i];
      for (int j = 0; j < nextList.length; j++) {
        if ((nextList[j].data as Block).id == pickedChoiceId) {
          return j;
        }
      }
    }
    return -1;
  }

  void addChoiceBlock(List<GraphNode> nextList) {
    var width = MediaQuery.of(Get.context!).size.width;
    int id = progress != null ? hasMatchingChoices(nextList) : -1;

    if (progress != null && id != -1) {
      widgetList.add(Container(
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.black.withOpacity(0.1),
        ),
        child: Center(
          child: AppWidgets.regularText(
            text: (nextList[id].data as Block).text,
            alignment: TextAlign.center,
            size: 16,
            color: AppColors.black,
            weight: FontWeight.w500,
          ),
        ),
      ));

      addStoryBlock(nextList[id].nextList[0] as GraphNode<Block>);
    } else {
      widgetList.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.black.withOpacity(0.1),
          ),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            itemCount: nextList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await authRepo.addChoiceIdToSavedProgress(
                      story.id!, (nextList[index].data as Block).id);
                  widgetList.removeLast();
                  widgetList.add(Container(
                    width: width,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.black.withOpacity(0.1),
                    ),
                    child: Center(
                      child: AppWidgets.regularText(
                        text: (nextList[index].data as Block).text,
                        alignment: TextAlign.center,
                        size: 16,
                        color: AppColors.black,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ));
                  if (nextList[index].nextList[0].nextList.isEmpty &&
                      (nextList[index].nextList[0].data as Block).id ==
                          story.achievementEndingId) {
                    confettiController.play();
                    await authRepo.addAchievementToSavedProgress(story.id!);

                    Timer(const Duration(seconds: 1), () {
                      confettiController.stop();
                      AppWidgets.showToast(AppStrings.secretEndingAchieved);
                    });
                  }
                  addStoryBlock(
                      nextList[index].nextList[0] as GraphNode<Block>);
                },
                child: Container(
                  width: width,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.black,
                  ),
                  child: Center(
                    child: AppWidgets.regularText(
                      text: (nextList[index].data as Block).text,
                      alignment: TextAlign.center,
                      size: 16,
                      color: AppColors.white,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients)
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
    });
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
