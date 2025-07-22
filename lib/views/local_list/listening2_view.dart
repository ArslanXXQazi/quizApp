import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/local_list/listening3_view.dart';
import '../../models/data.dart';
import 'local_list_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class Listening2View extends StatefulWidget {
  const Listening2View({super.key});

  @override
  State<Listening2View> createState() => _Listening2ViewState();
}

class _Listening2ViewState extends State<Listening2View> with RouteAware {
  final LocalListController controller = Get.put(LocalListController());
  final List questions = listening2Questions;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioPlayed = false;
  final int questionOffset = listening1Questions.length; // For continuous numbering

  @override
  void initState() {
    super.initState();
    if (!_audioPlayed) {
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
    Get.back();
  }

  void _navigateNext() {
    _stopAudio();
    Get.to(Listening3View());
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
        body: Stack(
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
                              text: "00:00",
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
                          "B. Listen to the dialogue and choose the best answer to the question you hear",
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: screenHeight * .02),
                        ...List.generate(questions.length, (qIndex) {
                          final q = questions[qIndex];
                          return Container(
                            margin: EdgeInsets.only(bottom: screenHeight * .015),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GreenText(
                                  text: "Q${questionOffset + qIndex + 1}) ${q.questionText}",
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: screenHeight * .01),
                                Obx(() => Column(
                                  children: [
                                    Row(
                                      children: List.generate(2, (optIdx) {
                                        final idx = optIdx;
                                        final isSelected = controller
                                            .listening2Selected[qIndex] ==
                                            q.options![idx];
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.selectListening2(
                                                  qIndex, q.options![idx]);
                                            },
                                            child: Container(
                                              color: isSelected
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: screenHeight * .01,
                                                  horizontal:
                                                  screenHeight * .015),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  GreenText(
                                                    text:
                                                    "${String.fromCharCode(65 + idx)}) ${q.options![idx]}",
                                                    textColor: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    Row(
                                      children: List.generate(2, (optIdx) {
                                        final idx = optIdx + 2;
                                        final isSelected = controller
                                            .listening2Selected[qIndex] ==
                                            q.options![idx];
                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.selectListening2(
                                                  qIndex, q.options![idx]);
                                            },
                                            child: Container(
                                              color: isSelected
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: screenHeight * .01,
                                                  horizontal:
                                                  screenHeight * .015),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  GreenText(
                                                    text:
                                                    "${String.fromCharCode(65 + idx)}) ${q.options![idx]}",
                                                    textColor: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
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