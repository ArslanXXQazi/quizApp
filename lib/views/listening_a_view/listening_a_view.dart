import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/images/app_images.dart';
import 'package:studypool/views/detail_view/detail_view.dart';
import 'listening_a_controller.dart';

class ListeningAView extends StatelessWidget {
  ListeningAView({super.key});
  final ListeningAController controller = Get.put(ListeningAController());

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
            text: "Listening A",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        body: Obx(() {
          final currentQuestion = controller.questions[controller.currentQuestionIndex.value];
          final isLastQuestion = controller.currentQuestionIndex.value == controller.questions.length - 1;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Column(
              children: [
                Center(
                  child: GreenText(
                    text: currentQuestion.questionText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.2,
                              child: Image.asset(
                                currentQuestion.optionImages[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: currentQuestion.options[0],
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.2,
                              child: Image.asset(
                                currentQuestion.optionImages[1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: currentQuestion.options[1],
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.2,
                              child: Image.asset(
                                currentQuestion.optionImages[2],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: currentQuestion.options[2],
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: screenHeight * 0.2,
                              child: Image.asset(
                                currentQuestion.optionImages[3],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .005),
                          GreenText(
                            text: currentQuestion.options[3],
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: List.generate(4, (index) {
                    final option = currentQuestion.options[index];
                    final isSelected = controller.selectedAnswer.value == option;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectOption(option),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            color: isSelected ? Colors.green : Colors.white,
                          ),
                          child: Center(
                            child: GreenText(
                              text: option[0],
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