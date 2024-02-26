import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';

import '../../controller/read_story_controller.dart';
import '../../utils/custom_app_bar.dart';

class ReadStory extends StatelessWidget {
  final String name;
  final bool isListening;
  const ReadStory({super.key, required this.name, required this.isListening});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Get.put(ReadStoryController());
    return Scaffold(
      appBar: CustomAppBar(
        title: name,
        actions: [
          IconButton(
            icon: isListening
                ? Icon(
                    Icons.headphones_rounded,
                    color: AppColors.black,
                  )
                : Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.black,
                  ),
            onPressed: null,
          )
        ],
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
                    isListening
                        ? Container(
                            width: width,
                            height: height * 0.07,
                            color: AppColors.black.withOpacity(0.1),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: controller.isPlaying
                                      ? Icon(
                                          Icons.pause_rounded,
                                          color: AppColors.black,
                                        )
                                      : controller.isWaiting
                                          ? Icon(
                                              Icons.mic_rounded,
                                              color: AppColors.red,
                                            )
                                          : Icon(
                                              Icons.play_arrow_rounded,
                                              color: AppColors.black,
                                            ),
                                  onPressed: () => controller.isPlaying
                                      ? controller.pause()
                                      : controller.isWaiting
                                          ? null
                                          : controller.speak(),
                                )
                              ],
                            ),
                          )
                        : Container(),
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
    );
  }
}
