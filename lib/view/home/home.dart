import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/home_controller.dart';
import 'package:talecraft/model/Story.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_strings.dart';
import 'package:talecraft/view/home/story_details.dart';

import '../../utils/app_images.dart';
import '../../utils/app_widgets.dart';

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
                height: height * 0.015,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    AppImages.bannerOne,
                    fit: BoxFit.cover,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: height * 0.17,
                  width: width,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 0, left: 15, right: 15),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: AppWidgets.regularText(
                          text: AppStrings.recommendedForYou,
                          size: 20.0,
                          color: AppColors.black,
                          weight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Container(
                        height: height * 0.04,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.genreList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: getGenreItem(
                                  controller.genreList[index], width),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          color: AppColors.black,
                          onRefresh: () async {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CupertinoScrollbar(
                              controller: controller.scrollController,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: 30, top: 10),
                                controller: controller.scrollController,
                                itemCount: controller.storyList.length,
                                itemBuilder: (context, index) {
                                  return getStoryItem(height, width,
                                      controller.storyList[index]);
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  static getGenreItem(String genre, double width) {
    return Container(
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
    );
  }

  static getStoryItem(double height, double width, Story story) {
    return GestureDetector(
      onTap: () => Get.to(() => StoryDetails(
            story: story,
          )),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          height: height * 0.2,
          child: Row(
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
                    AppWidgets.regularText(
                      text: story.author,
                      size: 14.0,
                      color: AppColors.black,
                      weight: FontWeight.w400,
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
                    AppWidgets.regularText(
                      text: "${story.readTime} read",
                      size: 12.0,
                      color: AppColors.grey,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: height * 0.006,
                    ),
                    RatingBarIndicator(
                      rating: story.rating ?? 0.0,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 14,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
