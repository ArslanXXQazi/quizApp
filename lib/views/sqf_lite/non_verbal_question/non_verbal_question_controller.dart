import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../sqf_model/sqf_model.dart';

class NonVerbalQuestionController extends GetxController {
  late Database db;
  var questions = <NonVerbalQuestion>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDb();
  }

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'nonverbal_questions.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE questions(id INTEGER PRIMARY KEY AUTOINCREMENT, questionText TEXT, imagePaths TEXT, imageNames TEXT, audioPath TEXT)',
        );
      },
      version: 1,
    );
    await fetchQuestions();
  }

  Future<void> addQuestion(NonVerbalQuestion question) async {
    await db.insert('questions', question.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final List<Map<String, dynamic>> maps = await db.query('questions');
    questions.value = List.generate(maps.length, (i) => NonVerbalQuestion.fromMap(maps[i]));
  }

  Future<void> deleteQuestion(int id) async {
    await db.delete('questions', where: 'id = ?', whereArgs: [id]);
    await fetchQuestions();
  }

  Future<void> updateQuestion(NonVerbalQuestion question) async {
    await db.update('questions', question.toMap(), where: 'id = ?', whereArgs: [question.id]);
    await fetchQuestions();
  }
} 