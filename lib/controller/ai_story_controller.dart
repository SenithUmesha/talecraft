import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/Block.dart';

class AiStoryController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController contextController = TextEditingController();
  late GraphNode<Block> root;

  @override
  void onInit() {
    super.onInit();

    root = GraphNode<Block>(
      data: Block(id: 0, type: BlockType.story, shortDescription: '', text: ''),
      isRoot: true,
    );
  }
}
