import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/models/data.dart';

class ListeningCView extends StatefulWidget {
  const ListeningCView({super.key});

  @override
  State<ListeningCView> createState() => _ListeningCViewState();
}

class _ListeningCViewState extends State<ListeningCView>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentQuestionIndex = 0;
  bool? _selectedAnswer;
  final List<Map<String, String>> _userAnswers = [];

  final List<TrueFalseQuestion> _questions = listeningCQuestions;

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
      // ignore audio error for now
    }
  }

  void _selectOption(bool value) {
    setState(() {
      _selectedAnswer = value;
      if (_userAnswers.length > _currentQuestionIndex) {
        _userAnswers[_currentQuestionIndex] = {
          'userAnswer': value ? 'T' : 'F',
          'correctAnswer': _questions[_currentQuestionIndex].correctAnswer ? 'T' : 'F',
        };
      } else {
        _userAnswers.add({
          'userAnswer': value ? 'T' : 'F',
          'correctAnswer': _questions[_currentQuestionIndex].correctAnswer ? 'T' : 'F',
        });
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = _userAnswers.length > _currentQuestionIndex
            ? _userAnswers[_currentQuestionIndex]['userAnswer'] == 'T'
            : null;
        _playAudio(_questions[_currentQuestionIndex].audioPath);
      });
    } else {
      _audioPlayer.stop();
      // Convert TrueFalseQuestion to Question for DetailView
      final List<Question> detailQuestions = _questions.map((q) => Question(
        questionText: q.questionText,
        options: ['T', 'F'],
        optionImages: ['', ''],
        correctAnswer: q.correctAnswer ? 'T' : 'F',
        audioPath: q.audioPath,
      )).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailView(
            userAnswers: _userAnswers,
            questions: detailQuestions,
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
            ? _userAnswers[_currentQuestionIndex]['userAnswer'] == 'T'
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const GreenText(
          text: "Listening C",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFF1F8E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Dots
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_questions.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
                    width: screenWidth * 0.037,
                    height: screenWidth * 0.037,
                    decoration: BoxDecoration(
                      color: index == _currentQuestionIndex
                          ? Colors.green
                          : Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
            // Question Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.045),
              ),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04, vertical: screenHeight * 0.04),
                child: GreenText(
                  text: "${_currentQuestionIndex + 1}. ${currentQuestion.questionText}",
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // TF Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTFButton('T', true, _selectedAnswer == true, screenWidth, screenHeight),
                SizedBox(width: screenWidth * 0.10),
                _buildTFButton('F', false, _selectedAnswer == false, screenWidth, screenHeight),
              ],
            ),
            SizedBox(height: screenHeight * 0.10),
            // Next/Finish Button at bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: _selectedAnswer != null ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswer != null ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    ),
                    elevation: 6,
                  ),
                  child: GreenText(
                    text: isLastQuestion ? "Finish" : "Next",
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            // Back button
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: IconButton(
                onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: _currentQuestionIndex > 0 ? Colors.green : Colors.grey,
                ),
                iconSize: screenWidth * 0.07,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTFButton(String label, bool value, bool isSelected, double screenWidth, double screenHeight) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
      child: GestureDetector(
        onTap: () => _selectOption(value),
        child: Material(
          elevation: isSelected ? 8 : 2,
          shape: const CircleBorder(),
          color: isSelected ? Colors.green : Colors.white,
          child: Container(
            width: screenWidth * 0.16,
            height: screenWidth * 0.16,
            alignment: Alignment.center,
            child: GreenText(
              text: label,
              textColor: isSelected ? Colors.white : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}

