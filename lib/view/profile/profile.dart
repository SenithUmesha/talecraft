import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/profile_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.profile,
        cantGoBack: true,
      ),
      body: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
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
                    text: controller.user!.displayName,
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w600,
                  ),
                  AppWidgets.regularText(
                    text: controller.user!.email,
                    size: 14.0,
                    color: AppColors.black,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                    child: Divider(
                      thickness: 1,
                      color: AppColors.grey,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                  //   child: Column(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {},
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.edit_rounded,
                  //               color: AppColors.black,
                  //             ),
                  //             SizedBox(
                  //               width: 15,
                  //             ),
                  //             AppWidgets.regularText(
                  //               text: AppStrings.editProfile,
                  //               size: 16.0,
                  //               color: AppColors.black,
                  //               weight: FontWeight.w600,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 12,
                  //       ),
                  //       Divider(
                  //         thickness: 1,
                  //         color: AppColors.grey,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                  //   child: Column(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {},
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.key_rounded,
                  //               color: AppColors.black,
                  //             ),
                  //             SizedBox(
                  //               width: 15,
                  //             ),
                  //             AppWidgets.regularText(
                  //               text: AppStrings.changePassword,
                  //               size: 16.0,
                  //               color: AppColors.black,
                  //               weight: FontWeight.w600,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 12,
                  //       ),
                  //       Divider(
                  //         thickness: 1,
                  //         color: AppColors.grey,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 12, right: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => controller.logout(),
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
              ),
            );
          }),
    );
  }
}
