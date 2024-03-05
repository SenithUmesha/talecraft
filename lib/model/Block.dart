import 'dart:math';

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
        type: json['type'] == 'BlockType.choice'
            ? BlockType.choice
            : BlockType.story,
        text: json['text']);
  }

  factory Block.fromJsonAssignId(Map<String, dynamic> json) {
    int generatedId = Block.getId();
    return Block(
        id: json['id'] == 0 ? 0 : generatedId,
        type: json['type'] == 'BlockType.choice'
            ? BlockType.choice
            : BlockType.story,
        text: json['text']);
  }

  void updateText(String text) {
    this.text = text;
  }

  static int getId() {
    int timestampInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int randomSixDigitNumber = Random().nextInt(900000) + 100000;
    int id = timestampInSeconds * 1000000 + randomSixDigitNumber;
    return id;
  }
}
