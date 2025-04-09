import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'test_question.dart';

class QuestionDatabaseHelper {
  static final QuestionDatabaseHelper _instance =
      QuestionDatabaseHelper._internal();
  factory QuestionDatabaseHelper() => _instance;
  QuestionDatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'questions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''        
          CREATE TABLE questions (
            id INTEGER PRIMARY KEY,
            question TEXT,
            options TEXT,
            correctIndex INTEGER,
            category TEXT
          )
        ''');

        // Вставка запитань протоколу MARCH
        await db.insert('questions', {
          'id': 1,
          'question': 'Що означає "M" у протоколі MARCH?',
          'options':
              'Move (Переміщення)|Meds (Ліки)|Mass (Маса)|Monitoring (Моніторинг)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 2,
          'question': 'Який із наступних етапів є першим у протоколі MARCH?',
          'options':
              'Airway (Дихальні шляхи)|Circulation (Кровообіг)|Move (Переміщення)|Head (Голова)',
          'correctIndex': 2,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 3,
          'question': 'Що є основною метою етапу "Airway" у протоколі MARCH?',
          'options':
              'Відновлення дихальних шляхів|Перевірка пульсу|Зупинка кровотечі|Переміщення постраждалого',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 4,
          'question': 'Що означає "C" у протоколі MARCH?',
          'options':
              'Circulation (Кровообіг)|Control (Контроль)|Cortex (Кора головного мозку)|Chest (Грудна клітка)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 5,
          'question':
              'Якщо пацієнт перебуває в стані шоку, на якому етапі протоколу MARCH потрібно звертати найбільшу увагу?',
          'options':
              'Circulation (Кровообіг)|Move (Переміщення)|Head (Голова)|Airway (Дихальні шляхи)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 6,
          'question': 'Що слід робити на етапі "Respiration" протоколу MARCH?',
          'options':
              'Перевірити дихання|Переміщувати постраждалого|Налагодити контроль кровотечі|Перевірити пульс',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 7,
          'question': 'Що означає "H" у протоколі MARCH?',
          'options': 'Head (Голова)|Heart (Серце)|Heat (Тепло)|Harm (Шкода)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 8,
          'question': 'Який із етапів протоколу MARCH є останнім?',
          'options':
              'Head (Голова)|Respiration (Дихання)|Move (Переміщення)|Circulation (Кровообіг)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 9,
          'question':
              'Який етап протоколу MARCH зосереджений на переміщенні постраждалого?',
          'options':
              'Move (Переміщення)|Airway (Дихальні шляхи)|Respiration (Дихання)|Circulation (Кровообіг)',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        await db.insert('questions', {
          'id': 10,
          'question': 'Що є метою етапу "Circulation" у протоколі MARCH?',
          'options':
              'Відновлення кровообігу|Перевірка дихальних шляхів|Переміщення пацієнта|Перевірка пульсу',
          'correctIndex': 0,
          'category': 'MARCH',
        });

        // Вставка запитань протоколу CLS
        await db.insert('questions', {
          'id': 11,
          'question': 'Що є першим кроком у протоколі CLS?',
          'options': 'Airway|Circulation|Breathing|Disability',
          'correctIndex': 0,
          'category': 'CLS',
        });

        await db.insert('questions', {
          'id': 12,
          'question': 'Що означає "C" у протоколі CLS?',
          'options': 'Circulation|Compression|Check|Control',
          'correctIndex': 0,
          'category': 'CLS',
        });

        await db.insert('questions', {
          'id': 13,
          'question':
              'Що потрібно зробити на етапі "Breathing" у протоколі CLS?',
          'options':
              'Перевірити дихання|Налагодити кровообіг|Переміщувати постраждалого|Контролювати температуру',
          'correctIndex': 0,
          'category': 'CLS',
        });

        await db.insert('questions', {
          'id': 14,
          'question': 'Що таке "Disability" в протоколі CLS?',
          'options':
              'Оцінка свідомості|Оцінка пульсу|Оцінка дихання|Оцінка кровообігу',
          'correctIndex': 0,
          'category': 'CLS',
        });
      },
    );
  }

  Future<List<TestQuestion>> getQuestionsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((e) => TestQuestion.fromMap(e)).toList();
  }

  Future<List<TestQuestion>> getAllQuestions() async {
    final db = await database;
    final result = await db.query('questions');
    return result.map((e) => TestQuestion.fromMap(e)).toList();
  }
}
