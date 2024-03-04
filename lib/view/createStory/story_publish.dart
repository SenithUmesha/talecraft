import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/story_publish_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';

class StoryPublish extends StatelessWidget {
  const StoryPublish({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      physics: BouncingScrollPhysics(),
                      child: controller.isLoading
                          ? Padding(
                              padding: EdgeInsets.only(top: height * 0.35),
                              child: LoadingOverlay(),
                            )
                          : Form(
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
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: controller
                                                              .isImagePathEmptyValidator
                                                          ? AppColors.errorRed
                                                          : AppColors.black,
                                                      width: 2),
                                                ),
                                                child: controller
                                                        .imagePath.isEmpty
                                                    ? AppWidgets.imageWidget(
                                                        AppImages.noStoryCover,
                                                        AppImages.noStoryCover,
                                                      )
                                                    : Image.file(
                                                        File(
                                                          controller.imagePath,
                                                        ),
                                                        fit: BoxFit.cover,
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
                                                              .isImagePathEmptyValidator
                                                          ? AppColors.errorRed
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
                                            maxLines: 3),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        AppWidgets.regularText(
                                          text: AppStrings.achievementEnding,
                                          size: 16.0,
                                          color: AppColors.black,
                                          weight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        DropdownButtonFormField2<String>(
                                          hint: AppWidgets.regularText(
                                            text: AppStrings.selectEnding,
                                            size: 14.0,
                                            color: AppColors.black,
                                            weight: FontWeight.w400,
                                          ),
                                          decoration: InputDecoration.collapsed(
                                              hintText: ''),
                                          items: controller.endingsList
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child:
                                                        AppWidgets.regularText(
                                                      text: item,
                                                      size: 14.0,
                                                      color: AppColors.black,
                                                      weight: FontWeight.w400,
                                                    ),
                                                  ))
                                              .toList(),
                                          validator: (value) {
                                            if (value == null) {
                                              return AppStrings
                                                  .pleaseSelectEnding;
                                            }
                                            return null;
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          value: controller.selectedEnding,
                                          onChanged: (String? value) {
                                            controller.updateEndings(value);
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: height * 0.065,
                                            width: width,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: AppColors.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: height * 0.15,
                                            width: width - 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(5),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: height * 0.05,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        textFieldView(
                                            name: AppStrings.readTime,
                                            hintText: "",
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return AppStrings.addSomeText;
                                              } else if (int.parse(value) >
                                                  60) {
                                                return AppStrings
                                                    .readTimeShouldBeLessThan60;
                                              }
                                              return null;
                                            },
                                            textEditingController:
                                                controller.readTimeController,
                                            keyBoardType: TextInputType.number,
                                            height: height,
                                            index: 2,
                                            maxLines: 1),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        AppWidgets.regularText(
                                          text: AppStrings.genres,
                                          size: 16.0,
                                          color: AppColors.black,
                                          weight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: controller.allGenres
                                              .map((genre) => controller
                                                  .buildChoiceChip(genre))
                                              .toList(),
                                        ),
                                        if (controller.genreValidationError)
                                          Text(
                                            AppStrings.pickAtLeastOneGenre,
                                            style: TextStyle(
                                              color: AppColors.errorRed,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 30),
                                    child: GestureDetector(
                                      onTap: () => controller.publish(),
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
    );
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
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
                prefix: const Padding(padding: EdgeInsets.only(left: 15.0)),
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
                errorStyle: TextStyle(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                )),
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
