import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../sqf_model/sqf_model.dart';
import 'verbal_question_controller.dart';
import 'package:studypool/common_widget/text_widget.dart';

class AddVerbalQuestion extends StatelessWidget {
  AddVerbalQuestion({super.key});
  final VerbalQuestionController controller = Get.put(VerbalQuestionController());

  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(4, (_) => TextEditingController());

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              GreenText(
                text: "Question:",
                fontWeight: FontWeight.bold,
              ),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              GreenText(
                text: "Enter 4 Options:",
                fontWeight: FontWeight.bold,
              ),
              Obx(() => Column(
                children: List.generate(4, (i) => Padding(
                  padding: EdgeInsets.only(bottom: screenHeight*.015),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: optionControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Option ${String.fromCharCode(65 + i)}',
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth*.01),
                      Radio<int>(
                        value: i,
                        groupValue: controller.correctIndex.value,
                        onChanged: (val) {
                          if (val != null) controller.correctIndex.value = val;
                        },
                      ),
                      Text('Correct', style: TextStyle(color: controller.correctIndex.value == i ? Colors.green : Colors.grey)),
                    ],
                  ),
                )),
              )),
              SizedBox(height: screenHeight * 0.03),
              GreenText(
                text: "Select Audio (optional):",
                fontWeight: FontWeight.bold,
              ),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: controller.pickAudio,
                        child: Text(controller.audioPath.value.isEmpty ? 'Pick Audio' : 'Change Audio'),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        controller.audioPath.value.isNotEmpty ? controller.audioPath.value.split('/').last : 'No audio selected',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),

                ],
              )),
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.addVerbalQuestion(
                    questionController: questionController,
                    optionControllers: optionControllers,
                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
