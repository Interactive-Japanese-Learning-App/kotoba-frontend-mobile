class QuizResultModel {
  final int xpGained;
  final int totalXp;
  final int level;

  QuizResultModel({
    required this.xpGained,
    required this.totalXp,
    required this.level,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      xpGained: json["xpGained"] ?? 0,
      totalXp: json["totalXp"] ?? 0,
      level: json["level"] ?? 1,
    );
  }
}
