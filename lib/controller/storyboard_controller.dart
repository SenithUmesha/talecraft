import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/view/createStory/storyboard.dart';

import '../utils/app_colors.dart';
import '../utils/app_widgets.dart';

class StoryboardController extends GetxController {
  final TextEditingController shortDesciptionController =
      TextEditingController();
  final TextEditingController textController = TextEditingController();

  void showAddTextDialog(Block block) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    shortDesciptionController.text = block.shortDescription;
    textController.text = block.text;

    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: AppWidgets.regularText(
                text: block.type == BlockType.story
                    ? "Edit Story Block"
                    : "Edit Choice Block",
                size: 20.0,
                color: AppColors.black,
                weight: FontWeight.w600,
              ),
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: shortDesciptionController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.black, width: 2)),
                        hintText: "Short Description",
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter some text';
                        } else if (value.trim().length > 20) {
                          return 'Please enter a shorter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: textController,
                      maxLines: null,
                      minLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.black, width: 2)),
                        hintText:
                            block.type == BlockType.story ? "Story" : "Choice",
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppWidgets.regularText(
                    text: 'Cancel',
                    size: 16.0,
                    color: AppColors.black,
                    weight: FontWeight.w400,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.black)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      block.updateText(
                        shortDesciptionController.text,
                        textController.text,
                      );
                      update();
                      Get.back();
                    }
                  },
                  child: AppWidgets.regularText(
                    text: 'Save',
                    size: 16.0,
                    color: AppColors.white,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
            ));
  }
}
