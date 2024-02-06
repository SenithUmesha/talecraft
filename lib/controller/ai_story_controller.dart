import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class AiStoryController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController contextController = TextEditingController();
  late GraphNode<Block> root;
  bool loader = false;
  final TextEditingController shortDesciptionController =
      TextEditingController();
  final TextEditingController textController = TextEditingController();
  Map<String, dynamic> jsonStory = {
    "id": 0,
    "type": "BlockType.story",
    "shortDescription": "The Magical Forest",
    "text":
        "Once upon a time, in a magical forest, there lived a young fairy named Luna. She had the power to communicate with animals and control the elements. One day, while exploring the depths of the forest, Luna stumbled upon a mysterious glowing orb. She felt drawn to it and decided to investigate.",
    "nextList": [
      {
        "id": 1,
        "type": "BlockType.choice",
        "text": "Take the orb",
        "nextList": [
          {
            "id": 3,
            "type": "BlockType.story",
            "shortDescription": "The Dark Sorcerer",
            "text":
                "As Luna reached out to take the orb, a dark sorcerer appeared. He warned her that the orb was cursed and could bring great destruction if misused. He asked Luna to hand over the orb to him so that he could protect it from falling into the wrong hands.",
            "nextList": [
              {
                "id": 7,
                "type": "BlockType.choice",
                "text": "Trust the sorcerer",
                "nextList": [
                  {
                    "id": 9,
                    "type": "BlockType.story",
                    "shortDescription": "A New Journey Begins",
                    "text":
                        "Luna decided to trust the sorcerer and handed over the orb. As she did, a surge of power flowed through her body. The sorcerer explained that Luna was the chosen one, destined to use the orb's power for good. Together, they embarked on a new journey to protect the forest from evil creatures and restore balance.",
                    "nextList": []
                  }
                ]
              },
              {
                "id": 8,
                "type": "BlockType.choice",
                "text": "Refuse to give him the orb",
                "nextList": [
                  {
                    "id": 10,
                    "type": "BlockType.story",
                    "shortDescription": "Unleashing Chaos",
                    "text":
                        "Luna refused to give the orb to the sorcerer, believing that she could control its power and use it for good. However, as she held the orb, a surge of dark energy consumed her. The forest shook with chaos as Luna unintentionally unleashed its destructive power. Realizing her mistake, Luna desperately tried to contain the chaos she had unleashed.",
                    "nextList": []
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "id": 2,
        "type": "BlockType.choice",
        "text": "Leave the orb",
        "nextList": [
          {
            "id": 4,
            "type": "BlockType.story",
            "shortDescription": "A Tranquil Encounter",
            "text":
                "Luna decided to leave the orb untouched and continued her exploration of the forest. As she ventured deeper, she encountered a group of peaceful woodland creatures. They guided her to a hidden oasis, where she experienced a moment of tranquility and gained a deeper understanding of the forest's magic.",
            "nextList": [
              {
                "id": 11,
                "type": "BlockType.choice",
                "text": "Stay in the oasis",
                "nextList": [
                  {
                    "id": 12,
                    "type": "BlockType.story",
                    "shortDescription": "Finding Harmony",
                    "text":
                        "Luna chose to stay in the oasis, immersing herself in the forest's magic and living harmoniously with the woodland creatures. She became a guardian of the oasis, ensuring its protection and nurturing its magical energy.",
                    "nextList": []
                  }
                ]
              },
              {
                "id": 1,
                "type": "BlockType.choice",
                "text": "Continue exploring the forest",
                "nextList": [
                  {
                    "id": 2,
                    "type": "BlockType.story",
                    "shortDescription": "The Great Adventure",
                    "text":
                        "Luna bid farewell to the woodland creatures and continued her exploration of the magical forest. With each step, she discovered new wonders and encountered both friendly and mischievous creatures. Her journey in the forest became a great adventure, filled with thrilling encounters and valuable lessons.",
                    "nextList": []
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "id": 5,
        "type": "BlockType.choice",
        "text": "Use her powers",
        "nextList": [
          {
            "id": 6,
            "type": "BlockType.story",
            "shortDescription": "Harnessing the Elements",
            "text":
                "Luna tapped into her magical powers and summoned the elements to aid her. The forest came alive with a vibrant energy as the wind blew gently, flowers bloomed, and animals playfully gathered around her. Luna felt a deep connection to the forest and knew that she had the power to protect and nurture it.",
            "nextList": []
          }
        ]
      }
    ]
  };

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, shortDescription: '', text: ''),
      isRoot: true,
    );

    loadProgress(root, jsonStory);
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
}
