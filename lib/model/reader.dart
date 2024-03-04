import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Reader.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Reader(
      uid: data['uid'] ?? "",
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      readingStories: List<SavedProgress>.from(data['readingStories'] ?? []),
      readStories: List<String>.from(data['readStories'] ?? []),
      bookmarkedStories: List<String>.from(data['bookmarkedStories'] ?? []),
      publishedStories: List<String>.from(data['publishedStories'] ?? []),
      achievementStories: List<String>.from(data['achievementStories'] ?? []),
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
