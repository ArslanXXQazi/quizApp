import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'listening_b_controller.dart';

class ListeningBView extends StatelessWidget {
  ListeningBView({super.key});
  final ListeningBController controller = Get.put(ListeningBController());

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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controller.audioPlayer.stop();
              Get.back();
            },
          ),
          centerTitle: true,
          title: const GreenText(
            text: "Listening B",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        body: Obx(() {
          final currentQuestion = controller.questions[controller.currentQuestionIndex.value];
          final isLastQuestion = controller.currentQuestionIndex.value == controller.questions.length - 1;
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
                  final isSelected = controller.selectedAnswer.value == option;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: GestureDetector(
                      onTap: () => controller.selectOption(option),
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
                      onPressed: controller.currentQuestionIndex.value > 0 ? () => controller.previousQuestion() : null,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: controller.currentQuestionIndex.value > 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: controller.selectedAnswer.value != null
                          ? () {
                              if (isLastQuestion) {
                                controller.audioPlayer.stop();
                                Get.to(() => DetailView(
                                      userAnswers: controller.userAnswers,
                                      questions: controller.questions,
                                    ));
                              } else {
                                controller.nextQuestion();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.selectedAnswer.value != null ? Colors.green : Colors.grey,
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
          );
        }),
      ),
    );
  }
}