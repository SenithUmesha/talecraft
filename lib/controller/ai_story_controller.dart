import 'dart:convert';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/viewModel/genarateStory/genarateStoryVM.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../view/createStory/ai_story_preview.dart';

class AiStoryController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController contextController = TextEditingController();
  late GraphNode<Block> root;
  bool isLoading = false;
  final TextEditingController shortDesciptionController =
      TextEditingController();
  final TextEditingController textController = TextEditingController();
  GenarateStoryVM genarateStoryVM = GenarateStoryVM();

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, shortDescription: '', text: ''),
      isRoot: true,
    );
  }

  loadProgress(GraphNode<Block> block, Map<String, dynamic> json) {
    block.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        loadProgress(nextNode, nextNodeJson as Map<String, dynamic>);
        block.addNext(nextNode);
      }
    }

    setLoader(false);
    Get.to(() => AiStoryPreview());
  }

  Future<void> genarate() async {
    if (formKey.currentState!.validate()) {
      setLoader(true);
      String response =
          await genarateStoryVM.getGenaratedStory(contextController.text);
      Map<String, dynamic> storyJson = jsonDecode(response);
      loadProgress(root, storyJson);
    }
  }

  void showBlockDialog(Block block) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    shortDesciptionController.text = block.shortDescription ?? "";
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
                    block.type == BlockType.choice
                        ? Container()
                        : TextFormField(
                            enabled: false,
                            controller: shortDesciptionController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: AppColors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.black, width: 2)),
                              hintText: AppStrings.shortDescription,
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
                              } else if (value.trim().length > 20) {
                                return AppStrings.enterShortDescription;
                              }
                              return null;
                            },
                          ),
                    block.type == BlockType.choice
                        ? Container()
                        : SizedBox(
                            height: 16,
                          ),
                    TextFormField(
                      enabled: false,
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
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppWidgets.regularText(
                    text: AppStrings.cancel,
                    size: 16.0,
                    color: AppColors.white,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ));
  }

  setLoader(bool value) {
    isLoading = value;
    update();
  }
}
