import 'package:avatar_glow/avatar_glow.dart';
import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_images.dart';

import '../../controller/gesture_story_controller.dart';
import '../../controller/read_story_controller.dart';
import '../../controller/story_details_controller.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class GestureStory extends StatelessWidget {
  final String name;
  const GestureStory({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                Icons.back_hand_rounded,
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
        body: GetBuilder<GestureStoryController>(
            init: GestureStoryController(),
            builder: (controller) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            CupertinoScrollbar(
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
                            controller.isRecording
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        margin: EdgeInsets.only(
                                            bottom: 10, right: 10),
                                        height: 150,
                                        width: 100,
                                        child: CameraPreview(
                                            controller.cameraController)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      controller.isEnded
                          ? Container()
                          : Container(
                              width: width,
                              height: height * 0.07,
                              color: AppColors.black.withOpacity(0.1),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: controller.isyetToPlay
                                        ? Icon(
                                            Icons.play_arrow_rounded,
                                            color: AppColors.black,
                                          )
                                        : controller.isPlaying
                                            ? Icon(
                                                Icons.pause_rounded,
                                                color: AppColors.black,
                                              )
                                            : controller.isPaused
                                                ? Icon(
                                                    Icons.play_arrow_rounded,
                                                    color: AppColors.black,
                                                  )
                                                : controller.isRecording
                                                    ? AvatarGlow(
                                                        glowColor:
                                                            AppColors.red,
                                                        curve: Curves.ease,
                                                        child: Icon(
                                                          Icons
                                                              .fiber_manual_record_rounded,
                                                          color: AppColors.red,
                                                        ),
                                                      )
                                                    : controller.isSending
                                                        ? SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColors
                                                                  .black,
                                                            ),
                                                          )
                                                        : Container(),
                                    onPressed: () => controller.isyetToPlay
                                        ? controller.speak()
                                        : controller.isPlaying
                                            ? controller.pause()
                                            : controller.isPaused
                                                ? controller.speak()
                                                : null,
                                  ),
                                  Expanded(
                                      child: controller.isPlaying
                                          ? Lottie.asset(
                                              AppImages.playing,
                                              fit: BoxFit.fill,
                                            )
                                          : controller.isRecording
                                              ? AppWidgets.regularText(
                                                  text: "",
                                                  size: 15.0,
                                                  alignment: TextAlign.justify,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w500,
                                                  height: 2.0)
                                              : Container())
                                ],
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
