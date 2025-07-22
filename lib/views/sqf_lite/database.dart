import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:studypool/models/data.dart';
import 'package:studypool/models/quiz_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static bool _isDataInitialized = false; // New boolean flag to track data initialization

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            questionText TEXT,
            type TEXT,
            options TEXT,
            correctAnswer TEXT,
            audioPath TEXT,
            beforeBlank TEXT,
            afterBlank TEXT,
            optionImages TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE data_status (
            id INTEGER PRIMARY KEY,
            isDataStored INTEGER
          )
        ''');
      },
    );
  }

  Future<bool> isDataStored() async {
    if (_isDataInitialized) return true; // Check in-memory flag first
    final db = await database;
    final result = await db.query('data_status');
    bool stored = result.isNotEmpty && result.first['isDataStored'] == 1;
    if (stored) _isDataInitialized = true; // Update flag if data is stored
    return stored;
  }

  Future<void> setDataStored() async {
    final db = await database;
    await db.insert('data_status', {'id': 1, 'isDataStored': 1},
        conflictAlgorithm: ConflictAlgorithm.replace);
    _isDataInitialized = true; // Update flag after marking data as stored
  }

  Future<void> storeQuestions(List<QuizQuestion> questions) async {
    final db = await database;
    for (var question in questions) {
      await db.insert('questions', {
        'questionText': question.questionText,
        'type': question.type.toString(),
        'options': question.options?.join(','),
        'correctAnswer': question.correctAnswer,
        'audioPath': question.audioPath,
        'beforeBlank': question.beforeBlank,
        'afterBlank': question.afterBlank,
        'optionImages': question.optionImages?.join(','),
      });
    }
  }

  Future<List<QuizQuestion>> getQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return QuizQuestion(
        questionText: maps[i]['questionText'],
        type: QuestionType.values.firstWhere((e) => e.toString() == maps[i]['type']),
        options: maps[i]['options']?.split(','),
        correctAnswer: maps[i]['correctAnswer'],
        audioPath: maps[i]['audioPath'],
        beforeBlank: maps[i]['beforeBlank'],
        afterBlank: maps[i]['afterBlank'],
        optionImages: maps[i]['optionImages']?.split(','),
      );
    });
  }

  Future<void> saveDataToDatabase() async {
    if (_isDataInitialized || await isDataStored()) {
      print('Data pehle se store hai, dobara store nahi hoga.');
      return;
    }

    // Store all question lists
    await storeQuestions(listening1Questions);
    await storeQuestions(listening2Questions);
    await storeQuestions(listening3Questions);
    await storeQuestions(listening4Questions);

    // Mark data as stored
    await setDataStored();
    print('Data successfully store ho gaya.');
  }
}