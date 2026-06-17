class QuizQuestion {
  final String id;
  final int questionNo;
  final String type;
  final String question;
  final String answer;
  final List<String> options;

  QuizQuestion({
    required this.id,
    required this.questionNo,
    required this.type,
    required this.question,
    required this.answer,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['_id'],
      questionNo: json['questionNo'],
      type: json['type'],
      question: json['question'],
      answer: json['answer'],
      options: List<String>.from(json['options'] ?? []),
    );
  }
}
