import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../sqf_model/sqf_model.dart';

class VerbalQuestionController extends GetxController {
  late Database db;
  var questions = <VerbalQuestion>[].obs;

  // Add these reactive variables for UI state
  var audioPath = ''.obs;
  var correctIndex = 0.obs;

  void setAudioPath(String path) => audioPath.value = path;
  void setCorrectIndex(int index) => correctIndex.value = index;

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'verbal_questions.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE questions(id INTEGER PRIMARY KEY AUTOINCREMENT, questionText TEXT, options TEXT, audioPath TEXT)',
        );
      },
      version: 1,
    );
    await fetchQuestions();
  }

  Future<void> addQuestion(VerbalQuestion question) async {
    await db.insert('questions', question.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final List<Map<String, dynamic>> maps = await db.query('questions');
    questions.value = List.generate(maps.length, (i) => VerbalQuestion.fromMap(maps[i]));
  }

  Future<void> deleteQuestion(int id) async {
    await db.delete('questions', where: 'id = ?', whereArgs: [id]);
    await fetchQuestions();
  }

  Future<void> updateQuestion(VerbalQuestion question) async {
    await db.update('questions', question.toMap(), where: 'id = ?', whereArgs: [question.id]);
    await fetchQuestions();
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      audioPath.value = result.files.single.path!;
    }
  }

  Future<void> addVerbalQuestion({
    required TextEditingController questionController,
    required List<TextEditingController> optionControllers,
  }) async {
    if (questionController.text.trim().isEmpty ||
        optionControllers.any((c) => c.text.trim().isEmpty)) {
      Get.snackbar('Error', 'Please fill all fields.');
      return;
    }
    final options = optionControllers.map((c) => c.text.trim()).toList();
    // Ensure correct answer is at index 0
    if (correctIndex.value != 0) {
      final temp = options[0];
      options[0] = options[correctIndex.value];
      options[correctIndex.value] = temp;
    }
    final question = VerbalQuestion(
      questionText: questionController.text.trim(),
      options: options,
      audioPath: audioPath.value.isNotEmpty ? audioPath.value : null,
    );
    await addQuestion(question);
    Get.snackbar('Success', 'Question added!');
    questionController.clear();
    for (final c in optionControllers) c.clear();
    audioPath.value = '';
    correctIndex.value = 0;
  }
} 