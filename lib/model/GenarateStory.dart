class GenarateStory {
  String? id;
  String? object;
  int? created;
  String? model;
  List<Choice>? choices;
  Usage? usage;
  String? systemFingerprint;

  GenarateStory({
    this.id,
    this.object,
    this.created,
    this.model,
    this.choices,
    this.usage,
    this.systemFingerprint,
  });

  factory GenarateStory.fromJson(Map<String, dynamic> json) =>
      new GenarateStory(
        id: json["id"] ?? "",
        object: json["object"] ?? "",
        created: json["created"] ?? 0,
        model: json["model"] ?? "",
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        usage: Usage.fromJson(json["usage"]),
        systemFingerprint: json["system_fingerprint"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "choices": new List<dynamic>.from(choices!.map((x) => x.toJson())),
        "usage": usage!.toJson(),
        "system_fingerprint": systemFingerprint,
      };
}

class Choice {
  Choice();

  factory Choice.fromJson(Map<String, dynamic> json) => new Choice();

  Map<String, dynamic> toJson() => {};
}

class Usage {
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  Usage({
    this.promptTokens,
    this.completionTokens,
    this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => new Usage(
        promptTokens: json["prompt_tokens"] ?? 0,
        completionTokens: json["completion_tokens"] ?? 0,
        totalTokens: json["total_tokens"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}
