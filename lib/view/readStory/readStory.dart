// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/read_story_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_app_bar.dart';

class ReadStory extends StatelessWidget {
  final String name;
  const ReadStory({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              title: name,
            ),
            body: GetBuilder<ReadStoryController>(
                init: ReadStoryController(),
                builder: (controller) {
                  return Column(
                    children: [
                      Expanded(
                        child: CupertinoScrollbar(
                          controller: controller.scrollController,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20, bottom: 20),
                            controller: controller.scrollController,
                            itemCount: controller.widgetList.length,
                            itemBuilder: (context, index) {
                              return controller.widgetList[index];
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}
