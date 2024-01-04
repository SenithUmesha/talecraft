import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/storyboard_controller.dart';
import '../../model/Block.dart';
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
    var height = MediaQuery.of(context).size.height;
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
                      Container(
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Draggable<GraphNodeFactory<Block>>(
                              data: GraphNodeFactory(
                                dataBuilder: () => Block(
                                  id: controller.maxId + 1,
                                  type: BlockType.story,
                                  shortDescription: AppStrings.addStory,
                                  text: '',
                                  oneOut: false,
                                  multiIn: false,
                                ),
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
                                  shortDescription: AppStrings.addChoice,
                                  text: '',
                                  oneOut: true,
                                  multiIn: false,
                                ),
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
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => controller.clearAllBlocks(),
                              child: Icon(
                                Icons.clear_all_rounded,
                                color: AppColors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help,
                            color: AppColors.grey,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          AppWidgets.regularText(
                            text: AppStrings.storyboardHelp,
                            size: 10.0,
                            alignment: TextAlign.center,
                            color: AppColors.grey,
                            weight: FontWeight.w400,
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: AppColors.grey,
                      ),
                      Expanded(
                        child: StatefulBuilder(
                          builder: (context, setter) {
                            return DraggableFlowGraphView<Block>(
                              root: controller.root,
                              direction: Axis.horizontal,
                              centerLayout: true,
                              enableDelete: true,
                              onConnect: (prevBlock, block) =>
                                  controller.increaseMaxId(),
                              willConnect: (block) {
                                log("Will Connect: ${block.data!.id} and ${controller.draggedBlock!.data!.id}");
                                if (!block.data!.oneOut &&
                                    !block.data!.multiIn) {
                                  // Story Block
                                  return controller.draggedBlock!.data?.type ==
                                      BlockType.choice;
                                } else if (block.data!.oneOut &&
                                    !block.data!.multiIn) {
                                  // Choice Block
                                  return controller.draggedBlock!.data?.type ==
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
                                              color:
                                                  (block.data as Block).type ==
                                                          BlockType.story
                                                      ? AppColors.black
                                                      : AppColors.red,
                                              width: 2)),
                                      padding: const EdgeInsets.all(12),
                                      child: AppWidgets.regularText(
                                          text: (block.data as Block)
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
                                if (n1.data?.oneOut == false &&
                                    n2.data?.multiIn == false) {
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
