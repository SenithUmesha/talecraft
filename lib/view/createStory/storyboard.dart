import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/storyboard_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class Storyboard extends StatelessWidget {
  const Storyboard({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: AppColors.white,
        child: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.newStory,
            cantGoBack: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                onPressed: () {
                  Get.find<StoryboardController>().showAddBlockDialog();
                },
              ),
            ],
          ),
          body: GetBuilder<StoryboardController>(
              init: StoryboardController(),
              builder: (controller) {
                return Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 25),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: height,
                              width: width,
                              child: ReorderableListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 30),
                                scrollDirection: Axis.vertical,
                                children: [
                                  for (final block in controller.blocks)
                                    Padding(
                                      key: ValueKey(block),
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: block.type == BlockType.Story
                                              ? AppColors.grey.withOpacity(0.1)
                                              : AppColors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: block.type == BlockType.Story
                                            ? ListTile(
                                                title: AppWidgets.regularText(
                                                  text: block.toString(),
                                                  size: 16.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w400,
                                                ),
                                              )
                                            : ListTile(
                                                title: ReorderableListView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  children: [],
                                                  onReorder:
                                                      (oldIndex, newIndex) {},
                                                ),
                                              ),
                                      ),
                                    ),
                                ],
                                onReorder: (oldIndex, newIndex) {
                                  controller.updateBlocks(oldIndex, newIndex);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                );
              }),
        )));
  }
}
