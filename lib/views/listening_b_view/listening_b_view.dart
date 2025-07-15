import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/views/listening_a_view/listening_a_view.dart';

class ListeningBView extends StatefulWidget {
  const ListeningBView({super.key});

  @override
  State<ListeningBView> createState() => _ListeningBViewState();
}

class _ListeningBViewState extends State<ListeningBView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final List<Map<String, String>> _userAnswers = [];

  // List of questions (no images)
  final List<Question> _questions = [
    Question(
      questionText: "Which sentence is grammatically correct?",
      options: [
        "A) He don't like to play football.",
        "B) He doesn't likes to play football.",
        "C) He doesn't like to play football.",
        "D) He not like to play football."
      ],
      optionImages: ["", "", "", ""], // Not used
      correctAnswer: "C) He doesn't like to play football.",
      audioPath: "audio/listening1Audio1.mp3",
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
      audioPath: "audio/listening1Audio2.mp3",
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
      audioPath: "audio/listening1Audio3.mp3",
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
      audioPath: "audio/listening1Audio4.mp3",
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
      audioPath: "audio/listening1Audio5.mp3",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _playAudio(_questions[_currentQuestionIndex].audioPath);
  }

  void _playAudio(String audioPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to play audio: $audioPath. Try WAV format or check file encoding.",
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _selectOption(String option) {
    setState(() {
      _selectedAnswer = option;
      if (_userAnswers.length > _currentQuestionIndex) {
        _userAnswers[_currentQuestionIndex] = {
          'userAnswer': option,
          'correctAnswer': _questions[_currentQuestionIndex].correctAnswer,
        };
      } else {
        _userAnswers.add({
          'userAnswer': option,
          'correctAnswer': _questions[_currentQuestionIndex].correctAnswer,
        });
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _playAudio(_questions[_currentQuestionIndex].audioPath);
      });
    } else {
      _audioPlayer.stop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailView(
            userAnswers: _userAnswers,
            questions: _questions,
          ),
        ),
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = _userAnswers.length > _currentQuestionIndex
            ? _userAnswers[_currentQuestionIndex]['userAnswer']
            : null;
        _playAudio(_questions[_currentQuestionIndex].audioPath);
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final currentQuestion = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GreenText(
          text: "Listening B",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02,vertical: screenHeight*.05),
        child: Column(
          children: [
            Center(
              child: GreenText(
                text: currentQuestion.questionText,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ...List.generate(4, (index) {
              final option = currentQuestion.options[index];
              final isSelected = _selectedAnswer == option;
              return Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: GestureDetector(
                  onTap: () => _selectOption(option),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.025),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GreenText(
                      text: option,
                      textColor: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: _currentQuestionIndex > 0 ? Colors.black : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedAnswer != null ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswer != null ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: GreenText(
                    text: isLastQuestion ? "Finish" : "Next",
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}