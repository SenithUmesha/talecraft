import 'package:cloud_firestore/cloud_firestore.dart';

class Reader {
  String? uid;
  String? name;
  String? email;
  List<String>? bookmarkedStories;
  List<String>? publishedStories;

  Reader({
    this.uid,
    this.name,
    this.email,
    this.bookmarkedStories,
    this.publishedStories,
  });

  factory Reader.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Reader(
      uid: data['uid'] ?? "",
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      bookmarkedStories: List<String>.from(data['bookmarkedStories'] ?? []),
      publishedStories: List<String>.from(data['publishedStories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bookmarkedStories': bookmarkedStories,
      'publishedStories': publishedStories,
    };
  }
}
