import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../sqf_model/sqf_model.dart';
import 'non_verbal_question_controller.dart';
import 'package:studypool/common_widget/text_widget.dart';

class AddQuestionNonVerbal extends StatelessWidget {
  AddQuestionNonVerbal({super.key});
  final NonVerbalQuestionController controller = Get.put(NonVerbalQuestionController());

  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> nameControllers = List.generate(4, (_) => TextEditingController());
  final RxList<String> imagePaths = List<String>.filled(4, '', growable: false).obs;
  final RxString audioPath = ''.obs;
  final RxInt correctIndex = 0.obs;

  Future<void> pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePaths[index] = image.path;
      imagePaths.refresh();
    }
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      audioPath.value = result.files.single.path!;
    }
  }

  void addQuestion() async {
    if (questionController.text.trim().isEmpty ||
        imagePaths.any((p) => p.isEmpty) ||
        nameControllers.any((c) => c.text.trim().isEmpty)) {
      Get.snackbar('Error', 'Please fill all fields and select all images.');
      return;
    }
    final names = nameControllers.map((c) => c.text.trim()).toList();
    final question = NonVerbalQuestion(
      questionText: questionController.text.trim(),
      imagePaths: List<String>.from(imagePaths),
      imageNames: names,
      audioPath: audioPath.value.isNotEmpty ? audioPath.value : null,
    );
    // Ensure correct answer is at index 0
    if (correctIndex.value != 0) {
      // Swap correct answer to index 0
      final tempName = names[0];
      final tempPath = imagePaths[0];
      names[0] = names[correctIndex.value];
      imagePaths[0] = imagePaths[correctIndex.value];
      names[correctIndex.value] = tempName;
      imagePaths[correctIndex.value] = tempPath;
    }
    await controller.addQuestion(question);
    Get.snackbar('Success', 'Question added!');
    questionController.clear();
    for (final c in nameControllers) c.clear();
    for (int i = 0; i < 4; i++) imagePaths[i] = '';
    audioPath.value = '';
    correctIndex.value = 0;
    imagePaths.refresh();
  }

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
                decoration: InputDecoration(hintText: 'Enter question'),
              ),
              SizedBox(height: screenHeight * 0.03),
              GreenText(
                text: "Select 4 Images & Enter Names:",
                fontWeight: FontWeight.bold,
              ),
              Obx(() => Column(
                children: List.generate(4, (i) => Row(
                  children: [
                    GestureDetector(
                      onTap: () => pickImage(i),
                      child: Container(
                        width: screenWidth * 0.22,
                        height: screenWidth * 0.22,
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imagePaths[i].isEmpty
                            ? Icon(Icons.add_a_photo, size: 40)
                            : Image.file(File(imagePaths[i]), fit: BoxFit.cover),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: nameControllers[i],
                        decoration: InputDecoration(hintText: 'Name for image ${i + 1}'),
                      ),
                    ),
                    Obx(() => Radio<int>(
                      value: i,
                      groupValue: correctIndex.value,
                      onChanged: (val) {
                        if (val != null) correctIndex.value = val;
                      },
                    )),
                    Obx(() => Text('Correct', style: TextStyle(color: correctIndex.value == i ? Colors.green : Colors.grey))),
                  ],
                )),
              )),
              SizedBox(height: screenHeight * 0.03),
              GreenText(
                text: "Select Audio (optional):",
                fontWeight: FontWeight.bold,
              ),
              Obx(() => Row(
                children: [
                  ElevatedButton(
                    onPressed: pickAudio,
                    child: Text(audioPath.value.isEmpty ? 'Pick Audio' : 'Change Audio'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      audioPath.value.isNotEmpty ? audioPath.value.split('/').last : 'No audio selected',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: addQuestion,
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
            ],
          ),
        ),
      ),
    );
  }
}
