import 'dart:convert';
import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class StoryboardController extends GetxController {
  final TextEditingController shortDesciptionController =
      TextEditingController();
  final TextEditingController textController = TextEditingController();
  late GraphNode<Block> root;
  late GraphNode<Block>? draggedNode;
  int maxId = 0;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(
        id: 0,
        type: BlockType.story,
        shortDescription: AppStrings.addStory,
        text: '',
        oneOut: false,
        multiIn: false,
      ),
      isRoot: true,
    );
  }

  increaseMaxId() {
    maxId += 1;
    update();
  }

  decreaseMaxId() {
    maxId -= 1;
    update();
  }

  onDraggedBlock(BlockType type) {
    draggedNode = type == BlockType.choice
        ? GraphNode<Block>(
            data: Block(
            id: maxId + 1,
            type: BlockType.choice,
            shortDescription: 'Add Choice',
            text: '',
            oneOut: true,
            multiIn: false,
          ))
        : GraphNode<Block>(
            data: Block(
            id: maxId + 1,
            type: BlockType.story,
            shortDescription: 'Add Story',
            text: '',
            oneOut: false,
            multiIn: false,
          ));
    update();
  }

  Map<String, dynamic> graphToJson(GraphNode<Block> node) {
    Map<String, dynamic> json = node.data!.toJson();
    json['nextList'] = [];

    for (var nextNode in node.nextList) {
      json['nextList'].add(graphToJson(nextNode as GraphNode<Block>));
    }

    return json;
  }

  Map<String, dynamic> serializeGraph(GraphNode<Block> root) {
    return graphToJson(root);
  }

  void graphFromJson(GraphNode<Block> root, Map<String, dynamic> json) {
    root.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        graphFromJson(nextNode, nextNodeJson as Map<String, dynamic>);
        root.addNext(nextNode);
      }
    }
  }

  saveProgress() {
    Map<String, dynamic> graphJson =
        Get.find<StoryboardController>().serializeGraph(root);
    String jsonString = json.encode(graphJson);
    log(jsonString);

    box.write('saved_graph', graphJson);
    // Map<String, dynamic> savedGraph = box.read('saved_graph');

    Fluttertoast.showToast(
        msg: AppStrings.saveProgress,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.black,
        textColor: AppColors.white,
        fontSize: 16.0);
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
            Text('Story Block')
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
            Text('Choice Block')
          ],
        ),
      );

  void showEditBlockDialog(Block block) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    shortDesciptionController.text = block.shortDescription;
    textController.text = block.text;

    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: AppWidgets.regularText(
                text: block.type == BlockType.story
                    ? "Edit Story Block"
                    : "Edit Choice Block",
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
                        hintText: "Short Description",
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
                          return 'Please enter some text';
                        } else if (value.trim().length > 20) {
                          return 'Please enter a shorter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                        hintText:
                            block.type == BlockType.story ? "Story" : "Choice",
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
                          return 'Please enter some text';
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
                    text: 'Cancel',
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
                      block.updateText(
                        shortDesciptionController.text,
                        textController.text,
                      );
                      update();
                      Get.back();
                    }
                  },
                  child: AppWidgets.regularText(
                    text: 'Save',
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
            text: "Warning",
            size: 20.0,
            color: AppColors.black,
            weight: FontWeight.w600,
          ),
          content: AppWidgets.regularText(
            text:
                "Please save your progress before going back.\n\nAre you sure you want to leave?",
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
                text: 'No',
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
                text: 'Yes',
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
}
