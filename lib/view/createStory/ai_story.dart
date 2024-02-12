import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/ai_story_controller.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../../utils/custom_app_bar.dart';

class AiStory extends StatelessWidget {
  const AiStory({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: AppColors.white,
        child: SafeArea(
            child: Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.aiGenaratedStory,
          ),
          body: GetBuilder<AiStoryController>(
              init: AiStoryController(),
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
                                      TextFormField(
                                        controller:
                                            controller.contextController,
                                        maxLines: 5,
                                        minLines: 5,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppColors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppColors.black,
                                                  width: 1)),
                                          hintText: AppStrings.provideContext,
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
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return AppStrings.addSomeText;
                                          } else if (value.length > 150) {
                                            return AppStrings
                                                .textShouldBeLessThan150;
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: controller.isLoading
                                      ? CircularProgressIndicator(
                                          color: AppColors.black,
                                        )
                                      : GestureDetector(
                                          onTap: () => controller.genarate(),
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
                                                text: AppStrings.genarated,
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
}
