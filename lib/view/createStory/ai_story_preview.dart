import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/ai_story_controller.dart';
import 'package:talecraft/view/createStory/story_publish.dart';

import '../../model/Block.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class AiStoryPreview extends StatelessWidget {
  final AiStoryController controller;
  const AiStoryPreview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        child: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.aiGenaratedStoryPreview,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.black,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.white,
            ),
            onPressed: () => Get.to(() => StoryPublish()),
          ),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Column(
              children: [
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setter) {
                      return DraggableFlowGraphView<Block>(
                        root: controller.root,
                        direction: Axis.vertical,
                        centerLayout: true,
                        enableDelete: false,
                        builder: (context, block) {
                          return GestureDetector(
                            onDoubleTap: () =>
                                controller.showBlockDialog(block.data!),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.white,
                                    border: Border.all(
                                        color: (block.data as Block).type ==
                                                BlockType.story
                                            ? AppColors.black
                                            : AppColors.red,
                                        width: 2)),
                                padding: const EdgeInsets.all(12),
                                child: AppWidgets.regularText(
                                    text: (block.data as Block).type ==
                                            BlockType.choice
                                        ? (block.data as Block).text
                                        : (block.data as Block)
                                            .shortDescription,
                                    size: 14.0,
                                    alignment: TextAlign.center,
                                    color: AppColors.black,
                                    weight: FontWeight.w400,
                                    textOverFlow: TextOverflow.ellipsis,
                                    maxLines: 1)),
                          );
                        },
                        onEdgeColor: (n1, n2) {
                          if ((n1.data as Block).type == BlockType.story) {
                            return AppColors.black;
                          } else {
                            return AppColors.red;
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
