import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talecraft/utils/app_strings.dart';

import '../model/story.dart';
import '../repository/storyRepository/story_repository.dart';
import 'app_colors.dart';
import 'app_images.dart';

class AppWidgets {
  static regularText(
      {text,
      required double size,
      color,
      alignment,
      decoration,
      weight,
      maxLines,
      textOverFlow,
      height}) {
    return Text(
      text,
      style: TextStyle(
          decoration: decoration ?? TextDecoration.none,
          fontSize: size,
          color: color,
          fontFamily: "Regular",
          fontWeight: weight,
          height: height),
      overflow: textOverFlow,
      maxLines: maxLines,
      textAlign: alignment ?? TextAlign.start,
    );
  }

  static boldText(
      {text,
      required double size,
      color,
      alignment,
      decoration,
      weight,
      maxLines,
      textOverFlow}) {
    return Text(
      text,
      style: TextStyle(
        decoration: decoration ?? TextDecoration.none,
        fontSize: size,
        color: color,
        fontFamily: "Bold",
        fontWeight: weight,
      ),
      overflow: textOverFlow,
      maxLines: maxLines,
      textAlign: alignment ?? TextAlign.start,
    );
  }

  static normalTextField(
      {controller,
      hintText,
      suffixIcon,
      keyBoardType,
      style,
      validator,
      fillColor,
      textAlign,
      prefix,
      prefixIcon,
      enabled,
      onChanged,
      filled,
      obscureText,
      labelText,
      errorText,
      isUnderlinedBorder,
      maxLines,
      maxLength,
      minLines,
      fontColor,
      borderColor,
      fontSize,
      fontWeight,
      borderFillColor,
      hintFontColor,
      hintFontWeight,
      hintFontSize,
      onTap,
      inputFormatters,
      autovalidateMode,
      helperText}) {
    return TextFormField(
      onTap: onTap,
      obscureText: obscureText,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      cursorColor: AppColors.black,
      textAlign: textAlign,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      maxLength: maxLength,
      minLines: minLines,
      autocorrect: false,
      style: TextStyle(
        color: fontColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyBoardType,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: hintFontColor,
          fontWeight: hintFontWeight,
          fontSize: hintFontSize,
        ),
        errorMaxLines: 5,
        helperText: helperText,
        helperMaxLines: 5,
        labelText: labelText,
        labelStyle: TextStyle(color: fontColor, fontWeight: FontWeight.w400),
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        disabledBorder: InputBorder.none,
        enabledBorder: isUnderlinedBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
        focusedBorder: isUnderlinedBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
        border: isUnderlinedBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
        filled: filled,
        fillColor: fillColor,
      ),
    );
  }

  static imageWidget(String? image, errorImage, {bool? isFrameBuilder}) {
    var width = MediaQuery.of(Get.context!).size.width;
    return image != null && image.isNotEmpty
        ? Image.network(
            image,
            frameBuilder: isFrameBuilder == true
                ? (ctx, child, frame, wasSynchronouslyLoaded) {
                    return frame != null
                        ? child
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Center(
                              child: Container(
                                width: width * 0.43,
                                height: width * 0.43,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          );
                  }
                : null,
            loadingBuilder: (ctx, Widget, loadingProgress) {
              return loadingProgress == null
                  ? Widget
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Center(
                        child: Container(
                          width: width * 0.43,
                          height: width * 0.43,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
            },
            errorBuilder: (ctx, _, error) {
              try {
                return Image.asset(
                  errorImage,
                  fit: BoxFit.cover,
                );
              } catch (e) {
                return Image.asset(
                  errorImage,
                  fit: BoxFit.cover,
                );
              }
            },
            fit: BoxFit.cover,
          )
        : Image.asset(
            errorImage,
            fit: BoxFit.cover,
          );
  }

  static showToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.black,
        textColor: AppColors.white,
        fontSize: 16.0);
  }

  static showSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      forwardAnimationCurve: Curves.easeInOutCubic,
      reverseAnimationCurve: Curves.easeInOutCubic,
      backgroundColor:
          title == AppStrings.error ? AppColors.red : AppColors.green,
      colorText: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      icon: title != AppStrings.error
          ? const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            )
          : const Icon(
              Icons.error_rounded,
              color: Colors.white,
            ),
      duration: const Duration(milliseconds: 3000),
    );
  }

  static showRatingDialog(Story story) {
    var height = MediaQuery.of(Get.context!).size.height;
    return RatingDialog(
      initialRating: 1.0,
      enableComment: false,
      showCloseButton: true,
      title: AppWidgets.regularText(
        text: story.name,
        size: 22.0,
        alignment: TextAlign.center,
        color: AppColors.black,
        weight: FontWeight.w600,
      ),
      message: AppWidgets.regularText(
        text: 'Tap a star to set your rating.',
        size: 14.0,
        alignment: TextAlign.center,
        color: AppColors.black,
        weight: FontWeight.w400,
      ),
      image: Container(
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
      ),
      submitButtonText: 'Submit',
      onCancelled: () => log('Rating Cancelled'),
      submitButtonTextStyle: TextStyle(
          fontFamily: "Regular",
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          fontSize: 16),
      onSubmitted: (response) async {
        final storyRepo = Get.put(StoryRepository());
        final newStory = await storyRepo.getCurrentStory(story.id!);
        if (newStory != null) {
          double currentRating = newStory.rating ?? 0.0;
          int numberOfRatings = newStory.noOfRatings ?? 0;

          double newRating =
              ((currentRating * numberOfRatings) + response.rating) /
                  (numberOfRatings + 1);
          await storyRepo.updateStoryRatings(newRating, newStory);
        }
      },
    );
  }
}
