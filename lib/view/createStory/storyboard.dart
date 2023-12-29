import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/storyboard_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
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
                onPressed: () {},
              ),
            ],
          ),
          body: GetBuilder<StoryboardController>(
              init: StoryboardController(),
              builder: (controller) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Column(
                    children: [
                      Expanded(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 30),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: height,
                                width: width,
                                child: ReorderableListView(
                                  children: [
                                    for (final block in controller.blocks)
                                      Padding(
                                        key: ValueKey(block),
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            title: Text(block.toString()),
                                          ),
                                        ),
                                      ),
                                  ],
                                  onReorder: (oldIndex, newIndex) {
                                    controller.updateBlocks(oldIndex, newIndex);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                );
              }),
        )));
  }
}
