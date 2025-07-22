import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/data.dart';

class LocalListController extends GetxController {
  // For Listening 1 (5 questions, 5 options)
  RxList<String?> listening1Selected = RxList<String?>([null, null, null, null, null]);

  // For Listening 2 (text MCQ, dynamic length)
  RxList<String?> listening2Selected = RxList<String?>(
    List.generate(listening2Questions.length, (_) => null)
  );

  // For Listening 3 (true/false, dynamic length)
  RxList<String?> listening3Selected = RxList<String?>(
    List.generate(listening3Questions.length, (_) => null)
  );

  // For Listening 4 (fill in the blank, dynamic length)
  RxList<String?> listening4Answers = RxList<String?>(
    List.generate(listening4Questions.length, (_) => null)
  );

  // Methods to update answers
  void selectListening1(int index, String value) {
    listening1Selected[index] = value;
    listening1Selected.refresh();
  }

  void selectListening2(int index, String value) {
    listening2Selected[index] = value;
    listening2Selected.refresh();
  }

  void selectListening3(int index, String value) {
    listening3Selected[index] = value;
    listening3Selected.refresh();
  }

  void setListening4(int index, String value) {
    listening4Answers[index] = value;
    listening4Answers.refresh();
  }

  // Reset all answers (for restart)
  void resetAll() {
    listening1Selected.value = [null, null, null, null, null];
    listening2Selected.value = List.generate(listening2Questions.length, (_) => null);
    listening3Selected.value = List.generate(listening3Questions.length, (_) => null);
    listening4Answers.value = List.generate(listening4Questions.length, (_) => null);
  }
}