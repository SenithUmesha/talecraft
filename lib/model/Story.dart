class Story {
  int? id;
  String? name;
  int? authorId;
  String? authorName;
  String? description;
  String? readTime;
  double? rating;
  String? image;
  List<String>? genres;
  bool? isBookmarked;
  int? achievementEndingId;
  Map<String, dynamic>? storyJson;

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
      this.isBookmarked,
      this.achievementEndingId,
      this.storyJson});

  factory Story.fromJson(Map<String, dynamic> json) => new Story(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      authorId: json["author_id"] ?? "",
      authorName: json["author_name"] ?? "",
      description: json["description"] ?? "",
      readTime: json["read_time"] ?? "0 min",
      rating: json["rating"].toDouble() ?? 0.0,
      image: json["image"] ?? "",
      genres: json["genres"] != null ? List<String>.from(json["genres"]) : [],
      isBookmarked: json["is_bookmarked"] ?? false,
      achievementEndingId: json["achievement_ending_id"] ?? 0,
      storyJson: json["story_json"] ?? {});

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
        "is_bookmarked": isBookmarked,
        "achievement_ending_id": achievementEndingId,
        "story_json": storyJson
      };
}
