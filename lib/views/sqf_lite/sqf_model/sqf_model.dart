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

class NonVerbalQuestion {
  final int? id;
  final String questionText;
  final List<String> imagePaths; // 4 images
  final List<String> imageNames; // 4 names
  final String? audioPath;

  NonVerbalQuestion({
    this.id,
    required this.questionText,
    required this.imagePaths,
    required this.imageNames,
    this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'imagePaths': imagePaths.join(','), // store as comma separated string
      'imageNames': imageNames.join(','),
      'audioPath': audioPath,
    };
  }

  factory NonVerbalQuestion.fromMap(Map<String, dynamic> map) {
    return NonVerbalQuestion(
      id: map['id'],
      questionText: map['questionText'],
      imagePaths: (map['imagePaths'] as String).split(','),
      imageNames: (map['imageNames'] as String).split(','),
      audioPath: map['audioPath'],
    );
  }
}

class VerbalQuestion {
  final int? id;
  final String questionText;
  final List<String> options;
  final String? audioPath;

  VerbalQuestion({
    this.id,
    required this.questionText,
    required this.options,
    this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options.join(','),
      'audioPath': audioPath,
    };
  }

  factory VerbalQuestion.fromMap(Map<String, dynamic> map) {
    return VerbalQuestion(
      id: map['id'],
      questionText: map['questionText'],
      options: (map['options'] as String).split(','),
      audioPath: map['audioPath'],
    );
  }
} 