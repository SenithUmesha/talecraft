import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/Story.dart';

class BookmarksController extends GetxController {
  List<Story> bookmarksList = [
    Story(
        id: 1,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action"],
        isBookmarked: false),
    Story(
        id: 2,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action", "Sci-Fi", "Drama", "Comedy"],
        isBookmarked: true),
    Story(
        id: 3,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action", "Sci-Fi", "Drama", "Comedy"],
        isBookmarked: true),
    Story(
        id: 4,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action", "Sci-Fi", "Drama", "Comedy"],
        isBookmarked: true),
    Story(
        id: 5,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action", "Sci-Fi", "Drama", "Comedy"],
        isBookmarked: true),
    Story(
        id: 6,
        name: "The Adventure Begins",
        author: "John Doe",
        description:
            "Follow the thrilling adventure of our hero as they embark on a journey into the unknown.",
        readTime: "30 min",
        rating: 4.5,
        image:
            "https://edit.org/img/blog/xk5-1024-free-ebook-cover-templates-download-online.webp",
        genres: ["Fiction", "Action", "Sci-Fi", "Drama", "Comedy"],
        isBookmarked: true),
  ];

  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });
  }
}
