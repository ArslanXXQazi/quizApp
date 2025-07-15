import 'package:flutter/material.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/views/home_view/home_view.dart';
import 'package:studypool/views/listening_a_view/listening_a_view.dart';

class DetailView extends StatelessWidget {
  final List<Map<String, String>> userAnswers;
  final List<Question> questions;

  const DetailView({
    super.key,
    required this.userAnswers,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate correct answers (case-insensitive, trimmed)
    int correctCount = userAnswers
        .asMap()
        .entries
        .where((entry) =>
            entry.value['userAnswer']?.toLowerCase().trim() ==
            entry.value['correctAnswer']?.toLowerCase().trim())
        .length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const GreenText(
          text: "Result",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: Colors.white,
        ),
      ),
      body: Padding(
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
                  text: "$correctCount correct out of  ${questions.length} questions",
                  textColor: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ...userAnswers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> answer = entry.value;
                bool isCorrect = answer['userAnswer']?.toLowerCase().trim() == answer['correctAnswer']?.toLowerCase().trim();
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
                              ),
                              GreenText(
                                text: "Correct Answer: ${answer['correctAnswer']}",
                                textColor: Colors.white,
                                fontWeight: FontWeight.w700,
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeView()));
                },
                child: GreenText(
                  text: "Restart Exam",
                  textColor: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06), // Increased button size
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