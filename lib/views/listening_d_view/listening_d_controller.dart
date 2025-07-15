import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/models/data.dart';

class ListeningDController extends GetxController {
  var currentQuestionIndex = 0.obs;
  late List<TextEditingController> controllers;
  var userAnswers = <Map<String, String>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();
  var textFieldValue = ''.obs; // yeh naya rx variable

  List<FillBlankQuestion> get questions => listeningDQuestions;

  @override
  void onInit() {
    super.onInit();
    controllers = List.generate(questions.length, (_) => TextEditingController());
    userAnswers.value = List.generate(questions.length, (_) => {'userAnswer': '', 'correctAnswer': ''});
    playAudio(questions[currentQuestionIndex.value].audioPath);
  }

  void playAudio(String audioPath) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(audioPath));
    } catch (e) {}
  }

  void nextQuestion() {
    userAnswers[currentQuestionIndex.value] = {
      'userAnswer': controllers[currentQuestionIndex.value].text.trim(),
      'correctAnswer': questions[currentQuestionIndex.value].correctAnswer,
    };
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      playAudio(questions[currentQuestionIndex.value].audioPath);
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      playAudio(questions[currentQuestionIndex.value].audioPath);
    }
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    for (final c in controllers) {
      c.dispose();
    }
    super.onClose();
  }
} 