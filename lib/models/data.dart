import 'quiz_model.dart';
import 'package:studypool/images/app_images.dart';

// Listening A Data
final List<Question> listeningAQuestions = [
  Question(
    questionText: "Which animal lives in the ocean?",
    options: ["A) Giraffe", "B) Dolphin", "C) Lion", "D) Elephant"],
    optionImages: [
      AppImages.Giraffe,
      AppImages.dolphin,
      AppImages.lion,
      AppImages.elephant,
    ],
    correctAnswer: "B) Dolphin",
    audioPath: "audio/listening1Audio1.mp3",
  ),
  Question(
    questionText: "Which animal is known for its spots and speed?",
    options: ["A) Cheetah", "B) Rhino", "C) Zebra", "D) Gorilla"],
    optionImages: [
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
    ],
    correctAnswer: "A) Cheetah",
    audioPath: "audio/listening1Audio2.mp3",
  ),
  Question(
    questionText: "Which animal has a long trunk?",
    options: ["A) Tiger", "B) Snake", "C) Elephant", "D) Crocodile"],
    optionImages: [
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
    ],
    correctAnswer: "C) Elephant",
    audioPath: "audio/listening1Audio3.mp3",
  ),
  Question(
    questionText: "Which animal is known for its colorful feathers?",
    options: ["A) Lion", "B) Wolf", "C) Bear", "D) Parrot"],
    optionImages: [
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
    ],
    correctAnswer: "D) Parrot",
    audioPath: "audio/listening1Audio4.mp3",
  ),
  Question(
    questionText: "Which animal lives in a hive and makes honey?",
    options: ["A) Spider", "B) Butterfly", "C) Ant", "D) Bee"],
    optionImages: [
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
      AppImages.Giraffe,
    ],
    correctAnswer: "D) Bee",
    audioPath: "audio/listening1Audio5.mp3",
  ),
];

// Listening B Data
final List<Question> listeningBQuestions = [
  Question(
    questionText: "Which sentence is grammatically correct?",
    options: [
      "A) He don't like to play football.",
      "B) He doesn't likes to play football.",
      "C) He doesn't like to play football.",
      "D) He not like to play football."
    ],
    optionImages: ["", "", "", ""],
    correctAnswer: "C) He doesn't like to play football.",
    audioPath: "audio/listeningbAudio1.mp3",
  ),
  Question(
    questionText: "Which sentence uses the correct past tense?",
    options: [
      "A) She go to school yesterday.",
      "B) She goes to school yesterday.",
      "C) She went to school yesterday.",
      "D) She going to school yesterday."
    ],
    optionImages: ["", "", "", ""],
    correctAnswer: "C) She went to school yesterday.",
    audioPath: "audio/listeningBAudio2.mp3",
  ),
  Question(
    questionText: "Which is a question?",
    options: [
      "A) Where are you going?",
      "B) I am going home.",
      "C) He is going home.",
      "D) They went home."
    ],
    optionImages: ["", "", "", ""],
    correctAnswer: "A) Where are you going?",
    audioPath: "audio/listeningBAudio3.mp3",
  ),
  Question(
    questionText: "Which sentence is negative?",
    options: [
      "A) She likes apples.",
      "B) She doesn't like apples.",
      "C) She eats apples.",
      "D) She has apples."
    ],
    optionImages: ["", "", "", ""],
    correctAnswer: "B) She doesn't like apples.",
    audioPath: "audio/listeningBAudio4.mp3",
  ),
  Question(
    questionText: "Which is a correct plural form?",
    options: [
      "A) Childs",
      "B) Childes",
      "C) Children",
      "D) Childrens"
    ],
    optionImages: ["", "", "", ""],
    correctAnswer: "C) Children",
    audioPath: "audio/listeningBAudio5.mp3",
  ),
];

// Listening C Data
final List<TrueFalseQuestion> listeningCQuestions = [
  TrueFalseQuestion(
    questionText: "Rebecca's Family Farmed The Land To Provide Food For Their Animals.",
    correctAnswer: true,
    audioPath: "audio/listeningCAudio1.mp3",
  ),
  TrueFalseQuestion(
    questionText: "Rebecca's Teacher Thought That It Hardly Rained Because Of Climate Change.",
    correctAnswer: false,
    audioPath: "audio/listeningCAudio2.mp3",
  ),
  TrueFalseQuestion(
    questionText: "Rebecca's Family Farmed The Land To Provide Food For Their Animals.",
    correctAnswer: false,
    audioPath: "audio/listeningCAudio3.mp3",
  ),
  TrueFalseQuestion(
    questionText: "James's family raised crops on their farm to feed their livestock.",
    correctAnswer: true,
    audioPath: "audio/listeningCAudio4.mp3",
  ),
  TrueFalseQuestion(
    questionText: "Rebecca's Teacher Thought That It Hardly Rained Because Of Climate Change.",
    correctAnswer: true,
    audioPath: "audio/listeningCAudio5.mp3",
  ),
];

// Listening D Data
final List<FillBlankQuestion> listeningDQuestions = [
  FillBlankQuestion(
    beforeBlank: "Tom's Talking About His Recent Visit To A ",
    afterBlank: " With His Classmates.",
    correctAnswer: "Museum",
    audioPath: "audio/listeningDAudio1.mp3",
  ),
  FillBlankQuestion(
    beforeBlank: "The Development Of Technology Have Certainmmnly ",
    afterBlank: " How Families",
    correctAnswer: "Changed",
    audioPath: "audio/listeningDAudio2.mp3",
  ),
  FillBlankQuestion(
    beforeBlank: "The Development Of Technology Have Certainmmnly ",
    afterBlank: " How Families",
    correctAnswer: "Affected",
    audioPath: "audio/listening1Audio3.mp3",
  ),
  FillBlankQuestion(
    beforeBlank: "Tom And His Classmates Were Divided In ",
    afterBlank: " Toin The Workshop.",
    correctAnswer: "Groups",
    audioPath: "audio/listening1Audio4.mp3",
  ),
  FillBlankQuestion(
    beforeBlank: "The Development Of Technology Have Certainmmnly ",
    afterBlank: " How Families",
    correctAnswer: "Transformed",
    audioPath: "audio/listening1Audio5.mp3",
  ),
]; 