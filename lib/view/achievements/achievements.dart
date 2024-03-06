import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/achievements_controller.dart';
import '../../model/story.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/no_items.dart';
import '../home/story_details.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.achievements),
      body: GetBuilder<AchievementsController>(
          init: AchievementsController(),
          builder: (controller) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 0, left: 15, right: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: controller.isLoading
                          ? LoadingOverlay()
                          : controller.allStories.isEmpty
                              ? NoItemsOverlay()
                              : CupertinoScrollbar(
                                  controller: controller.scrollController,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(bottom: 30),
                                    controller: controller.scrollController,
                                    itemCount: controller.allStories.length,
                                    itemBuilder: (context, index) {
                                      return getStoryItem(height, width,
                                          controller.allStories[index]);
                                    },
                                  ),
                                ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  static getStoryItem(double height, double width, Story story) {
    return GestureDetector(
      onTap: () {
        Get.to(() => StoryDetails(), arguments: [story]);
      },
      child: Container(
        height: height * 0.15,
        child: Row(
          children: [
            Container(
              height: width * 0.4,
              child: Stack(
                children: [
                  Lottie.asset(
                    AppImages.frame,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 27.8,
                    left: 27.8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: AppWidgets.imageWidget(
                        story.image,
                        AppImages.noStoryCover,
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: width * 0.18,
                      height: width * 0.18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppWidgets.regularText(
                    text: story.name,
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: height * 0.006,
                  ),
                  AppWidgets.regularText(
                      text: story.description,
                      size: 12.0,
                      color: AppColors.black,
                      weight: FontWeight.w400,
                      maxLines: 3,
                      textOverFlow: TextOverflow.ellipsis),
                  SizedBox(
                    height: height * 0.006,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
