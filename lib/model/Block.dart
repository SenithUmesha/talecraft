enum BlockType { story, choice }

class Block {
  int id;
  BlockType type;
  String shortDescription;
  String text;
  bool oneOut;
  bool multiIn;

  Block({
    required this.id,
    required this.type,
    required this.shortDescription,
    required this.text,
    required this.oneOut,
    required this.multiIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'shortDescription': shortDescription,
      'text': text,
      'oneOut': oneOut,
      'multiIn': multiIn,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] as int,
      type: json['type'] == 'BlockType.story'
          ? BlockType.story
          : BlockType.choice,
      shortDescription: json['shortDescription'] as String,
      text: json['text'] as String,
      oneOut: json['oneOut'] as bool,
      multiIn: json['multiIn'] as bool,
    );
  }

  void updateText(String shortDescription, String text) {
    this.shortDescription = shortDescription;
    this.text = text;
  }
}
