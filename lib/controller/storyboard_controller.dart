import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_widgets.dart';

class StoryboardController extends GetxController {
  final List<Block> blocks = [];

  void addBlock(Block block) {
    blocks.add(block);
    update();
  }

  void showAddBlockDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AddBlockDialog(
        onStoryAdded: (text) {
          addBlock(Block(type: BlockType.Story, text: text));
          // Get.back();
        },
        onDecisionAdded: (choices) {
          addBlock(Block(type: BlockType.Decision, text: "", choices: choices));
          // Get.back();
        },
      ),
    );
  }

  void updateBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Block block = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, block);
    update();
  }
}

enum BlockType { Story, Decision }

class Block {
  final BlockType type;
  final String text;
  final List<String> choices;

  Block({required this.type, required this.text, this.choices = const []});

  @override
  String toString() {
    return type == BlockType.Story ? "$text" : "${choices.join(', ')}";
  }
}

class AddBlockDialog extends StatelessWidget {
  final Function(String) onStoryAdded;
  final Function(List<String>) onDecisionAdded;
  final TextEditingController textController = TextEditingController();
  final TextEditingController choicesController = TextEditingController();

  AddBlockDialog({required this.onStoryAdded, required this.onDecisionAdded});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: AppWidgets.regularText(
        text: "Add Block",
        size: 20.0,
        color: AppColors.black,
        weight: FontWeight.w600,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
              showDialog(
                context: context,
                builder: (context) => StoryInputDialog(
                  onTextEntered: onStoryAdded,
                ),
              );
            },
            child: Container(
              width: width * 0.6,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.black,
              ),
              child: Center(
                child: AppWidgets.regularText(
                  text: 'Add Story Block',
                  size: 16.0,
                  color: AppColors.white,
                  weight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Get.back();
              showDialog(
                context: context,
                builder: (context) => DecisionInputDialog(
                  onDecisionAdded: onDecisionAdded,
                ),
              );
            },
            child: Container(
              width: width * 0.6,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.black,
              ),
              child: Center(
                child: AppWidgets.regularText(
                  text: 'Add Decision Block',
                  size: 16.0,
                  color: AppColors.white,
                  weight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryInputDialog extends StatelessWidget {
  final Function(String) onTextEntered;
  final TextEditingController textController = TextEditingController();

  StoryInputDialog({required this.onTextEntered});
  static GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppWidgets.regularText(
        text: "Add Story Block",
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
                    borderSide: const BorderSide(color: AppColors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.black, width: 2)),
                hintText: "Story",
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
              onTextEntered(textController.text);
              Get.back();
            }
          },
          child: AppWidgets.regularText(
            text: 'Add',
            size: 16.0,
            color: AppColors.white,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class DecisionInputDialog extends StatelessWidget {
  final Function(List<String>) onDecisionAdded;
  final TextEditingController textController = TextEditingController();

  DecisionInputDialog({required this.onDecisionAdded});
  static GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppWidgets.regularText(
        text: "Add Decision Block",
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
                    borderSide: const BorderSide(color: AppColors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.black, width: 2)),
                hintText: 'Choices (comma-separated)',
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
              final choices =
                  textController.text.split(',').map((e) => e.trim()).toList();
              onDecisionAdded(choices);
              Get.back();
            }
          },
          child: AppWidgets.regularText(
            text: 'Add',
            size: 16.0,
            color: AppColors.white,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
