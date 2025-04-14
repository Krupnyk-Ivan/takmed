import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'medicine.dart';

class MedicineDatabaseHelper {
  static const _databaseName = "medicine.db";

  static const table = 'medicines';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIconCode = 'iconCode';
  static const columnImagePath = 'imagePath';
  static const columnNote = 'note';
  static const columnExpirationDate = 'expirationDate';
  static const columnCategory = 'category';
  static const columnIsDangerous = 'isDangerous';

  static final MedicineDatabaseHelper instance =
      MedicineDatabaseHelper._privateConstructor();

  MedicineDatabaseHelper._privateConstructor();
  MedicineDatabaseHelper();

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnIconCode INTEGER,
            $columnImagePath TEXT,
            $columnNote TEXT,
            $columnExpirationDate TEXT,
            $columnCategory TEXT,
            $columnIsDangerous INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await _openDatabase();
    return await db.insert(table, medicine.toMap());
  }

  Future<int> updateMedicine(Medicine medicine) async {
    final db = await _openDatabase();
    return await db.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> deleteMedicine(int id) async {
    final db = await _openDatabase();
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Medicine>> getAllMedicines() async {
    final db = await _openDatabase();
    final maps = await db.query(table);
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    final db = await _openDatabase();
    final maps = await db.query(
      table,
      where: '$columnCategory = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Medicine.fromMap(maps[i]));
  }

  Future<Medicine?> getMedicineById(int id) async {
    final db = await _openDatabase();
    final maps = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Medicine.fromMap(maps.first);
    return null;
  }
}
