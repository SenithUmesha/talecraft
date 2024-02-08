import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/search_controller.dart';
import 'package:talecraft/utils/validator.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_widgets.dart';
import '../home/home.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: SafeArea(
          child: Scaffold(
        body: GetBuilder<SearchStoryController>(
            init: SearchStoryController(),
            builder: (controller) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 0, left: 15, right: 15),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: AppWidgets.regularText(
                                text: AppStrings.search,
                                size: 20.0,
                                color: AppColors.black,
                                weight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.searchController,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.black,
                                              width: 1)),
                                      hintText: AppStrings.search,
                                      hintStyle: TextStyle(
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                    validator: validateSearch,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.025,
                                ),
                                IconButton(
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: AppColors.black,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: CupertinoScrollbar(
                                  controller: controller.scrollController,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.only(bottom: 30, top: 10),
                                    controller: controller.scrollController,
                                    itemCount: controller.searchList.length,
                                    itemBuilder: (context, index) {
                                      return Home.getStoryItem(height, width,
                                          controller.searchList[index]);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      )),
    );
  }

  textFieldView(
      {required String name,
      required String hintText,
      required String? Function(String? value) validator,
      required TextEditingController textEditingController,
      keyBoardType,
      context,
      required SearchStoryController controller,
      required bool obscureText,
      required bool suffixIcon,
      required int index,
      helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          suffixIcon: suffixIcon ? const SizedBox() : const SizedBox(),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
