import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'listening_d_controller.dart';
import 'package:studypool/models/quiz_model.dart';

class ListeningDView extends StatelessWidget {
  ListeningDView({super.key});
  final ListeningDController controller = Get.put(ListeningDController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        controller.audioPlayer.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controller.audioPlayer.stop();
              Get.back();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const GreenText(
            text: "Listening D",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        body: Obx(() {
          final q = controller.questions[controller.currentQuestionIndex.value];
          final isLast = controller.currentQuestionIndex.value == controller.questions.length - 1;
          return Container(
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
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(controller.questions.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
                        width: screenWidth * 0.037,
                        height: screenWidth * 0.037,
                        decoration: BoxDecoration(
                          color: index == controller.currentQuestionIndex.value
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
                            text: "${controller.currentQuestionIndex.value + 16}. ${q.beforeBlank}",
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Container(
                          width: screenWidth * 0.22,
                          child: TextField(
                            controller: controller.controllers[controller.currentQuestionIndex.value],
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
                            onTap: () => controller.playAudio(q.audioPath),
                            onChanged: (val) => controller.textFieldValue.value = val,
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
                      onPressed: controller.textFieldValue.value.trim().isNotEmpty
                          ? () {
                              if (isLast) {
                                // Last answer ko bhi update karo
                                controller.userAnswers[controller.currentQuestionIndex.value] = {
                                  'userAnswer': controller.controllers[controller.currentQuestionIndex.value].text.trim(),
                                  'correctAnswer': controller.questions[controller.currentQuestionIndex.value].correctAnswer,
                                };
                                controller.audioPlayer.stop();
                                // Prepare answers for DetailView
                                final List<Map<String, String>> checkedAnswers = [];
                                for (int i = 0; i < controller.userAnswers.length; i++) {
                                  final user = controller.userAnswers[i]['userAnswer'] ?? '';
                                  final correct = controller.userAnswers[i]['correctAnswer'] ?? '';
                                  final isCorrect = user.toLowerCase().trim() == correct.toLowerCase().trim();
                                  checkedAnswers.add({
                                    'userAnswer': user,
                                    'correctAnswer': correct,
                                    'isCorrect': isCorrect.toString(),
                                  });
                                }
                                final List<Question> detailQuestions = controller.questions.map((q) => Question(
                                  questionText: q.beforeBlank + '_____' + q.afterBlank,
                                  options: [],
                                  optionImages: [],
                                  correctAnswer: q.correctAnswer,
                                  audioPath: q.audioPath,
                                )).toList();
                                Get.to(() => DetailView(
                                      userAnswers: checkedAnswers,
                                      questions: detailQuestions,
                                    ));
                              } else {
                                controller.nextQuestion();
                                // Update textFieldValue for next question
                                controller.textFieldValue.value = controller.controllers[controller.currentQuestionIndex.value].text;
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.controllers[controller.currentQuestionIndex.value].text.trim().isNotEmpty ? Colors.green : Colors.grey,
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
                    onPressed: controller.currentQuestionIndex.value > 0 ? () => controller.previousQuestion() : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: controller.currentQuestionIndex.value > 0 ? Colors.green : Colors.grey,
                    ),
                    iconSize: screenWidth * 0.07,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
