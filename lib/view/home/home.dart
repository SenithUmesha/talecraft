import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/home_controller.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_strings.dart';

import '../../utils/app_text_widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.015,
                ),
                AppTextWidgets.regularText(
                  text: AppStrings.appName,
                  size: 20.0,
                  color: AppColors.red,
                  weight: FontWeight.w600,
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Divider(
                  thickness: 1,
                  color: AppColors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: AppTextWidgets.regularText(
                          text: AppStrings.recommendedForYou,
                          size: 20.0,
                          color: AppColors.black,
                          weight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Container(
                        height: height * 0.04,
                        child: ListView.builder(
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
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  getGenreItem(String genre, double width) {
    return Container(
      width: width * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.red.withOpacity(0.1),
      ),
      child: Center(
        child: AppTextWidgets.regularText(
          text: genre,
          size: 14.0,
          color: AppColors.red,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}
