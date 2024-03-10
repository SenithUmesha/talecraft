import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/home_controller.dart';
import 'package:talecraft/controller/story_details_controller.dart';
import 'package:talecraft/model/story.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_strings.dart';
import 'package:talecraft/view/home/home.dart';
import 'package:talecraft/view/story/read_story.dart';

import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';
import '../story/gesture_story.dart';
import '../story/listen_story.dart';

class StoryDetails extends StatelessWidget {
  final refreshHome;
  StoryDetails({super.key, required this.refreshHome});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: refreshHome
          ? () async {
              HomeController homeController = Get.find<HomeController>();
              homeController.onInit();

              return true;
            }
          : () async {
              return true;
            },
      child: Scaffold(
        appBar: CustomAppBar(
          onPressBack: refreshHome
              ? () {
                  HomeController homeController = Get.find<HomeController>();
                  homeController.onInit();
                  Get.back();
                }
              : () => Get.back(),
        ),
        body: GetBuilder<StoryDetailsController>(
            init: StoryDetailsController(),
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: controller.isLoading
                          ? Padding(
                              padding: EdgeInsets.only(top: height * 0.4),
                              child: LoadingOverlay(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: height * 0.3,
                                        width: width * 0.45,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: AppWidgets.imageWidget(
                                                  controller.story.image,
                                                  AppImages.noStoryCover,
                                                ),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                height: height * 0.3,
                                                width: width * 0.45,
                                              ),
                                            ),
                                            controller.story.achievementDone !=
                                                        null &&
                                                    controller
                                                        .story.achievementDone!
                                                ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: AppColors.black
                                                              .withOpacity(0.6),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft:
                                                                      Radius
                                                                          .circular(
                                                                              8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Center(
                                                        child: Image.asset(
                                                          AppIcons.medal,
                                                          scale: 4,
                                                          color: AppColors.gold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      AppWidgets.regularText(
                                        text: controller.story.name,
                                        size: 18.0,
                                        color: AppColors.black,
                                        weight: FontWeight.w600,
                                      ),
                                      SizedBox(
                                        height: height * 0.001,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppWidgets.regularText(
                                            text: controller.story.authorName,
                                            size: 14.0,
                                            color: AppColors.black,
                                            weight: FontWeight.w400,
                                          ),
                                          SizedBox(
                                            width: width * 0.03,
                                          ),
                                          AppWidgets.regularText(
                                            text: controller.story.readTime,
                                            size: 14.0,
                                            color: AppColors.grey,
                                            weight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RatingBarIndicator(
                                            rating:
                                                controller.story.rating ?? 0.0,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 18,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          AppWidgets.regularText(
                                            text:
                                                "(${controller.story.noOfRatings})",
                                            size: 14.0,
                                            color: AppColors.grey,
                                            weight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      AppWidgets.regularText(
                                        alignment: TextAlign.center,
                                        text: controller.story.description,
                                        size: 14.0,
                                        color: AppColors.black,
                                        weight: FontWeight.w400,
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      controller.story.genres == null ||
                                              controller.story.genres!.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              height: height * 0.04,
                                              child: ListView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: controller
                                                    .story.genres!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Home.getGenreItem(
                                                        controller.story
                                                            .genres![index],
                                                        width),
                                                  );
                                                },
                                              ),
                                            ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                controller.updateIsBookmarked(),
                                            child: !controller.isBookmarked
                                                ? Container(
                                                    width: width * 0.14,
                                                    height: width * 0.14,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppColors.white,
                                                        border: Border.all(
                                                            color:
                                                                AppColors.black,
                                                            width: 2)),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .bookmark_outline_rounded,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: width * 0.14,
                                                    height: width * 0.14,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: AppColors.white,
                                                        border: Border.all(
                                                            color:
                                                                AppColors.black,
                                                            width: 2)),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .bookmark_added_rounded,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(
                                            width: width * 0.025,
                                          ),
                                          GestureDetector(
                                            onTap: () => Get.to(
                                                () => ReadStory(
                                                    name:
                                                        controller.story.name!),
                                                arguments: [controller.story]),
                                            child: Container(
                                              width: width * 0.4,
                                              height: width * 0.14,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: AppColors.white,
                                                  border: Border.all(
                                                      color: AppColors.black,
                                                      width: 2)),
                                              child: Center(
                                                child: AppWidgets.regularText(
                                                  text: AppStrings.read,
                                                  size: 16.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: width * 0.025,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () => Get.to(
                                                () => ListenStory(
                                                    name:
                                                        controller.story.name!),
                                                arguments: [controller.story]),
                                            child: Container(
                                              width: width * 0.4,
                                              height: width * 0.14,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.black,
                                              ),
                                              child: Center(
                                                child: AppWidgets.regularText(
                                                  text: AppStrings.listen,
                                                  size: 16.0,
                                                  color: AppColors.white,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.025,
                                          ),
                                          GestureDetector(
                                            onTap: () => Get.to(
                                                () => GestureStory(
                                                    name:
                                                        controller.story.name!),
                                                arguments: [controller.story]),
                                            child: Container(
                                              width: width * 0.14,
                                              height: width * 0.14,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: AppColors.white,
                                                  border: Border.all(
                                                      color: AppColors.black,
                                                      width: 2)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.back_hand_rounded,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: AppColors.grey,
                                ),
                                controller.storyList.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: AppWidgets.regularText(
                                                text: AppStrings.moreFromAuther,
                                                size: 20.0,
                                                color: AppColors.black,
                                                weight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            Container(
                                              height: height * 0.29,
                                              alignment: Alignment.centerLeft,
                                              child: ListView.builder(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    controller.storyList.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: getMoreStoryItem(
                                                        controller
                                                            .storyList[index],
                                                        height,
                                                        width),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  getMoreStoryItem(Story moreStory, double height, double width) {
    return GestureDetector(
      onTap: () {
        StoryDetailsController storyDetailsController =
            Get.find<StoryDetailsController>();
        storyDetailsController.onInit();
        Get.to(() => StoryDetails(refreshHome: false),
            arguments: [moreStory], preventDuplicates: false);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppWidgets.imageWidget(
              moreStory.image,
              AppImages.noStoryCover,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: height * 0.2,
            width: width * 0.3,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            width: width * 0.3,
            child: AppWidgets.regularText(
              text: moreStory.name,
              size: 14.0,
              alignment: TextAlign.center,
              maxLines: 2,
              textOverFlow: TextOverflow.ellipsis,
              color: AppColors.black,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
