enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String text;

  Block({required this.id, required this.type, required this.text});

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type.toString(), 'text': text};
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
        id: json['id'],
        type: json['type'] == 'BlockType.story'
            ? BlockType.story
            : BlockType.choice,
        text: json['text']);
  }

  void updateText(String text) {
    this.text = text;
  }
}
