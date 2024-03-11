import 'dart:developer';

import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expand_view/expand_child_widget.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/storyboard_controller.dart';
import '../../model/block.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';

class Storyboard extends StatefulWidget {
  const Storyboard({Key? key}) : super(key: key);

  @override
  _StoryboardState createState() => _StoryboardState();
}

class _StoryboardState extends State<Storyboard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () =>
          Get.find<StoryboardController>().showExitConfirmationDialog(),
      child: Scaffold(
        backgroundColor: AppColors.black.withOpacity(0.03),
        appBar: CustomAppBar(
          title: AppStrings.newStory,
          cantGoBack: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.help_outline_rounded,
                color: Colors.black,
              ),
              onPressed: () =>
                  Get.find<StoryboardController>().showInfoDialog(),
            ),
            IconButton(
              icon: const Icon(
                Icons.save_rounded,
                color: Colors.black,
              ),
              onPressed: () => Get.find<StoryboardController>().saveProgress(),
            ),
          ],
        ),
        body: GetBuilder<StoryboardController>(
            init: StoryboardController(),
            builder: (controller) {
              return Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Draggable<GraphNodeFactory<Block>>(
                        data: GraphNodeFactory(
                          dataBuilder: () => Block(
                              id: controller.id,
                              type: BlockType.story,
                              text: AppStrings.addStory),
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
                        width: 2,
                      ),
                      Draggable<GraphNodeFactory<Block>>(
                        data: GraphNodeFactory(
                          dataBuilder: () => Block(
                              id: controller.id,
                              type: BlockType.choice,
                              text: AppStrings.addChoice),
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
                        Container(
                          width: width,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
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
                                            color: AppColors.grey, width: 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.clear_rounded),
                                        SizedBox(
                                          width: 12,
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
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () => controller.showContextDialog(),
                                child: Container(
                                  height: width * 0.12,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.white,
                                      border: Border.all(
                                          color: AppColors.grey, width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 12,
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
                        ? LoadingOverlay()
                        : StatefulBuilder(
                            builder: (context, setter) {
                              return DraggableFlowGraphView<Block>(
                                padding: EdgeInsets.zero,
                                root: controller.root,
                                direction: Axis.vertical,
                                centerLayout: true,
                                enableDelete: true,
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
                                    onTap: null,
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
                                                color: AppColors.grey,
                                                width: 1)),
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (block.data as Block).type ==
                                                    BlockType.story
                                                ? Icon(
                                                    Icons.menu_book_rounded,
                                                    color: AppColors.black,
                                                  )
                                                : Icon(
                                                    Icons.playlist_add_check,
                                                    color: AppColors.red,
                                                  ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            AppWidgets.regularText(
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
                                                maxLines: 1)
                                          ],
                                        )),
                                  );
                                },
                                onEdgeColor: (n1, n2) {
                                  return AppColors.grey.withOpacity(0.5);
                                },
                              );
                            },
                          ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
