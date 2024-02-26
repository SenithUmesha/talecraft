import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/controller/listen_story_controller.dart';

import '../../utils/custom_app_bar.dart';

class ListenStory extends StatelessWidget {
  final String name;
  const ListenStory({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: name,
      ),
      body: GetBuilder<ListenStoryController>(
          init: ListenStoryController(),
          builder: (controller) {
            return Container();
          }),
    );
  }
}
