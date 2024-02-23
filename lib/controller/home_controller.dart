import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/Story.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  final scrollController = ScrollController();
  List<String> genreList = [
    'Action',
    'Adventure',
    'Sci-Fi',
    'Drama',
    'Comedy',
    'Thriller'
  ];
  List<Story> storyList = [
    Story(
        id: 0,
        name: "The Adventure Ends",
        authorId: 0,
        authorName: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action"],
        isBookmarked: false,
        achievementEndingId: 0,
        storyJson: {}),
  ];

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });
  }
}
