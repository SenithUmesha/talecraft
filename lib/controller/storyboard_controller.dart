import 'dart:convert';
import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../view/createStory/story_publish.dart';
import '../viewModel/generateStory/generateStoryVM.dart';

class StoryboardController extends GetxController {
  final TextEditingController contextController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  late GraphNode<Block> root;
  late GraphNode<Block>? draggedBlock;
  final box = GetStorage();
  bool isLoading = false;
  GenerateStoryVM generateStoryVM = GenerateStoryVM();
  int id = 0;

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    loadProgress();
  }

  loadProgress() {
    if (box.hasData('saved_graph')) {
      Map<String, dynamic> graphJson = box.read('saved_graph');
      String jsonString = json.encode(graphJson);
      log(jsonString);

      jsonToGraph(root, graphJson);
      AppWidgets.showToast(AppStrings.loadProgress);
    }
  }

  clearAllBlocks() {
    root.clearAllNext();
    root.data?.text = AppStrings.addStory;
    box.erase();
    id = 0;
    update();
  }

  finalizeStory() {
    if (root.nextList.isEmpty || !hasAtLeastTwoChoiceBlocks(root)) {
      AppWidgets.showToast(AppStrings.atLeastTwoChoices);
    } else if (!checkLastBlocks(root)) {
      AppWidgets.showToast(AppStrings.endWithStoryBlock);
    } else if (!isValidChoiceStructure(root)) {
      AppWidgets.showToast(AppStrings.moreThanTwoChoices);
    } else {
      saveProgress();
      Get.to(() => StoryPublish());
    }
  }

  bool isValidChoiceStructure(GraphNode<Block> block) {
    int foundChoiceBlocks = 0;

    for (var nextBlock in block.nextList) {
      if (nextBlock.data?.type == BlockType.choice) {
        foundChoiceBlocks++;
        if (!isValidChoiceStructure(nextBlock as GraphNode<Block>)) {
          return false;
        }
      }
    }

    if (block.data?.type == BlockType.story && foundChoiceBlocks == 1) {
      return false;
    }

    for (var nextBlock in block.nextList) {
      if (!isValidChoiceStructure(nextBlock as GraphNode<Block>)) {
        return false;
      }
    }

    return foundChoiceBlocks != 1;
  }

  int countChoiceBlocksForTwoChoiceBlockCheck(GraphNode<Block> block) {
    int choiceBlockCount = 0;

    if (block.data?.type == BlockType.choice) {
      choiceBlockCount++;
    }
    for (var nextNode in block.nextList) {
      choiceBlockCount +=
          countChoiceBlocksForTwoChoiceBlockCheck(nextNode as GraphNode<Block>);
    }
    return choiceBlockCount;
  }

  bool hasAtLeastTwoChoiceBlocks(GraphNode<Block> block) {
    int totalChoiceBlocks = 0;
    for (var nextNode in block.nextList) {
      totalChoiceBlocks +=
          countChoiceBlocksForTwoChoiceBlockCheck(nextNode as GraphNode<Block>);
    }
    return totalChoiceBlocks >= 2;
  }

  bool checkLastBlocks(GraphNode<Block> block) {
    if (block.nextList.isEmpty) {
      return block.data!.type == BlockType.story;
    } else {
      for (var branch in block.nextList) {
        if (!checkLastBlocks(branch as GraphNode<Block>)) {
          return false;
        }
      }
      return true;
    }
  }

  onDraggedBlock(BlockType type) {
    id = Block.getId();

    draggedBlock = type == BlockType.choice
        ? GraphNode<Block>(
            data: Block(
                id: id, type: BlockType.choice, text: AppStrings.addChoice))
        : GraphNode<Block>(
            data: Block(id: id, type: BlockType.story, text: ''));
    update();
  }

  Map<String, dynamic> graphToJson(GraphNode<Block> block) {
    Map<String, dynamic> json = block.data!.toJson();
    json['nextList'] = [];

    for (var nextNode in block.nextList) {
      json['nextList'].add(graphToJson(nextNode as GraphNode<Block>));
    }

    return json;
  }

  Map<String, dynamic> serializeGraph(GraphNode<Block> block) {
    return graphToJson(block);
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

  saveProgress() {
    Map<String, dynamic> graphJson =
        Get.find<StoryboardController>().serializeGraph(root);
    String jsonString = json.encode(graphJson);
    log(jsonString);

    box.write('saved_graph', graphJson);
    AppWidgets.showToast(AppStrings.saveProgress);
  }

  Widget storyBlock(double width) => Container(
        width: width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book_rounded),
            SizedBox(
              width: 16,
            ),
            Text(AppStrings.storyBlock)
          ],
        ),
      );

  Widget choiceBlock(double width) => Container(
        width: width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.playlist_add_check),
            SizedBox(
              width: 16,
            ),
            Text(AppStrings.choiceBlock)
          ],
        ),
      );

  loadProgressAI(GraphNode<Block> block, Map<String, dynamic> json) {
    block.data = Block.fromJsonAssignId(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        loadProgressAI(nextNode, nextNodeJson as Map<String, dynamic>);
        block.addNext(nextNode);
      }
    }
  }

  Future<void> generate() async {
    setLoader(true);
    String response =
        await generateStoryVM.getGeneratedStory(contextController.text);
    Map<String, dynamic> storyJson = jsonDecode(response);
    loadProgressAI(root, storyJson);
    setLoader(false);
    AppWidgets.showToast(AppStrings.loadGeneratedStory);
  }

  void showContextDialog() {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();

    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: AppWidgets.regularText(
                text: AppStrings.aiGeneratedStory,
                size: 20.0,
                color: AppColors.black,
                weight: FontWeight.w600,
              ),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: contextController,
                      maxLines: 5,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.black, width: 1)),
                        hintText: AppStrings.provideContext,
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.addSomeText;
                        } else if (value.length > 150) {
                          return AppStrings.textShouldBeLessThan150;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: AppWidgets.regularText(
                    text: AppStrings.cancel,
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w400,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.black)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      clearAllBlocks();
                      Get.back();
                      generate();
                    }
                  },
                  child: AppWidgets.regularText(
                    text: AppStrings.generated,
                    size: 16.0,
                    color: AppColors.white,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ));
  }

  void showEditBlockDialog(Block block) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    textController.text = block.text;

    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: AppWidgets.regularText(
                text: block.type == BlockType.story
                    ? AppStrings.editStoryBlock
                    : AppStrings.editChoiceBlock,
                size: 20.0,
                color: AppColors.black,
                weight: FontWeight.w600,
              ),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: textController,
                      maxLines: null,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.black, width: 2)),
                        hintText: block.type == BlockType.story
                            ? AppStrings.story
                            : AppStrings.choice,
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.addSomeText;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppWidgets.regularText(
                    text: AppStrings.cancel,
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w400,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.black)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      block.updateText(textController.text);
                      update();
                      Get.back();
                    }
                  },
                  child: AppWidgets.regularText(
                    text: AppStrings.save,
                    size: 16.0,
                    color: AppColors.white,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ));
  }

  showExitConfirmationDialog() {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppWidgets.regularText(
            text: AppStrings.warning,
            size: 20.0,
            color: AppColors.black,
            weight: FontWeight.w600,
          ),
          content: AppWidgets.regularText(
            text: AppStrings.saveProgressBeforeLeaving,
            size: 16.0,
            color: AppColors.black,
            weight: FontWeight.w400,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: AppWidgets.regularText(
                text: AppStrings.no,
                size: 16.0,
                color: AppColors.black,
                weight: FontWeight.w400,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.black)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: AppWidgets.regularText(
                text: AppStrings.yes,
                size: 16.0,
                color: AppColors.white,
                weight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  String getFirstFewCharacters(String input) {
    return input.length > 30 ? "${input.substring(0, 30)}..." : input;
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
