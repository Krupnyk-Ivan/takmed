import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StatsDatabaseHelper {
  static final StatsDatabaseHelper _instance = StatsDatabaseHelper._internal();
  factory StatsDatabaseHelper() => _instance;
  StatsDatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'stats.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE stats (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            testId INTEGER,
            score INTEGER,
            timeTaken INTEGER,
            date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllStats() async {
    final db = await database;
    return await db.query('stats', orderBy: 'id DESC');
  }

  Future<void> insertStat(Map<String, dynamic> stat) async {
    final db = await database;
    await db.insert('stats', stat);
  }

  Future<List<Map<String, dynamic>>> getStats() async {
    final db = await database;
    return await db.query('stats');
  }

  Future<List<Map<String, dynamic>>> getStatsByTestId(int testId) async {
    final db = await database;
    return await db.query('stats', where: 'testId = ?', whereArgs: [testId]);
  }

  void getStatsByTest(int testId) async {
    final stats = await StatsDatabaseHelper().getStatsByTestId(testId);
    print("Stats for test $testId: $stats");
  }

  void onTestCompleted(int userId, int testId, int score, int timeTaken) async {
    final stat = {
      'userId': userId,
      'testId': testId,
      'score': score,
      'timeTaken': timeTaken,
    };

    await StatsDatabaseHelper().insertStat(stat);
    print("Test completed and stat saved.");
  }

  Future<List<Map<String, dynamic>>> getStatsByUserId(int userId) async {
    final db = await database;
    return await db.query('stats', where: 'userId = ?', whereArgs: [userId]);
  }
}
