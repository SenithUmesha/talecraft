import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
      isInputBorder,
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
        enabledBorder: isInputBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : InputBorder.none,
        focusedBorder: isInputBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : InputBorder.none,
        border: isInputBorder
            ? UnderlineInputBorder(borderSide: BorderSide(color: borderColor))
            : InputBorder.none,
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
}
