import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/forgot_password_controller.dart';
import 'package:talecraft/utils/app_strings.dart';
import 'package:talecraft/utils/app_widgets.dart';
import 'package:talecraft/utils/validator.dart';

import '../../utils/app_colors.dart';
import '../../utils/custom_app_bar.dart';
import '../../utils/loading_overlay.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.forgotPasswordWithOutQuestionMark,
      ),
      body: GetBuilder<ForgotPasswordController>(
          init: ForgotPasswordController(),
          builder: (controller) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: SingleChildScrollView(
                            child: controller.isLoading
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.35),
                                    child: LoadingOverlay(),
                                  )
                                : Form(
                                    key: formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      children: [
                                        textFieldView(
                                            name: AppStrings.email,
                                            hintText: AppStrings.email,
                                            validator: validateEmail,
                                            textEditingController:
                                                controller.emailController,
                                            keyBoardType:
                                                TextInputType.emailAddress,
                                            context: context,
                                            controller: controller,
                                            obscureText: false,
                                            suffixIcon: false,
                                            index: 1),
                                        SizedBox(
                                          height: height * 0.04,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              controller.forgotPassword();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: AppColors.black,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 20),
                                              child: SizedBox(
                                                width: width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(),
                                                      child: AppWidgets
                                                          .regularText(
                                                        text: AppStrings
                                                            .resetPassword,
                                                        size: 22,
                                                        color: AppColors.white,
                                                        weight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                  ),
                ],
              ),
            );
          }),
    );
  }

  textFieldView(
      {required String name,
      required String hintText,
      required String? Function(String? value) validator,
      required TextEditingController textEditingController,
      keyBoardType,
      context,
      required ForgotPasswordController controller,
      required bool obscureText,
      required bool suffixIcon,
      required int index,
      helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgets.regularText(
          text: name,
          size: 18.0,
          color: AppColors.black,
          weight: FontWeight.w400,
        ),
        AppWidgets.normalTextField(
          controller: textEditingController,
          obscureText: obscureText,
          maxLines: 1,
          filled: false,
          borderColor: AppColors.grey,
          textAlign: TextAlign.start,
          isUnderlinedBorder: true,
          fontColor: AppColors.black,
          hintText: hintText,
          validator: validator,
          keyBoardType: keyBoardType,
          helperText: helperText,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          borderFillColor: AppColors.yellow,
          hintFontColor: AppColors.grey.withOpacity(0.5),
          hintFontWeight: FontWeight.w400,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
