// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/read_story_controller.dart';
import '../../model/Story.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_app_bar.dart';

class ReadStory extends StatelessWidget {
  final Story story;
  const ReadStory({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: const CustomAppBar(),
            body: GetBuilder<ReadStoryController>(
                init: ReadStoryController(),
                builder: (controller) {
                  return Column(
                    children: [],
                  );
                }),
          ),
        ));
  }
}
