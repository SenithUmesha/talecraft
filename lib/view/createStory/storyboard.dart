import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expand_view/expand_child_widget.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/storyboard_controller.dart';
import '../../model/Block.dart';
import '../../utils/app_icons.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class Storyboard extends StatefulWidget {
  const Storyboard({Key? key}) : super(key: key);

  @override
  _StoryboardState createState() => _StoryboardState();
}

class _StoryboardState extends State<Storyboard> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () =>
              Get.find<StoryboardController>().showExitConfirmationDialog(),
          child: Scaffold(
            appBar: CustomAppBar(
              title: AppStrings.newStory,
              cantGoBack: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.save_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () =>
                      Get.find<StoryboardController>().saveProgress(),
                ),
              ],
            ),
            body: GetBuilder<StoryboardController>(
                init: StoryboardController(),
                builder: (controller) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Draggable<GraphNodeFactory<Block>>(
                            data: GraphNodeFactory(
                              dataBuilder: () => Block(
                                  id: controller.maxId + 1,
                                  type: BlockType.story,
                                  text:
                                      "${AppStrings.addStory} ${controller.maxId + 1}"),
                            ),
                            child: Card(
                              elevation: 2,
                              child: controller.storyBlock(width),
                            ),
                            feedback: Card(
                              color: AppColors.white,
                              elevation: 6,
                              child: controller.storyBlock(width),
                            ),
                            onDragStarted: () =>
                                controller.onDraggedBlock(BlockType.story),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Draggable<GraphNodeFactory<Block>>(
                            data: GraphNodeFactory(
                              dataBuilder: () => Block(
                                  id: controller.maxId + 1,
                                  type: BlockType.choice,
                                  text:
                                      "${AppStrings.addChoice} ${controller.maxId + 1}"),
                            ),
                            child: Card(
                              elevation: 2,
                              child: controller.choiceBlock(width),
                            ),
                            feedback: Card(
                              color: AppColors.white,
                              elevation: 6,
                              child: controller.choiceBlock(width),
                            ),
                            onDragStarted: () =>
                                controller.onDraggedBlock(BlockType.choice),
                          ),
                        ],
                      ),
                      ExpandChildWidget(
                        arrowPadding: const EdgeInsets.only(bottom: 0),
                        expand: true,
                        arrowColor: AppColors.black,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.clearAllBlocks();
                                    AppWidgets.showToast(
                                        AppStrings.graphCleared);
                                  },
                                  child: Container(
                                    height: width * 0.12,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: AppColors.black, width: 2)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppIcons.clear,
                                          scale: 5,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        AppWidgets.regularText(
                                            text: AppStrings.clearGraph,
                                            size: 13.5,
                                            alignment: TextAlign.center,
                                            color: AppColors.black,
                                            weight: FontWeight.w400)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => controller.showContextDialog(),
                                  child: Container(
                                    height: width * 0.12,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: AppColors.black, width: 2)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppIcons.star,
                                          scale: 5,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        AppWidgets.regularText(
                                            text: AppStrings.getStartedWithAI,
                                            size: 13.5,
                                            alignment: TextAlign.center,
                                            color: AppColors.black,
                                            weight: FontWeight.w400)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: AppColors.grey,
                      ),
                      Expanded(
                        child: controller.isLoading
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColors.black,
                                  ),
                                ],
                              )
                            : StatefulBuilder(
                                builder: (context, setter) {
                                  return DraggableFlowGraphView<Block>(
                                    root: controller.root,
                                    direction: Axis.vertical,
                                    centerLayout: true,
                                    enableDelete: true,
                                    onConnect: (prevBlock, block) =>
                                        controller.increaseMaxId(),
                                    willConnect: (block) {
                                      log("Will Connect: ${block.data!.id} and ${controller.draggedBlock!.data!.id}");
                                      if (block.data?.type == BlockType.story) {
                                        return controller
                                                .draggedBlock!.data?.type ==
                                            BlockType.choice;
                                      } else if (block.data?.type ==
                                          BlockType.choice) {
                                        return controller
                                                    .draggedBlock!.data?.type ==
                                                BlockType.story &&
                                            block.nextList.isEmpty;
                                      }
                                      return false;
                                    },
                                    builder: (context, block) {
                                      return GestureDetector(
                                        onDoubleTap: () => controller
                                            .showEditBlockDialog(block.data!),
                                        onLongPress: () {
                                          setter(() {
                                            block.deleteSelf();
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.white,
                                                border: Border.all(
                                                    color: (block.data as Block)
                                                                .type ==
                                                            BlockType.story
                                                        ? AppColors.black
                                                        : AppColors.red,
                                                    width: 2)),
                                            padding: const EdgeInsets.all(12),
                                            child: AppWidgets.regularText(
                                                text: controller
                                                    .getFirstFewCharacters(
                                                        (block.data as Block)
                                                            .text),
                                                size: 14.0,
                                                alignment: TextAlign.center,
                                                color: AppColors.black,
                                                weight: FontWeight.w400,
                                                textOverFlow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 1)),
                                      );
                                    },
                                    onEdgeColor: (n1, n2) {
                                      if ((n1.data as Block).type ==
                                          BlockType.story) {
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
                  );
                }),
          ),
        ),
      ),
    );
  }
}
