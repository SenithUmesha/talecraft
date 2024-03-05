class SavedProgress {
  String? id;
  List<int>? pickedChoices;
  bool? isCompleted;

  SavedProgress({this.id, this.pickedChoices, this.isCompleted});

  factory SavedProgress.fromJson(Map<String, dynamic> json) {
    return SavedProgress(
        id: json['id'] ?? "",
        pickedChoices: List<int>.from(json['picked_choices'] ?? []),
        isCompleted: json['is_completed'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'picked_choices': pickedChoices,
      'is_completed': isCompleted
    };
  }
}
