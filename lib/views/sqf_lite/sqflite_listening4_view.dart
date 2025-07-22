import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/views/local_list/local_list_controller.dart';
import 'package:studypool/views/sqf_lite/database.dart';
import 'package:studypool/views/sqf_lite/sqf_results.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/views/sqf_lite/sqflite_listening3_view.dart';
import 'package:studypool/views/sqf_lite/sqf_lite_controller.dart';

class SQFListening4View extends StatefulWidget {
  const SQFListening4View({super.key});

  @override
  State<SQFListening4View> createState() => _SQFListening4ViewState();
}

class _SQFListening4ViewState extends State<SQFListening4View> with RouteAware {
  late List<TextEditingController> textControllers;
  final SQFLiteController controller = Get.put(SQFLiteController(), permanent: true);
  List<QuizQuestion> questions = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioPlayed = false;
  final int questionOffset = 15; // listening1Questions.length + listening2Questions.length + listening3Questions.length

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final dbHelper = DatabaseHelper();
    final fetchedQuestions = await dbHelper.getQuestions();
    setState(() {
      questions = fetchedQuestions
          .where((q) => q.type == QuestionType.fillBlank)
          .toList(); // Load all fillBlank questions without limit
      textControllers = List.generate(
        questions.length,
        (i) => TextEditingController(text: controller.listening4Answers[i] ?? ""),
      );
    });
    if (!_audioPlayed && questions.isNotEmpty) {
      _playAudio();
      _audioPlayed = true;
    }
  }

  Future<void> _playAudio() async {
    if (questions.isNotEmpty && questions[0].audioPath != null && questions[0].audioPath!.isNotEmpty) {
      try {
        String audioPath = questions[0].audioPath!.replaceFirst('assets/audio/', '');
        await _audioPlayer.play(AssetSource(audioPath));
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
  }

  void _navigateBack() {
    _stopAudio();
    Get.off(() => SQFListening3View());
  }

  void _navigateNext() {
    _stopAudio();
    // Fetch all questions from database
    final dbHelper = DatabaseHelper();
    dbHelper.getQuestions().then((allQuestions) {
      // Split questions by type
      final listening1Questions = allQuestions.where((q) => q.type == QuestionType.imageMcq).toList();
      final listening2Questions = allQuestions.where((q) => q.type == QuestionType.textMcq).toList();
      final listening3Questions = allQuestions.where((q) => q.type == QuestionType.trueFalse).toList();
      final listening4Questions = allQuestions.where((q) => q.type == QuestionType.fillBlank).toList();
      // Combine all questions in order
      final combinedQuestions = [
        ...listening1Questions,
        ...listening2Questions,
        ...listening3Questions,
        ...listening4Questions,
      ];
      final userAnswers = <Map<String, String>>[];
      final c = controller;
      for (int i = 0; i < listening1Questions.length; i++) {
        userAnswers.add({
          'userAnswer': c.listening1Selected[i] ?? '',
          'correctAnswer': listening1Questions[i].correctAnswer ?? '',
        });
      }
      for (int i = 0; i < listening2Questions.length; i++) {
        userAnswers.add({
          'userAnswer': c.listening2Selected[i] ?? '',
          'correctAnswer': listening2Questions[i].correctAnswer ?? '',
        });
      }
      for (int i = 0; i < listening3Questions.length; i++) {
        userAnswers.add({
          'userAnswer': c.listening3Selected[i] ?? '',
          'correctAnswer': listening3Questions[i].correctAnswer ?? '',
        });
      }
      for (int i = 0; i < listening4Questions.length; i++) {
        userAnswers.add({
          'userAnswer': c.listening4Answers[i] ?? '',
          'correctAnswer': listening4Questions[i].correctAnswer ?? '',
        });
      }
      print('SQFLiteController: userAnswers = ' + userAnswers.toString());
      Get.off(() => SQFDetailView(userAnswers: userAnswers, questions: combinedQuestions));
    });
  }

  @override
  void dispose() {
    for (final c in textControllers) {
      c.dispose();
    }
    _stopAudio();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        _stopAudio();
        return true;
      },
      child: Scaffold(
        body: questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * .06, horizontal: screenWidth * .02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _navigateBack,
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * .04,
                              backgroundColor: Colors.orange.shade700,
                              child: Icon(
                                Icons.headphones,
                                color: Colors.white,
                                size: screenHeight * .025,
                              ),
                            ),
                            SizedBox(width: screenWidth * .02),
                            GreenText(
                              text: "Listening",
                              fontSize: 20,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Container(
                          height: screenHeight * .045,
                          width: screenWidth * .2,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: GreenText(
                              text: "50:00",
                              textColor: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * .14),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * .03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreenText(
                          text: "D. Listen to the dialogue and complete the following sentences",
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: screenHeight * .02),
                        ...List.generate(questions.length, (qIndex) {
                          final q = questions[qIndex];
                          return Container(
                            margin: EdgeInsets.only(bottom: screenWidth * .03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GreenText(text: "${questionOffset + qIndex + 1}."),
                                Expanded(
                                  child: GreenText(
                                    text: q.beforeBlank ?? '',
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: screenWidth * .015),
                                SizedBox(
                                  width: screenWidth * .2,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    controller: textControllers[qIndex],
                                    onChanged: (val) {
                                      controller.setListening4(qIndex, val);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.green, width: 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * .015),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GreenText(
                                        text: q.afterBlank ?? '',
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: screenHeight * .05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _navigateBack,
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                            IconButton(
                              onPressed: _navigateNext,
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}