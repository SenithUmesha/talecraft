enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String? shortDescription;
  String text;

  Block(
      {required this.id,
      required this.type,
      this.shortDescription,
      required this.text});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'shortDescription': shortDescription ?? "",
      'text': text
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        id: json['id'],
        type: json['type'] == 'BlockType.story'
            ? BlockType.story
            : BlockType.choice,
        shortDescription: json['shortDescription'] ?? "",
        text: json['text']);
  }

  void updateText(String shortDescription, String text) {
    this.shortDescription = shortDescription;
    this.text = text;
  }
}
