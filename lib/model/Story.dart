class Story {
  int? id;
  String? name;
  String? author;
  String? description;
  String? readTime;
  double? rating;
  String? image;
  List<String>? genres;
  bool? isBookmarked;

  Story(
      {this.id,
      this.name,
      this.author,
      this.description,
      this.readTime,
      this.rating,
      this.image,
      this.genres,
      this.isBookmarked});

  factory Story.fromJson(Map<String, dynamic> json) => new Story(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      author: json["author"] ?? "",
      description: json["description"] ?? "",
      readTime: json["read_time"] ?? "",
      rating: json["rating"].toDouble() ?? 0.0,
      image: json["image"] ?? "",
      genres: json["genres"] != null ? List<String>.from(json["genres"]) : [],
      isBookmarked: json["is_bookmarked"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author": author,
        "description": description,
        "read_time": readTime,
        "rating": rating,
        "image": image,
        "genres": genres,
        "is_bookmarked": isBookmarked
      };
}
