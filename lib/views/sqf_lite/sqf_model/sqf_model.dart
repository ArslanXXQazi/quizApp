// SQFLite models yahan define hain

class Question {
  final String questionText;
  final List<String> options;
  final List<String> optionImages;
  final String correctAnswer;
  final String audioPath;

  Question({
    required this.questionText,
    required this.options,
    required this.optionImages,
    required this.correctAnswer,
    required this.audioPath,
  });
}

class FillBlankQuestion {
  final String beforeBlank;
  final String afterBlank;
  final String correctAnswer;
  final String audioPath;
  FillBlankQuestion({
    required this.beforeBlank,
    required this.afterBlank,
    required this.correctAnswer,
    required this.audioPath,
  });
}

class TrueFalseQuestion {
  final String questionText;
  final bool correctAnswer;
  final String audioPath;
  TrueFalseQuestion({
    required this.questionText,
    required this.correctAnswer,
    required this.audioPath,
  });
} 