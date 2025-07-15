import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'listening_c_controller.dart';
import 'package:studypool/models/quiz_model.dart';

class ListeningCView extends StatelessWidget {
  ListeningCView({super.key});
  final ListeningCController controller = Get.put(ListeningCController());

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
            text: "Listening C",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        body: Obx(() {
          final currentQuestion = controller.questions[controller.currentQuestionIndex.value];
          final isLastQuestion = controller.currentQuestionIndex.value == controller.questions.length - 1;
          return Container(
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
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.045),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04, vertical: screenHeight * 0.04),
                    child: GreenText(
                      text: "${controller.currentQuestionIndex.value + 1}. ${currentQuestion.questionText}",
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTFButton('T', true, controller.selectedAnswer.value == true, screenWidth, screenHeight),
                    SizedBox(width: screenWidth * 0.10),
                    _buildTFButton('F', false, controller.selectedAnswer.value == false, screenWidth, screenHeight),
                  ],
                ),
                SizedBox(height: screenHeight * 0.10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      onPressed: controller.selectedAnswer.value != null
                          ? () {
                              if (isLastQuestion) {
                                controller.audioPlayer.stop();
                                // Convert TrueFalseQuestion to Question for DetailView
                                final List<Question> detailQuestions = controller.questions.map((q) => Question(
                                  questionText: q.questionText,
                                  options: ['T', 'F'],
                                  optionImages: ['', ''],
                                  correctAnswer: q.correctAnswer ? 'T' : 'F',
                                  audioPath: q.audioPath,
                                )).toList();
                                Get.to(() => DetailView(
                                      userAnswers: controller.userAnswers,
                                      questions: detailQuestions,
                                    ));
                              } else {
                                controller.nextQuestion();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.selectedAnswer.value != null ? Colors.green : Colors.grey,
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

  Widget _buildTFButton(String label, bool value, bool isSelected, double screenWidth, double screenHeight) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
      child: GestureDetector(
        onTap: () => controller.selectOption(value),
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

