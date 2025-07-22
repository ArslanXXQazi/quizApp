import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/views/local_list/listening4_view.dart';
import 'package:studypool/views/local_list/local_list_controller.dart';
import 'package:studypool/views/sqf_lite/database.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/views/sqf_lite/sqflite_listening2_view.dart';
import 'package:studypool/views/sqf_lite/sqf_lite_controller.dart';
import 'package:studypool/views/sqf_lite/sqflite_listening4_view.dart';

class SQFListening3View extends StatefulWidget {
  const SQFListening3View({super.key});

  @override
  State<SQFListening3View> createState() => _SQFListening3ViewState();
}

class _SQFListening3ViewState extends State<SQFListening3View> with RouteAware {
  final SQFLiteController controller = Get.find<SQFLiteController>();
  List<QuizQuestion> questions = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioPlayed = false;
  final int questionOffset = 10; // listening1Questions.length + listening2Questions.length

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
          .where((q) => q.type == QuestionType.trueFalse)
          .toList(); // Load all trueFalse questions without limit
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
    Get.off(() => SQFListening2View());
  }

  void _navigateNext() {
    _stopAudio();
    Get.off(() => SQFListening4View()); // Use Get.off to replace screen
  }

  @override
  void dispose() {
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
                          text:
                          "C. Listen to the passage and tell whether the following statements are true or false",
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: screenHeight * .02),
                        ...List.generate(questions.length, (qIndex) {
                          final q = questions[qIndex];
                          return Container(
                            margin: EdgeInsets.only(bottom: screenHeight * .03),
                            child: Row(
                              children: [
                                GreenText(text: "${questionOffset + qIndex + 1}. "),
                                Expanded(
                                  child: GreenText(
                                    text: q.questionText,
                                    textAlign: TextAlign.start,
                                    fontSize: 14,
                                  ),
                                ),
                                Obx(() => Row(
                                  children: List.generate(q.options!.length, (optIdx) {
                                    final option = q.options![optIdx];
                                    final isSelected =
                                        controller.listening3Selected[qIndex] ==
                                            option;
                                    return Container(
                                      height: screenHeight * .05,
                                      width: screenWidth * .15,
                                      margin:
                                      EdgeInsets.only(left: screenWidth * .01),
                                      decoration: BoxDecoration(
                                        color:
                                        isSelected ? Colors.green : Colors.transparent,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          controller.selectListening3(
                                              qIndex, option);
                                        },
                                        child: Center(
                                          child: GreenText(
                                            text: option,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            textColor:
                                            isSelected ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )),
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