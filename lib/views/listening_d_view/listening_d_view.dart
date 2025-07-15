import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/views/listening_a_view/listening_a_view.dart';

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

class ListeningDView extends StatefulWidget {
  const ListeningDView({super.key});

  @override
  State<ListeningDView> createState() => _ListeningDViewState();
}

class _ListeningDViewState extends State<ListeningDView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<Map<String, String>> _userAnswers = List.generate(5, (_) => {'userAnswer': '', 'correctAnswer': ''});
  int _currentQuestionIndex = 0;

  final List<FillBlankQuestion> _questions = [
    FillBlankQuestion(
      beforeBlank: "Tom's Talking About His Recent Visit To A ",
      afterBlank: " With His Classmates.",
      correctAnswer: "Museum",
      audioPath: "audio/listening1Audio1.mp3",
    ),
    FillBlankQuestion(
      beforeBlank: "The Development Of Technology Have Certainmmnly ",
      afterBlank: " How Families",
      correctAnswer: "Changed",
      audioPath: "audio/listening1Audio2.mp3",
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

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _playAudio(String audioPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {}
  }

  void _nextQuestion() {
    _userAnswers[_currentQuestionIndex] = {
      'userAnswer': _controllers[_currentQuestionIndex].text.trim(),
      'correctAnswer': _questions[_currentQuestionIndex].correctAnswer,
    };
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _finishQuiz() {
    _audioPlayer.stop();
    _userAnswers[_currentQuestionIndex] = {
      'userAnswer': _controllers[_currentQuestionIndex].text.trim(),
      'correctAnswer': _questions[_currentQuestionIndex].correctAnswer,
    };
    // Add isCorrect key for case-insensitive checking
    final List<Map<String, String>> checkedAnswers = [];
    for (int i = 0; i < _userAnswers.length; i++) {
      final user = _userAnswers[i]['userAnswer'] ?? '';
      final correct = _userAnswers[i]['correctAnswer'] ?? '';
      final isCorrect = user.toLowerCase().trim() == correct.toLowerCase().trim();
      checkedAnswers.add({
        'userAnswer': user,
        'correctAnswer': correct,
        'isCorrect': isCorrect.toString(),
      });
    }
    final List<Question> detailQuestions = _questions.map((q) => Question(
      questionText: q.beforeBlank + '_____' + q.afterBlank,
      options: [],
      optionImages: [],
      correctAnswer: q.correctAnswer,
      audioPath: q.audioPath,
    )).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          userAnswers: checkedAnswers,
          questions: detailQuestions,
        ),
      ),
    );
  }

  bool get _isCurrentFilled => _controllers[_currentQuestionIndex].text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final q = _questions[_currentQuestionIndex];
    final isLast = _currentQuestionIndex == _questions.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const GreenText(
          text: "Listening D",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F8E9), Color(0xFFE0F7FA)],
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
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.04,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GreenText(
                        text: "${_currentQuestionIndex + 16}. ${q.beforeBlank}",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Container(
                      width: screenWidth * 0.22,
                      child: TextField(
                        controller: _controllers[_currentQuestionIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            borderSide: BorderSide(color: Colors.green.shade200, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            borderSide: BorderSide(color: Colors.green, width: 2.5),
                          ),
                        ),
                        onTap: () => _playAudio(q.audioPath),
                        onChanged: (val) => setState(() {}),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Expanded(
                      child: GreenText(
                        text: q.afterBlank,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: _isCurrentFilled ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCurrentFilled ? Colors.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    ),
                    elevation: 6,
                  ),
                  child: GreenText(
                    text: isLast ? "Finish" : "Next",
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
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
}
