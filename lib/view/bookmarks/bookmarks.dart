import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/bookmarks_controller.dart';

import '../../model/story.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';
import '../../utils/no_items.dart';
import '../home/story_details.dart';

class Bookmarks extends StatelessWidget {
  const Bookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.bookmarkedStories,
        cantGoBack: true,
      ),
      body: GetBuilder<BookmarksController>(
          init: BookmarksController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 0, left: 15, right: 15),
              child: controller.isLoading
                  ? LoadingOverlay()
                  : controller.bookmarksList.isEmpty
                      ? NoItemsOverlay()
                      : Column(
                          children: [
                            Expanded(
                              child: CupertinoScrollbar(
                                controller: controller.scrollController,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: 30),
                                  controller: controller.scrollController,
                                  itemCount: controller.bookmarksList.length,
                                  itemBuilder: (context, index) {
                                    return getStoryItem(height, width,
                                        controller.bookmarksList[index]);
                                  },
                                ),
                              ),
                            )
                          ],
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
                      maxLines: 2,
                      textOverFlow: TextOverflow.ellipsis,
                    ),
                    AppWidgets.regularText(
                      text: story.authorName,
                      size: 14.0,
                      color: AppColors.black,
                      weight: FontWeight.w400,
                      maxLines: 1,
                      textOverFlow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: height * 0.006,
                    ),
                    AppWidgets.regularText(
                        text: story.description,
                        size: 12.0,
                        color: AppColors.black,
                        weight: FontWeight.w400,
                        maxLines: 2,
                        textOverFlow: TextOverflow.ellipsis),
                    SizedBox(
                      height: height * 0.006,
                    ),
                    AppWidgets.regularText(
                      text: "${story.readTime}",
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
