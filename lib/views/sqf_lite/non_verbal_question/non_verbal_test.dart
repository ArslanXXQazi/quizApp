import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../sqf_model/sqf_model.dart' hide Question;
import 'non_verbal_question_controller.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'package:studypool/models/quiz_model.dart';

class NonVerbalTest extends StatelessWidget {
  NonVerbalTest({super.key});
  final NonVerbalQuestionController controller = Get.put(NonVerbalQuestionController());
  final RxInt currentQuestionIndex = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final RxList<Map<String, String>> userAnswers = <Map<String, String>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();

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
                // Images row (A, B, C, D)
                Row(
                  children: List.generate(4, (index) {
                    final name = currentQuestion.imageNames[index];
                    final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
                    final isSelected = selectedAnswer.value == name;
                    return Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.13,
                              child: Image.file(
                                File(currentQuestion.imagePaths[index]),
                                fit: BoxFit.cover,
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
                // Audio play button (if audio exists)
                if (currentQuestion.audioPath != null && currentQuestion.audioPath!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => playAudio(currentQuestion.audioPath),
                        icon: Icon(Icons.play_arrow),
                        label: Text('Play Audio'),
                      ),
                      SizedBox(width: 10),
                      Text(currentQuestion.audioPath!.split('/').last, overflow: TextOverflow.ellipsis),
                    ],
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
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
