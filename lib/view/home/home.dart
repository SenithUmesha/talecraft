import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/home_controller.dart';
import 'package:talecraft/controller/nav_bar_controller.dart';
import 'package:talecraft/model/story.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_strings.dart';
import 'package:talecraft/view/home/browse_stories.dart';
import 'package:talecraft/view/home/genre_details.dart';
import 'package:talecraft/view/home/story_details.dart';

import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../utils/app_widgets.dart';
import '../../utils/loading_overlay.dart';
import '../navBar/nav_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.appIcon,
                    scale: 16,
                  ),
                  SizedBox(
                    width: width * 0.025,
                  ),
                  AppWidgets.regularText(
                    text: AppStrings.appName,
                    size: 18.0,
                    weight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Divider(
                thickness: 1,
                color: AppColors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 15, right: 15),
                child: GestureDetector(
                  onTap: () {
                    Get.find<NavBarController>().updateIndex(4);
                    Get.to(() => const NavBar());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      AppImages.banner,
                      fit: BoxFit.cover,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: height * 0.17,
                    width: width,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 15, left: 15, right: 15),
                  child: SingleChildScrollView(
                    child: controller.isLoading
                        ? Padding(
                            padding: EdgeInsets.only(top: height * 0.25),
                            child: LoadingOverlay(),
                          )
                        : Column(
                            children: [
                              Container(
                                height: height * 0.04,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.allGenres.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: getGenreItem(
                                          controller.allGenres[index], width),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              !controller.recommendedStoriesList.isEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: AppWidgets.regularText(
                                                  text: AppStrings
                                                      .recommendedForYou,
                                                  size: 18.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                Get.to(() => BrowseStories(
                                                      name: AppStrings
                                                          .recommendedForYou,
                                                      list: controller
                                                          .recommendedStoriesList,
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: height * 0.31,
                                          width: width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                bottom: height * 0.008,
                                                top: height * 0.008),
                                            controller: controller
                                                .recommendedScrollController,
                                            itemCount: controller
                                                .recommendedStoriesList.length,
                                            itemBuilder: (context, index) {
                                              return getStoryItem(
                                                  height,
                                                  width,
                                                  controller
                                                          .recommendedStoriesList[
                                                      index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              !controller.allStories.isEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: AppWidgets.regularText(
                                                  text: AppStrings.allStories,
                                                  size: 18.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                Get.to(() => BrowseStories(
                                                      name:
                                                          AppStrings.allStories,
                                                      list:
                                                          controller.allStories,
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: height * 0.31,
                                          width: width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                bottom: height * 0.008,
                                                top: height * 0.008),
                                            controller: controller
                                                .allStoriesScrollController,
                                            itemCount:
                                                controller.allStories.length,
                                            itemBuilder: (context, index) {
                                              return getStoryItem(height, width,
                                                  controller.allStories[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              !controller.continueStoriesList.isEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: AppWidgets.regularText(
                                                  text: AppStrings
                                                      .continueStories,
                                                  size: 18.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                Get.to(() => BrowseStories(
                                                      name: AppStrings
                                                          .continueStories,
                                                      list: controller
                                                          .continueStoriesList,
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: height * 0.31,
                                          width: width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                bottom: height * 0.008,
                                                top: height * 0.008),
                                            controller: controller
                                                .continueScrollController,
                                            itemCount: controller
                                                .continueStoriesList.length,
                                            itemBuilder: (context, index) {
                                              return getStoryItem(
                                                  height,
                                                  width,
                                                  controller
                                                          .continueStoriesList[
                                                      index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              !controller.yourStoriesList.isEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: AppWidgets.regularText(
                                                  text: AppStrings.yourStories,
                                                  size: 18.0,
                                                  color: AppColors.black,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                Get.to(() => BrowseStories(
                                                      name: AppStrings
                                                          .yourStories,
                                                      list: controller
                                                          .yourStoriesList,
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: height * 0.31,
                                          width: width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(
                                                bottom: height * 0.008,
                                                top: height * 0.008),
                                            controller: controller
                                                .publishedScrollController,
                                            itemCount: controller
                                                .yourStoriesList.length,
                                            itemBuilder: (context, index) {
                                              return getStoryItem(
                                                  height,
                                                  width,
                                                  controller
                                                      .yourStoriesList[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: height * 0.02,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  static getGenreItem(String genre, double width) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => GenreDetails(
                  name: genre,
                ),
            arguments: [genre]);
      },
      child: Container(
        width: width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.red.withOpacity(0.1),
        ),
        child: Center(
          child: AppWidgets.regularText(
            text: genre,
            size: 14.0,
            color: AppColors.red,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static getStoryItem(double height, double width, Story story) {
    return GestureDetector(
      onTap: () {
        Get.to(() => StoryDetails(refreshHome: true), arguments: [story]);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Container(
          width: width * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppWidgets.imageWidget(
                      story.image,
                      AppImages.noStoryCover,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: height * 0.2,
                    width: width * 0.3,
                  ),
                  story.achievementDone != null && story.achievementDone!
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
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
              SizedBox(
                height: height * 0.015,
              ),
              AppWidgets.regularText(
                text: story.name,
                size: 14.0,
                maxLines: 2,
                textOverFlow: TextOverflow.ellipsis,
                color: AppColors.black,
                weight: FontWeight.w600,
              ),
              AppWidgets.regularText(
                text: story.authorName,
                size: 12.0,
                color: AppColors.black,
                weight: FontWeight.w400,
                maxLines: 1,
                textOverFlow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
