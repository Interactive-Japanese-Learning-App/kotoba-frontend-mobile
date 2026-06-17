class QuizSection {
  final String id;
  final String title;
  final String description;
  final int order;
  final String color;
  final bool isActive;

  QuizSection({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.color,
    required this.isActive,
  });

  factory QuizSection.fromJson(
    Map<String, dynamic> json,
  ) {
    return QuizSection(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      order: json["order"] ?? 0,
      color: json["color"] ?? "#C1121F",
      isActive: json["isActive"] ?? true,
    );
  }
}