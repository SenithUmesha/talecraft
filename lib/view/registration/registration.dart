import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_strings.dart';
import 'package:talecraft/utils/app_text_widgets.dart';
import 'package:talecraft/utils/validator.dart';

import '../../controller/registration_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../utils/custom_app_bar.dart';

class Registration extends StatelessWidget {
  Registration({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Register",
      ),
      body: GetBuilder<RegistrationController>(
          init: RegistrationController(),
          builder: (controller) {
            return SizedBox(
              height: height,
              width: width,
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: SingleChildScrollView(
                            child: Observer(builder: (context) {
                              return
                                  // controller.isLoading
                                  //     ? Visibility(
                                  //         visible: controller.isLoading,
                                  //         child: Padding(
                                  //           padding:
                                  //               EdgeInsets.only(top: height * 0.3),
                                  //           child: LoadingWidget(),
                                  //         ))
                                  //     :
                                  Form(
                                key: formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    textFieldView(
                                        name: AppStrings.name,
                                        hintText: AppStrings.name,
                                        validator: validateName,
                                        textEditingController:
                                            controller.nameController,
                                        keyBoardType: TextInputType.text,
                                        context: context,
                                        controller: controller,
                                        obscureText: false,
                                        suffixIcon: false,
                                        index: 0),
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
                                    textFieldView(
                                        name: AppStrings.password,
                                        hintText: AppStrings.password,
                                        validator: validatePassword,
                                        textEditingController:
                                            controller.passwordController,
                                        keyBoardType:
                                            TextInputType.visiblePassword,
                                        context: context,
                                        controller: controller,
                                        obscureText:
                                            controller.passwordObscureText,
                                        suffixIcon: true,
                                        index: 2,
                                        helperText:
                                            AppStrings.passwordHelperText),
                                    textFieldView(
                                        name: AppStrings.confirmPassword,
                                        hintText: AppStrings.confirmPassword,
                                        validator: (value) =>
                                            validateConfirmPasswordRegistration(
                                                controller
                                                    .passwordController.text,
                                                value),
                                        textEditingController: controller
                                            .confirmPasswordController,
                                        keyBoardType:
                                            TextInputType.visiblePassword,
                                        context: context,
                                        controller: controller,
                                        obscureText: controller
                                            .confirmPasswordObscureText,
                                        suffixIcon: true,
                                        index: 3),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {}
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColors.black,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 20),
                                          child: SizedBox(
                                            width: width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(),
                                                  child: AppTextWidgets
                                                      .regularText(
                                                    text: AppStrings.register,
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
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppTextWidgets.regularText(
                                          text: AppStrings.alreadyHaveAnAccount,
                                          size: 18.0,
                                          color: AppColors.black,
                                          weight: FontWeight.w500,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: AppTextWidgets.regularText(
                                            text: AppStrings.login,
                                            size: 18.0,
                                            color: AppColors.red,
                                            weight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          )),
                    ),
                  ],
                ),
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
      required RegistrationController controller,
      required bool obscureText,
      required bool suffixIcon,
      required int index,
      helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidgets.regularText(
          text: name,
          size: 18.0,
          color: AppColors.black,
          weight: FontWeight.w400,
        ),
        AppTextWidgets.normalTextField(
          controller: textEditingController,
          obscureText: obscureText,
          maxLines: 1,
          filled: false,
          borderColor: AppColors.grey,
          textAlign: TextAlign.start,
          isInputBorder: true,
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
          suffixIcon: suffixIcon
              ? GestureDetector(
                  onTap: () {
                    controller.showPassword(obscureText, index);
                  },
                  child: Image.asset(
                    obscureText ? AppIcons.hide : AppIcons.unHide,
                    scale: 20,
                  ),
                )
              : const SizedBox(),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
