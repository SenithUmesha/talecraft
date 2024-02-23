import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/bookmarks_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../home/home.dart';

class Bookmarks extends StatelessWidget {
  const Bookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<BookmarksController>(
          init: BookmarksController(),
          builder: (controller) {
            return Column(
              children: [
                SizedBox(
                  height: height * 0.015,
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
                            text: AppStrings.bookmarkedStories,
                            size: 20.0,
                            color: AppColors.black,
                            weight: FontWeight.w600,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: CupertinoScrollbar(
                                controller: controller.scrollController,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: 30, top: 10),
                                  controller: controller.scrollController,
                                  itemCount: controller.bookmarksList.length,
                                  itemBuilder: (context, index) {
                                    return Home.getStoryItem(height, width,
                                        controller.bookmarksList[index]);
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
          }),
    );
  }
}
