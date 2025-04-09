import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> deleteDatabaseFile() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'questions.db');
  try {
    await File(path).delete();
    print("Database deleted");
  } catch (e) {
    print("Error deleting database: $e");
  }
}
