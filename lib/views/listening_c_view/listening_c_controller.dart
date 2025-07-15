import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/models/data.dart';

class ListeningCController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var selectedAnswer = RxnBool();
  var userAnswers = <Map<String, String>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<TrueFalseQuestion> get questions => listeningCQuestions;

  void playAudio(String audioPath) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(audioPath));
    } catch (e) {}
  }

  void selectOption(bool value) {
    selectedAnswer.value = value;
    if (userAnswers.length > currentQuestionIndex.value) {
      userAnswers[currentQuestionIndex.value] = {
        'userAnswer': value ? 'T' : 'F',
        'correctAnswer': questions[currentQuestionIndex.value].correctAnswer ? 'T' : 'F',
      };
    } else {
      userAnswers.add({
        'userAnswer': value ? 'T' : 'F',
        'correctAnswer': questions[currentQuestionIndex.value].correctAnswer ? 'T' : 'F',
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = null;
      playAudio(questions[currentQuestionIndex.value].audioPath);
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedAnswer.value = userAnswers.length > currentQuestionIndex.value
          ? userAnswers[currentQuestionIndex.value]['userAnswer'] == 'T'
          : null;
      playAudio(questions[currentQuestionIndex.value].audioPath);
    }
  }

  @override
  void onInit() {
    super.onInit();
    playAudio(questions[currentQuestionIndex.value].audioPath);
  }

  @override
  void onClose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.onClose();
  }
} 