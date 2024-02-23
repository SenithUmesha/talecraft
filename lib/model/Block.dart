import 'dart:math';

enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String text;
  bool? isPicked;

  Block(
      {required this.id,
      required this.type,
      required this.text,
      this.isPicked});

  Map<String, dynamic> toJson() {
    return type == BlockType.choice
        ? {'id': id, 'type': type.toString(), 'text': text, 'isPicked': false}
        : {'id': id, 'type': type.toString(), 'text': text};
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    int generatedId = Block.getId();
    return json['type'] == 'BlockType.choice'
        ? Block(
            id: json['id'] == 0 ? 0 : generatedId,
            type: BlockType.choice,
            text: json['text'])
        : Block(
            id: json['id'] == 0 ? 0 : generatedId,
            type: BlockType.story,
            text: json['text'],
            isPicked: json['is_picked'] == null ? false : json['is_picked']);
  }

  void updateText(String text) {
    this.text = text;
  }

  void updateChoice(bool choice) {
    this.isPicked = choice;
  }

  static int getId() {
    int timestampInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int randomSixDigitNumber = Random().nextInt(900000) + 100000;
    int id = timestampInSeconds * 1000000 + randomSixDigitNumber;
    return id;
  }
}
