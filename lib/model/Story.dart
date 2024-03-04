class Story {
  String? id;
  String? name;
  String? authorId;
  String? authorName;
  String? description;
  String? readTime;
  double? rating;
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
      this.image,
      this.genres,
      this.achievementEndingId,
      this.storyJson,
      this.createdAt});

  factory Story.fromJson(Map<String, dynamic> json) => new Story(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      authorId: json["author_id"] ?? "",
      authorName: json["author_name"] ?? "",
      description: json["description"] ?? "",
      readTime: json["read_time"] ?? "0 min",
      rating: json["rating"].toDouble() ?? 0.0,
      image: json["image"] ?? "",
      genres: json["genres"] != null ? List<String>.from(json["genres"]) : [],
      achievementEndingId: json["achievement_ending_id"] ?? 0,
      storyJson: json["story_json"] ?? {},
      createdAt: json["created_at"] ?? DateTime.now());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author_id": authorId,
        "author_name": authorName,
        "description": description,
        "read_time": readTime,
        "rating": rating,
        "image": image,
        "genres": genres,
        "achievement_ending_id": achievementEndingId,
        "story_json": storyJson,
        "created_at": createdAt
      };
}
