import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'medicine.dart'; // Your Medicine model

class MedicineDatabaseHelper {
  static const _databaseName = "medicine.db";
  static const _databaseVersion =
      2; // Increment the version when changing the schema

  static const table = 'medicines';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnIconCode = 'iconCode';
  static const columnImagePath = 'imagePath';
  static const columnNote = 'note';
  static const columnExpirationDate = 'expirationDate';
  static const columnCategory = 'category'; // Add category column

  // Singleton pattern to ensure only one instance of the database helper is used
  static final MedicineDatabaseHelper instance =
      MedicineDatabaseHelper._privateConstructor();

  // Private constructor to prevent instance creation outside of this class
  MedicineDatabaseHelper._privateConstructor();
  MedicineDatabaseHelper();
  // Open the database
  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        // Create the medicines table
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnIconCode INTEGER,
            $columnImagePath TEXT,
            $columnNote TEXT,
            $columnExpirationDate TEXT,
            $columnCategory TEXT
          )
        ''');
      },
      onUpgrade: _migrateDatabase, // Migration logic to add 'category' column
    );
  }

  // Migration function to handle schema changes (adding the 'category' column)
  Future<void> _migrateDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < newVersion) {
      // Add the 'category' column if it doesn't exist
      await db.execute('ALTER TABLE $table ADD COLUMN $columnCategory TEXT');
    }
  }

  // Insert a new medicine
  Future<int> insertMedicine(Medicine medicine) async {
    Database db = await _openDatabase();
    return await db.insert(table, medicine.toMap());
  }

  // Update an existing medicine
  Future<int> updateMedicine(Medicine medicine) async {
    Database db = await _openDatabase();
    return await db.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?',
      whereArgs: [medicine.id],
    );
  }

  // Delete a medicine
  Future<int> deleteMedicine(int id) async {
    Database db = await _openDatabase();
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get a list of all medicines
  Future<List<Medicine>> getAllMedicines() async {
    Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  // Get medicines by category
  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnCategory = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  // Get a medicine by ID
  Future<Medicine?> getMedicineById(int id) async {
    Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
