import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> deleteMedicineDatabase() async {
  // Get the path where databases are stored
  final dbPath = await getDatabasesPath();

  // Path to the medicine database (replace 'medicines.db' with the correct name if necessary)
  final path = join(dbPath, 'medicine.db');

  try {
    // Delete the database file
    await File(path).delete();
    print("Medicine database deleted");
  } catch (e) {
    print("Error deleting medicine database: $e");
  }
}
