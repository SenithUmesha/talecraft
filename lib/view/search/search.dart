import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/search_controller.dart';
import 'package:talecraft/utils/validator.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/custom_app_bar.dart';
import '../home/home.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.search,
        cantGoBack: true,
      ),
      body: GetBuilder<SearchStoryController>(
          init: SearchStoryController(),
          builder: (controller) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 0, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.searchController,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: AppColors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: AppColors.black, width: 1)),
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
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            validator: validateSearch,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.025,
                        ),
                        IconButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
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
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CupertinoScrollbar(
                          controller: controller.scrollController,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 30, top: 10),
                            controller: controller.scrollController,
                            itemCount: controller.searchList.length,
                            itemBuilder: (context, index) {
                              return Home.getStoryItem(
                                  height, width, controller.searchList[index]);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
