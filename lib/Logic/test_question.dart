class TestQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;

  TestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory TestQuestion.fromMap(Map<String, dynamic> map) {
    return TestQuestion(
      id: map['id'],
      question: map['question'],
      options: (map['options'] as String).split('|'),
      correctIndex: map['correctIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options.join('|'),
      'correctIndex': correctIndex,
    };
  }
}
