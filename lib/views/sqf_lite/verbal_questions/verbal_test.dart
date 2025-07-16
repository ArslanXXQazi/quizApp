import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'verbal_question_controller.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/models/quiz_model.dart';

class VerbalTest extends StatefulWidget {
  const VerbalTest({super.key});

  @override
  State<VerbalTest> createState() => _VerbalTestState();
}

class _VerbalTestState extends State<VerbalTest> {
  final VerbalQuestionController controller = Get.put(VerbalQuestionController());
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxInt currentQuestionIndex = 0.obs;
  final RxnString selectedAnswer = RxnString();
  final RxList<Map<String, String>> userAnswers = <Map<String, String>>[].obs;
  int lastPlayedQuestionIndex = -1;

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void playAudio(String? path) async {
    if (path == null || path.isEmpty) {
      await audioPlayer.stop();
      return;
    }
    try {
      await audioPlayer.stop();
      await audioPlayer.play(DeviceFileSource(path));
    } catch (e) {
      Get.snackbar('Error', 'Audio play failed');
    }
  }

  void selectOption(String option) {
    selectedAnswer.value = option;
    if (userAnswers.length > currentQuestionIndex.value) {
      userAnswers[currentQuestionIndex.value] = {
        'userAnswer': option,
        'correctAnswer': controller.questions[currentQuestionIndex.value].options[0],
      };
    } else {
      userAnswers.add({
        'userAnswer': option,
        'correctAnswer': controller.questions[currentQuestionIndex.value].options[0],
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < controller.questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = null;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedAnswer.value = userAnswers.length > currentQuestionIndex.value
          ? userAnswers[currentQuestionIndex.value]['userAnswer']
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GreenText(
          text: "Verbal Test",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Obx(() {
        if (controller.questions.isEmpty) {
          return Center(child: Text('No questions found.'));
        }
        final currentQuestion = controller.questions[currentQuestionIndex.value];
        final isLastQuestion = currentQuestionIndex.value == controller.questions.length - 1;

        // Audio auto-play only when question changes
        if (lastPlayedQuestionIndex != currentQuestionIndex.value) {
          lastPlayedQuestionIndex = currentQuestionIndex.value;
          if (currentQuestion.audioPath != null && currentQuestion.audioPath!.isNotEmpty) {
            playAudio(currentQuestion.audioPath);
          } else {
            audioPlayer.stop();
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * .05),
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
                final isSelected = selectedAnswer.value == option;
                return Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: GestureDetector(
                    onTap: () => selectOption(option),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01, vertical: screenHeight * 0.025),
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
                    onPressed: currentQuestionIndex.value > 0 ? () => previousQuestion() : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: currentQuestionIndex.value > 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedAnswer.value != null
                        ? () {
                            if (isLastQuestion) {
                              // Save last answer
                              if (userAnswers.length > currentQuestionIndex.value) {
                                userAnswers[currentQuestionIndex.value] = {
                                  'userAnswer': selectedAnswer.value!,
                                  'correctAnswer': currentQuestion.options[0],
                                };
                              } else {
                                userAnswers.add({
                                  'userAnswer': selectedAnswer.value!,
                                  'correctAnswer': currentQuestion.options[0],
                                });
                              }
                              audioPlayer.stop();
                              // Convert to List<Question> for DetailView
                              final List<Question> detailQuestions = controller.questions.map((q) => Question(
                                questionText: q.questionText,
                                options: q.options,
                                optionImages: ["", "", "", ""],
                                correctAnswer: q.options[0],
                                audioPath: q.audioPath ?? '',
                              )).toList();
                              Get.to(() => DetailView(
                                    userAnswers: userAnswers,
                                    questions: detailQuestions,
                                  ));
                            } else {
                              nextQuestion();
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAnswer.value != null ? Colors.green : Colors.grey,
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
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('Delete Question'),
                        content: Text('Are you sure you want to delete this question?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Go Back'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final currentQ = controller.questions[currentQuestionIndex.value];
                              await controller.deleteQuestion(currentQ.id!);
                              Get.back();
                              // Reset to first question or handle empty
                              if (controller.questions.isNotEmpty) {
                                currentQuestionIndex.value = 0;
                                selectedAnswer.value = null;
                              } else {
                                // If no questions left, pop screen
                                Get.back();
                              }
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: GreenText(
                    text: "Delete Question",
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
