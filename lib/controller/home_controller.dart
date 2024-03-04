import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talecraft/model/story.dart';

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
        achievementEndingId: 7,
        storyJson: {
          "id": 0,
          "type": "BlockType.story",
          "text": "What should the knight do next?",
          "nextList": [
            {
              "id": 1,
              "type": "BlockType.choice",
              "text": "Press on through the desert",
              "nextList": [
                {
                  "id": 3,
                  "type": "BlockType.story",
                  "text": "What should he do now?",
                  "nextList": [
                    {
                      "id": 7,
                      "type": "BlockType.choice",
                      "text": "Confront the sorcerer immediately",
                      "nextList": [
                        {
                          "id": 9,
                          "type": "BlockType.story",
                          "text": "The princess was safe at last.",
                          "nextList": []
                        }
                      ]
                    },
                    {
                      "id": 8,
                      "type": "BlockType.choice",
                      "text": "Wait and devise a plan",
                      "nextList": [
                        {
                          "id": 10,
                          "type": "BlockType.story",
                          "text":
                              "The knight chose to bide his time and come up with a strategy to outwit the sorcerer.",
                          "nextList": []
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "id": 2,
              "type": "BlockType.choice",
              "text": "Look for an alternative route",
              "nextList": [
                {
                  "id": 4,
                  "type": "BlockType.story",
                  "text":
                      "The knight decided to search for an alternative route through the desert, hoping to avoid the harsh conditions and potential dangers. After exploring for a while, he stumbled upon a hidden oasis where he could rest and replenish his supplies. Feeling refreshed, he continued his journey towards the sorcerer's lair. What should he do next?",
                  "nextList": [
                    {
                      "id": 11,
                      "type": "BlockType.choice",
                      "text":
                          "Approach the sorcerer's lair from the rear entrance",
                      "nextList": [
                        {
                          "id": 12,
                          "type": "BlockType.story",
                          "text":
                              "The knight snuck around to the rear entrance of the sorcerer's lair, avoiding detection. He found the princess locked in a tower, guarded by magical beasts. With skill and bravery, he faced the creatures and defeated them, freeing the princess. Together, they made their way back to the kingdom, where they were hailed as heroes. The princess was safe at last.",
                          "nextList": []
                        }
                      ]
                    },
                    {
                      "id": 1,
                      "type": "BlockType.choice",
                      "text":
                          "Continue towards the front entrance of the sorcerer's lair",
                      "nextList": [
                        {
                          "id": 2,
                          "type": "BlockType.story",
                          "text":
                              "The knight decided to approach the sorcerer's lair from the front entrance, braving the challenges that lay in wait. As he entered, he was met with traps and guardians set by the sorcerer. With quick thinking and sword skills, he overcame each obstacle until he reached the princess. Together, they made their way back to the kingdom, where they were hailed as heroes. The princess was safe at last.",
                          "nextList": []
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }),
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
