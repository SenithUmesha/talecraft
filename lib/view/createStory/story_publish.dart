import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/story_publish_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class StoryPublish extends StatelessWidget {
  const StoryPublish({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: AppColors.white,
        child: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.publishStory,
          ),
          body: GetBuilder<StoryPublishController>(
              init: StoryPublishController(),
              builder: (controller) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: controller.formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppWidgets.regularText(
                                        text: AppStrings.storyCover,
                                        size: 16.0,
                                        color: AppColors.black,
                                        weight: FontWeight.w400,
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Center(
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 15),
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: controller
                                                            .isImagePathEmpty
                                                        ? AppColors.red
                                                        : AppColors.black,
                                                    width: 2),
                                              ),
                                              child: AppWidgets.imageWidget(
                                                AppImages.noStoryCover,
                                                AppImages.noStoryCover,
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              height: height * 0.2,
                                              width: width * 0.3,
                                            ),
                                            Positioned(
                                              width: width * 0.3,
                                              bottom: 0,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    controller.uploadImage(),
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: CircleAvatar(
                                                    backgroundColor: controller
                                                            .isImagePathEmpty
                                                        ? AppColors.red
                                                        : AppColors.black,
                                                    child: SizedBox(
                                                      width: 36,
                                                      height: 36,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.white,
                                                        child: Icon(
                                                          Icons.edit_rounded,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      textFieldView(
                                          name: AppStrings.storyName,
                                          hintText: "",
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppStrings.addSomeText;
                                            } else if (value.length > 40) {
                                              return AppStrings
                                                  .textShouldBeLessThan40;
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              controller.storyNameController,
                                          keyBoardType: TextInputType.text,
                                          height: height,
                                          index: 0,
                                          maxLines: 1),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      textFieldView(
                                          name: AppStrings.storyDescription,
                                          hintText: "",
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppStrings.addSomeText;
                                            } else if (value.length > 100) {
                                              return AppStrings
                                                  .textShouldBeLessThan100;
                                            }
                                            return null;
                                          },
                                          textEditingController: controller
                                              .storyDescriptionController,
                                          keyBoardType: TextInputType.text,
                                          height: height,
                                          index: 1,
                                          maxLines: 3)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: GestureDetector(
                                    onTap: () => controller.publish(),
                                    child: Container(
                                      width: width * 0.4,
                                      height: width * 0.14,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.black,
                                      ),
                                      child: Center(
                                        child: AppWidgets.regularText(
                                          text: AppStrings.publish,
                                          size: 16.0,
                                          color: AppColors.white,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        )));
  }

  textFieldView(
      {required var name,
      required String hintText,
      required String? Function(String? value) validator,
      required TextEditingController textEditingController,
      required keyBoardType,
      required var height,
      required int index,
      required int maxLines,
      helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgets.regularText(
          text: name,
          size: 16.0,
          color: AppColors.black,
          weight: FontWeight.w400,
        ),
        SizedBox(
          height: height * 0.01,
        ),
        TextFormField(
            controller: textEditingController,
            maxLines: maxLines,
            keyboardType: keyBoardType,
            decoration: InputDecoration(
              helperText: helperText,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.black, width: 1)),
              hintText: hintText,
              hintStyle: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
            validator: validator),
      ],
    );
  }
}
// (value) {
//             if (value == null || value.trim().isEmpty) {
//               return AppStrings.addSomeText;
//             }
//             return null;
//           },