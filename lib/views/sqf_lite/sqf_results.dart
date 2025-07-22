import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/views/home_view/home_view.dart';
import 'package:studypool/views/sqf_lite/database.dart';
import 'package:studypool/views/sqf_lite/sqf_lite_controller.dart';
class SQFDetailView extends StatefulWidget {
  final List<Map<String, String>> userAnswers;
  final List<QuizQuestion> questions;

  const SQFDetailView({
    super.key,
    required this.userAnswers,
    required this.questions,
  });

  @override
  State<SQFDetailView> createState() => _SQFDetailViewState();
}

class _SQFDetailViewState extends State<SQFDetailView> {
  @override
  void initState() {
    super.initState();
    // No need to load questions from DB, use widget.questions
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate correct answers (case-insensitive, trimmed)
    int correctCount = widget.userAnswers
        .asMap()
        .entries
        .where((entry) =>
    entry.value['userAnswer']?.toLowerCase().trim() ==
        entry.value['correctAnswer']?.toLowerCase().trim())
        .length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const GreenText(
          text: "Result",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: Colors.white,
        ),
      ),
      body: widget.questions.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading while fetching
          : Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenHeight * 0.02,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.02,
                  vertical: screenHeight * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade900,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GreenText(
                  text: "$correctCount correct out of ${widget.questions.length} questions",
                  textColor: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ...widget.userAnswers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> answer = entry.value;
                bool isCorrect = answer['userAnswer']?.toLowerCase().trim() ==
                    answer['correctAnswer']?.toLowerCase().trim();
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.07,
                        backgroundColor: isCorrect ? Colors.green : Colors.red,
                        child: GreenText(
                          text: "${index + 1}",
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.07),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.02,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GreenText(
                                text: "Your Answer: ${answer['userAnswer']}",
                                textColor: Colors.white,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.start,
                              ),
                              GreenText(
                                text: "Correct Answer: ${answer['correctAnswer']}",
                                textColor: Colors.white,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  // Sab controllers delete karo taki state reset ho jaye
                  Get.deleteAll(force: true);
                  // HomeView pe wapas jao (phir user fresh exam start kare)
                  Get.offAll(() => HomeView());
                },
                child: GreenText(
                  text: "Restart Exam",
                  textColor: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                  backgroundColor: Colors.orange.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}