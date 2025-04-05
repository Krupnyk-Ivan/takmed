import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'test.dart';

class TestDatabaseHelper {
  static final TestDatabaseHelper _instance = TestDatabaseHelper._internal();

  factory TestDatabaseHelper() => _instance;

  TestDatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tests.db');
    print("Database path: $path");

    try {
      return await openDatabase(
        path,
        version: 2, // Increment version if schema changes
        onCreate: (db, version) async {
          print("Creating database...");
          await db.execute('''
            CREATE TABLE tests (
              id INTEGER PRIMARY KEY,
              title TEXT,
              route TEXT
            )
          ''');

          // Insert initial test data
          await db.insert('tests', {'id': 1, 'title': 'CLS', 'route': '/cls'});
          await db.insert('tests', {
            'id': 2,
            'title': 'MARCH',
            'route': '/march',
          });

          print("Initial data inserted.");
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print("Upgrading database from $oldVersion to $newVersion");
          if (oldVersion < 2) {
            // For example, drop the old table and recreate it if the schema has changed
            await db.execute('DROP TABLE IF EXISTS tests');
            await db.execute('''
              CREATE TABLE tests (
                id INTEGER PRIMARY KEY,
                title TEXT,
                route TEXT
              )
            ''');
            // Reinsert initial data
            await db.insert('tests', {
              'id': 1,
              'title': 'CLS',
              'route': '/cls',
            });
            await db.insert('tests', {
              'id': 2,
              'title': 'MARCH',
              'route': '/march',
            });
          }
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future<List<Test>> getAllTests() async {
    final db = await database;
    final res = await db.query('tests');
    return res.map((e) => Test.fromMap(e)).toList();
  }
}
