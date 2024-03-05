import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  String? id;
  String? name;
  String? authorId;
  String? authorName;
  String? description;
  String? readTime;
  double? rating;
  int? noOfRatings;
  String? image;
  List<String>? genres;
  int? achievementEndingId;
  Map<String, dynamic>? storyJson;
  DateTime? createdAt;

  Story(
      {this.id,
      this.name,
      this.authorId,
      this.authorName,
      this.description,
      this.readTime,
      this.rating,
      this.noOfRatings,
      this.image,
      this.genres,
      this.achievementEndingId,
      this.storyJson,
      this.createdAt});

  factory Story.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Story(
        id: data["id"] ?? "",
        name: data["name"] ?? "",
        authorId: data["author_id"] ?? "",
        authorName: data["author_name"] ?? "",
        description: data["description"] ?? "",
        readTime: data["read_time"] ?? "0 min",
        rating: data["rating"].toDouble() ?? 0.0,
        noOfRatings: data["no_of_ratings"] ?? 0,
        image: data["image"] ?? "",
        genres: data["genres"] != null ? List<String>.from(data["genres"]) : [],
        achievementEndingId: data["achievement_ending_id"] ?? 0,
        storyJson: data["story_json"] ?? {},
        createdAt: data["created_at"].toDate() ?? DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author_id": authorId,
        "author_name": authorName,
        "description": description,
        "read_time": readTime,
        "rating": rating,
        "no_of_ratings": noOfRatings,
        "image": image,
        "genres": genres,
        "achievement_ending_id": achievementEndingId,
        "story_json": storyJson,
        "created_at": createdAt
      };
}
