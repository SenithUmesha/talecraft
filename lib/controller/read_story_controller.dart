import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/Story.dart';

import '../model/Block.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class ReadStoryController extends GetxController {
  final scrollController = ScrollController();
  List<Widget> widgetList = [];
  late GraphNode<Block> root;
  late Story story;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, text: AppStrings.addStory),
      isRoot: true,
    );

    story = Get.arguments[0];
    jsonToGraph(root, story.storyJson!);
    addStoryBlock(root);
  }

  void jsonToGraph(GraphNode<Block> block, Map<String, dynamic> json) {
    block.data = Block.fromJson(json);

    if (json.containsKey('nextList')) {
      var nextListJson = json['nextList'] as List<dynamic>;
      for (var nextNodeJson in nextListJson) {
        var nextNode = GraphNode<Block>();
        jsonToGraph(nextNode, nextNodeJson as Map<String, dynamic>);
        block.addNext(nextNode);
      }
    }
  }

  void addStoryBlock(GraphNode<Block> block) {
    widgetList.add(AppWidgets.regularText(
        text: "          ${block.data!.text}",
        size: 17.0,
        alignment: TextAlign.justify,
        color: AppColors.black,
        weight: FontWeight.w500,
        height: 2.0));

    addChoiceBlock(block.nextList);
  }

  void addChoiceBlock(List<GraphNode> nextList) {
    var width = MediaQuery.of(Get.context!).size.width;
    widgetList.add(
      Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.black.withOpacity(0.2),
        ),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          itemCount: nextList.length,
          itemBuilder: (context, index) {
            return Container(
              width: width,
              height: width * 0.14,
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.black,
              ),
              child: Center(
                child: AppWidgets.regularText(
                  text: (nextList[index].data as Block).text,
                  size: 16,
                  color: AppColors.white,
                  weight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );

    update();
  }
}
