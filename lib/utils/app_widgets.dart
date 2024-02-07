import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talecraft/utils/app_strings.dart';

import 'app_colors.dart';

class AppWidgets {
  static regularText(
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
        fontFamily: "Regular",
        fontWeight: weight,
      ),
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

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: AppStrings.close,
        textColor: AppColors.red,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
