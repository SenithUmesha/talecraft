import 'package:talecraft/model/saved_progress.dart';

class Reader {
  String? uid;
  String? name;
  String? email;
  List<SavedProgress>? readingStories;
  List<String>? readStories;
  List<String>? bookmarkedStories;
  List<String>? publishedStories;
  List<String>? achievementStories;

  Reader({
    this.uid,
    this.name,
    this.email,
    this.readingStories,
    this.readStories,
    this.bookmarkedStories,
    this.publishedStories,
    this.achievementStories,
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      uid: json['uid'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      readingStories: List<SavedProgress>.from(json['readingStories'] ?? []),
      readStories: List<String>.from(json['readStories'] ?? []),
      bookmarkedStories: List<String>.from(json['bookmarkedStories'] ?? []),
      publishedStories: List<String>.from(json['publishedStories'] ?? []),
      achievementStories: List<String>.from(json['achievementStories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'readingStories': readingStories,
      'readStories': readStories,
      'bookmarkedStories': bookmarkedStories,
      'publishedStories': publishedStories,
      'achievementStories': achievementStories,
    };
  }
}
