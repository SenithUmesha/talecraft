import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/utils/app_colors.dart';
import 'package:talecraft/utils/app_widgets.dart';
import 'package:talecraft/view/navBar/nav_bar.dart';
import 'package:talecraft/view/registration/registration.dart';

import '../../controller/login_controller.dart';
import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../utils/app_strings.dart';
import '../../utils/validator.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          body: GetBuilder<LoginController>(
              init: LoginController(),
              builder: (controller) {
                return GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? height * 0.4
                                    : height * 0.28,
                            width: width,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    AppImages.loginBackground,
                                  ),
                                  fit: BoxFit.fill),
                            ),
                            child: Transform.scale(
                              scale: 0.6,
                              child: Center(
                                child:
                                    Image.asset(AppImages.transparentAppIcon),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SingleChildScrollView(
                              child: Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: formKey,
                            child: Column(
                              children: [
                                textFiledView(
                                    name: AppStrings.email,
                                    hintText: AppStrings.enterEmail,
                                    validator: validateEmail,
                                    textEditingController:
                                        controller.emailController,
                                    keyBoardType: TextInputType.emailAddress,
                                    context: context,
                                    controller: controller,
                                    obscureText: false,
                                    suffixIcon: false),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                textFiledView(
                                    name: AppStrings.password,
                                    hintText: AppStrings.password,
                                    validator: validatePasswordLogin,
                                    textEditingController:
                                        controller.passwordController,
                                    keyBoardType: TextInputType.visiblePassword,
                                    context: context,
                                    controller: controller,
                                    obscureText: controller.passwordObscureText,
                                    suffixIcon: true),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: AppWidgets.regularText(
                                        text: AppStrings.forgotPassword,
                                        size: 16.0,
                                        color: AppColors.grey,
                                        weight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.06,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // if (formKey.currentState!.validate()) {
                                    //   Get.to(() => const NavBar());
                                    // }
                                    Get.to(() => const NavBar());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
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
                                              padding:
                                                  const EdgeInsets.symmetric(),
                                              child: AppWidgets.regularText(
                                                text: AppStrings.login,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppWidgets.regularText(
                                      text: AppStrings.doNotHaveAnAccount,
                                      size: 18.0,
                                      color: AppColors.black,
                                      weight: FontWeight.w500,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Get.to(() => Registration());
                                      },
                                      child: AppWidgets.regularText(
                                        text: AppStrings.signUp,
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
                          )),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  textFiledView(
      {required String name,
      required String hintText,
      required String? Function(String? value) validator,
      required TextEditingController textEditingController,
      keyBoardType,
      context,
      required LoginController controller,
      required bool obscureText,
      required bool suffixIcon}) {
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
          filled: false,
          maxLines: 1,
          borderColor: AppColors.grey,
          textAlign: TextAlign.start,
          isUnderlinedBorder: true,
          fontColor: AppColors.black,
          hintText: hintText,
          validator: validator,
          keyBoardType: keyBoardType,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          borderFillColor: AppColors.yellow,
          hintFontColor: AppColors.grey.withOpacity(0.5),
          hintFontWeight: FontWeight.w400,
          suffixIcon: suffixIcon
              ? GestureDetector(
                  onTap: () {
                    controller.showPassword();
                  },
                  child: Image.asset(
                    obscureText ? AppIcons.hide : AppIcons.unHide,
                    scale: 20,
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
