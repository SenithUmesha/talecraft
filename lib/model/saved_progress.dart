class SavedProgress {
  String? id;
  List<int>? pickedChoices;

  SavedProgress({
    this.id,
    this.pickedChoices,
  });

  factory SavedProgress.fromJson(Map<String, dynamic> json) {
    return SavedProgress(
      id: json['id'] ?? "",
      pickedChoices: List<int>.from(json['pickedChoices'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickedChoices': pickedChoices,
    };
  }
}
