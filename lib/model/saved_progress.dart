class SavedProgress {
  String? id;
  List<int>? pickedChoices;
  bool? isCompleted;
  bool? achievementDone;

  SavedProgress(
      {this.id, this.pickedChoices, this.isCompleted, this.achievementDone});

  factory SavedProgress.fromJson(Map<String, dynamic> json) {
    return SavedProgress(
        id: json['id'] ?? "",
        pickedChoices: List<int>.from(json['picked_choices'] ?? []),
        isCompleted: json['is_completed'] ?? false,
        achievementDone: json['achievement_done'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'picked_choices': pickedChoices,
      'is_completed': isCompleted,
      'achievement_done': achievementDone
    };
  }
}
