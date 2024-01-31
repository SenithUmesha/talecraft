import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/profile_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: SafeArea(
          child: Scaffold(
        body: GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (controller) {
              return Column(
                children: [
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 0, left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: AppWidgets.regularText(
                            text: AppStrings.profile,
                            size: 20.0,
                            color: AppColors.black,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.red, width: 2),
                    ),
                    child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: AppWidgets.imageWidget(
                          AppImages.appIcon,
                          AppImages.appIcon,
                        )),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  AppWidgets.regularText(
                    text: "Senith Umesha",
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                  ),
                  AppWidgets.regularText(
                    text: "34senith@gmail.com",
                    size: 14.0,
                    color: AppColors.black,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                color: AppColors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              AppWidgets.regularText(
                                text: AppStrings.editProfile,
                                size: 16.0,
                                color: AppColors.black,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.key_rounded,
                                color: AppColors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              AppWidgets.regularText(
                                text: AppStrings.changePassword,
                                size: 16.0,
                                color: AppColors.black,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: AppColors.red,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              AppWidgets.regularText(
                                text: AppStrings.logOut,
                                size: 16.0,
                                color: AppColors.red,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      )),
    );
  }
}
