import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/search_controller.dart';
import 'package:talecraft/utils/no_items.dart';
import 'package:talecraft/utils/validator.dart';

import '../../model/story.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';
import '../home/story_details.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.search,
        cantGoBack: true,
      ),
      body: GetBuilder<SearchStoryController>(
          init: SearchStoryController(),
          builder: (controller) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 0, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              controller.searchStories(value);
                            },
                            controller: controller.searchController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: AppColors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.black, width: 1)),
                              hintText: AppStrings.search,
                              hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                            ),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            validator: validateSearch,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Expanded(
                      child: controller.isLoading
                          ? LoadingOverlay()
                          : controller.searchList.isEmpty
                              ? NoItemsOverlay()
                              : CupertinoScrollbar(
                                  controller: controller.scrollController,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.only(bottom: 30, top: 10),
                                    controller: controller.scrollController,
                                    itemCount: controller.searchList.length,
                                    itemBuilder: (context, index) {
                                      return getStoryItem(height, width,
                                          controller.searchList[index]);
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
                      text: story.authorName,
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
