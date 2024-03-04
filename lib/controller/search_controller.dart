import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

class SearchStoryController extends GetxController {
  List<Story> searchList = [];

  bool isLoading = false;
  final scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });
  }
}
