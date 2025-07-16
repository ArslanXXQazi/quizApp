import 'package:flutter/material.dart';
import 'package:studypool/common_widget/listening_container.dart';
import 'package:studypool/common_widget/text_widget.dart';
import 'package:studypool/images/app_images.dart';
class AddQuestionNonVerbal extends StatelessWidget {
  const AddQuestionNonVerbal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GreenText(
          text: "Enter Questions",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      body: Column(
        children: [
        Center(
          child: GreenText(
            text: "Q1) Which animal lives in the ocean?",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                        AppImages.elephant,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .005),
                  GreenText(
                    text: "Elephant",
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
                        AppImages.elephant,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .005),
                  GreenText(
                    text: "Elephant",
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
                        AppImages.elephant,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .005),
                  GreenText(
                    text: "Elephant",
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
                        AppImages.elephant,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .005),
                  GreenText(
                    text: "Elephant",
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
          SizedBox(height: screenHeight * 0.04),
          ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: GreenText(
              text: "Add Question",
              textColor: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),


      ],),
    );
  }
}
