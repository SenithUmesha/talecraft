class Story {
  int? id;
  String? name;
  String? author;
  String? description;
  String? readTime;
  double? rating;
  String? image;

  Story({
    this.id,
    this.name,
    this.author,
    this.description,
    this.readTime,
    this.rating,
    this.image,
  });

  factory Story.fromJson(Map<String, dynamic> json) => new Story(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        author: json["author"] ?? "",
        description: json["description"] ?? "",
        readTime: json["read_time"] ?? "",
        rating: json["rating"].toDouble() ?? 0.0,
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author": author,
        "description": description,
        "read_time": readTime,
        "rating": rating,
        "image": image,
      };
}
