import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../sqf_model/sqf_model.dart' hide Question;
import 'non_verbal_question_controller.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/models/quiz_model.dart';

class NonVerbalTest extends StatefulWidget {
  NonVerbalTest({super.key});
  @override
  State<NonVerbalTest> createState() => _NonVerbalTestState();
}

class _NonVerbalTestState extends State<NonVerbalTest> {
  final NonVerbalQuestionController controller = Get.put(NonVerbalQuestionController());
  final RxInt currentQuestionIndex = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final RxList<Map<String, String>> userAnswers = <Map<String, String>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  int lastPlayedQuestionIndex = -1;

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void selectOption(String name) {
    selectedAnswer.value = name;
    if (userAnswers.length > currentQuestionIndex.value) {
      userAnswers[currentQuestionIndex.value] = {
        'userAnswer': name,
        'correctAnswer': controller.questions[currentQuestionIndex.value].imageNames[0],
      };
    } else {
      userAnswers.add({
        'userAnswer': name,
        'correctAnswer': controller.questions[currentQuestionIndex.value].imageNames[0],
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < controller.questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = '';
    }
  }

  void playAudio(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      await audioPlayer.stop();
      await audioPlayer.play(DeviceFileSource(path));
    } catch (e) {
      Get.snackbar('Error', 'Audio play failed');
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
          text: "Non-Verbal Test",
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: GreenText(
                    text: currentQuestion.questionText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Images in 2 rows, 2 per row
                Row(
                  children: List.generate(2, (i) {
                    final name = currentQuestion.imageNames[i];
                    final optionLetter = String.fromCharCode(65 + i); // A, B
                    final isSelected = selectedAnswer.value == name;
                    return Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth*.01),
                              width: double.infinity,
                              height: screenHeight * 0.16,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(currentQuestion.imagePaths[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: "$optionLetter) $name",
                            fontWeight: FontWeight.bold,
                            textColor: isSelected ? Colors.green : Colors.black,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: List.generate(2, (i) {
                    final idx = i + 2;
                    final name = currentQuestion.imageNames[idx];
                    final optionLetter = String.fromCharCode(65 + idx); // C, D
                    final isSelected = selectedAnswer.value == name;
                    return Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth*.01),
                              width: double.infinity,
                              height: screenHeight * 0.16,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(currentQuestion.imagePaths[idx]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: "$optionLetter) $name",
                            fontWeight: FontWeight.bold,
                            textColor: isSelected ? Colors.green : Colors.black,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Option buttons row (A, B, C, D)
                Row(
                  children: List.generate(4, (index) {
                    final name = currentQuestion.imageNames[index];
                    final isSelected = selectedAnswer.value == name;
                    final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => selectOption(name),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                          height: screenHeight * 0.045,
                          width: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            color: isSelected ? Colors.green : Colors.white,
                          ),
                          child: Center(
                            child: GreenText(
                              text: optionLetter,
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
                      onPressed: currentQuestionIndex.value > 0 ? () {
                        currentQuestionIndex.value--;
                        selectedAnswer.value = userAnswers.length > currentQuestionIndex.value
                            ? userAnswers[currentQuestionIndex.value]['userAnswer'] ?? ''
                            : '';
                      } : null,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: currentQuestionIndex.value > 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedAnswer.value.isNotEmpty
                          ? () {
                              if (isLastQuestion) {
                                // Save last answer
                                if (userAnswers.length > currentQuestionIndex.value) {
                                  userAnswers[currentQuestionIndex.value] = {
                                    'userAnswer': selectedAnswer.value,
                                    'correctAnswer': currentQuestion.imageNames[0],
                                  };
                                } else {
                                  userAnswers.add({
                                    'userAnswer': selectedAnswer.value,
                                    'correctAnswer': currentQuestion.imageNames[0],
                                  });
                                }
                                audioPlayer.stop(); // Stop audio before navigating to DetailView
                                final List<Question> detailQuestions = controller.questions.map((q) => Question(
                                  questionText: q.questionText,
                                  options: q.imageNames,
                                  optionImages: q.imagePaths,
                                  correctAnswer: q.imageNames[0],
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
                        backgroundColor: selectedAnswer.value.isNotEmpty ? Colors.green : Colors.grey,
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
                    // Delete button

                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
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
                                await controller.deleteQuestion(currentQuestion.id!);
                                Get.back();
                                // Reset to first question or handle empty
                                if (controller.questions.isNotEmpty) {
                                  currentQuestionIndex.value = 0;
                                  selectedAnswer.value = '';
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
                      backgroundColor: Colors.red
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
          ),
        );
      }),
    );
  }
}
