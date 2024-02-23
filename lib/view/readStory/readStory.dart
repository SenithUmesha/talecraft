// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/read_story_controller.dart';
import '../../model/Story.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_widgets.dart';
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
            appBar: CustomAppBar(
              title: story.name,
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
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return AppWidgets.regularText(
                                  text:
                                      "          Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
                                  size: 17.0,
                                  alignment: TextAlign.justify,
                                  color: AppColors.black,
                                  weight: FontWeight.w500,
                                  height: 2.0);
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
