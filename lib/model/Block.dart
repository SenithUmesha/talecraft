enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String shortDescription;
  String text;

  Block(
      {required this.id,
      required this.type,
      required this.shortDescription,
      required this.text});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'shortDescription': shortDescription,
      'text': text
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        id: json['id'] as int,
        type: json['type'] == 'BlockType.story'
            ? BlockType.story
            : BlockType.choice,
        shortDescription: json['shortDescription'] as String,
        text: json['text'] as String);
  }

  void updateText(String shortDescription, String text) {
    this.shortDescription = shortDescription;
    this.text = text;
  }
}
