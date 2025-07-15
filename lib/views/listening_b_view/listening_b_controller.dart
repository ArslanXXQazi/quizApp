import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:studypool/models/quiz_model.dart';
import 'package:studypool/models/data.dart';

class ListeningBController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var selectedAnswer = RxnString();
  var userAnswers = <Map<String, String>>[].obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<Question> get questions => listeningBQuestions;

  void playAudio(String audioPath) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(audioPath));
    } catch (e) {}
  }

  void selectOption(String option) {
    selectedAnswer.value = option;
    if (userAnswers.length > currentQuestionIndex.value) {
      userAnswers[currentQuestionIndex.value] = {
        'userAnswer': option,
        'correctAnswer': questions[currentQuestionIndex.value].correctAnswer,
      };
    } else {
      userAnswers.add({
        'userAnswer': option,
        'correctAnswer': questions[currentQuestionIndex.value].correctAnswer,
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
          ? userAnswers[currentQuestionIndex.value]['userAnswer']
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