import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/read_story_controller.dart';
import '../../controller/story_details_controller.dart';
import '../../utils/custom_app_bar.dart';

class ReadStory extends StatelessWidget {
  final String name;
  const ReadStory({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Get.put(ReadStoryController());
    return WillPopScope(
      onWillPop: () async {
        StoryDetailsController storyDetailsController =
            Get.find<StoryDetailsController>();
        storyDetailsController.onInit();

        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: name,
          actions: [
            IconButton(
              icon: Icon(
                Icons.menu_book_rounded,
                color: AppColors.black,
              ),
              onPressed: null,
            )
          ],
          onPressBack: () {
            StoryDetailsController storyDetailsController =
                Get.find<StoryDetailsController>();
            storyDetailsController.onInit();
            Get.back();
          },
        ),
        body: GetBuilder<ReadStoryController>(
            init: ReadStoryController(),
            builder: (controller) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: CupertinoScrollbar(
                          controller: controller.scrollController,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20, bottom: 20),
                            controller: controller.scrollController,
                            itemCount: controller.widgetList.length,
                            itemBuilder: (context, index) {
                              return controller.widgetList[index];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  ConfettiWidget(
                    confettiController: controller.confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: true,
                    emissionFrequency: 0.20,
                  )
                ],
              );
            }),
      ),
    );
  }
}
