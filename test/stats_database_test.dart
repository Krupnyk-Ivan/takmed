import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/database/stats_db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late StatsDatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = StatsDatabaseHelper();
    final db = await dbHelper.database;
    await db.delete('stats'); // очищаємо таблицю перед кожним тестом
  });

  test('Insert and fetch single stat', () async {
    final stat = {'userId': 1, 'testId': 101, 'score': 8, 'timeTaken': 120};

    await dbHelper.insertStat(stat);

    final results = await dbHelper.getAllStats();
    expect(results.length, 1);
    expect(results[0]['userId'], 1);
    expect(results[0]['testId'], 101);
    expect(results[0]['score'], 8);
    expect(results[0]['timeTaken'], 120);
  });

  test('Filter stats by testId', () async {
    await dbHelper.insertStat({
      'userId': 1,
      'testId': 101,
      'score': 6,
      'timeTaken': 100,
    });
    await dbHelper.insertStat({
      'userId': 2,
      'testId': 102,
      'score': 9,
      'timeTaken': 110,
    });
    await dbHelper.insertStat({
      'userId': 3,
      'testId': 101,
      'score': 7,
      'timeTaken': 105,
    });

    final stats101 = await dbHelper.getStatsByTestId(101);
    expect(stats101.length, 2);
    expect(stats101.every((s) => s['testId'] == 101), isTrue);
  });

  test('Filter stats by userId', () async {
    await dbHelper.insertStat({
      'userId': 99,
      'testId': 5,
      'score': 4,
      'timeTaken': 90,
    });
    await dbHelper.insertStat({
      'userId': 99,
      'testId': 6,
      'score': 5,
      'timeTaken': 95,
    });
    await dbHelper.insertStat({
      'userId': 88,
      'testId': 6,
      'score': 10,
      'timeTaken': 80,
    });

    final userStats = await dbHelper.getStatsByUserId(99);
    expect(userStats.length, 2);
    expect(userStats.every((s) => s['userId'] == 99), isTrue);
  });

  test('Stat includes auto-generated timestamp', () async {
    final stat = {'userId': 1, 'testId': 201, 'score': 10, 'timeTaken': 150};

    await dbHelper.insertStat(stat);
    final stats = await dbHelper.getAllStats();
    final statDate = stats.first['date'];

    expect(statDate, isNotNull);
    expect(DateTime.tryParse(statDate.toString()), isA<DateTime>());
  });
}
