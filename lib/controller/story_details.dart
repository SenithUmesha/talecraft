import 'package:get/get.dart';

import '../model/Story.dart';

class StoryDetailsController extends GetxController {
  List<Story> storyList = [
    Story(
        id: 1,
        name: "The Adventure Ends",
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

  void updateIsBookmarked(Story story) {
    story.isBookmarked = !(story.isBookmarked ?? false);
    update();
  }
}
