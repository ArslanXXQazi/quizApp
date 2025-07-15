import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/images/app_images.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/models/data.dart';

// Question model to hold question data
// class Question {
//   final String questionText;
//   final List<String> options;
//   final List<String> optionImages;
//   final String correctAnswer;
//   final String audioPath;

//   Question({
//     required this.questionText,
//     required this.options,
//     required this.optionImages,
//     required this.correctAnswer,
//     required this.audioPath,
//   });
// }

class ListeningAView extends StatefulWidget {
  const ListeningAView({super.key});

  @override
  State<ListeningAView> createState() => _ListeningAViewState();
}

class _ListeningAViewState extends State<ListeningAView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  final List<Map<String, String>> _userAnswers = []; // To store user answers

  // List of questions
  final List<Question> _questions = listeningAQuestions;

  @override
  void initState() {
    super.initState();
    _playAudio(_questions[_currentQuestionIndex].audioPath);
  }

  // Play audio for the current question with enhanced error handling
  void _playAudio(String audioPath) async {
    try {
      await _audioPlayer.stop(); // Stop any previous audio
      await _audioPlayer.play(AssetSource(audioPath));
      print("Playing audio: $audioPath");
    } catch (e) {
      print("Error playing audio: $e");
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

  // Handle option selection
  void _selectOption(String option) {
    setState(() {
      _selectedAnswer = option;
      // Store the user's answer for the current question
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

  // Navigate to the next question or show results
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _playAudio(_questions[_currentQuestionIndex].audioPath);
      });
    } else {
      // Stop audio before navigating to DetailView
      _audioPlayer.stop();
      // Navigate to DetailView with results
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

  // Navigate to the previous question
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
          text: "Listening A",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        child: Column(
          children: [
            Center(
              child: GreenText(
                text: currentQuestion.questionText,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.2,
                          child: Image.asset(
                            currentQuestion.optionImages[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*.005,),
                      GreenText(
                        text: currentQuestion.options[0],
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.2,
                          child: Image.asset(
                            currentQuestion.optionImages[1],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*.005,),
                      GreenText(
                        text: currentQuestion.options[1],
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.2,
                          child: Image.asset(
                            currentQuestion.optionImages[2],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*.005,),
                      GreenText(
                        text: currentQuestion.options[2],
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: screenHeight * 0.2,
                          child: Image.asset(
                            currentQuestion.optionImages[3],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*.005,),
                      GreenText(
                        text: currentQuestion.options[3],
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: List.generate(4, (index) {
                final option = currentQuestion.options[index];
                final isSelected = _selectedAnswer == option;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _selectOption(option),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        color: isSelected ? Colors.green : Colors.white,
                      ),
                      child: Center(
                        child: GreenText(
                          text: option[0], // Display only the option letter (A, B, C, D)
                          textColor: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
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