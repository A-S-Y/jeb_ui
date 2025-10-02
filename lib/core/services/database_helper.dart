import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'jeb.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<String?> getStoredPassword() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('users', columns: ['password'], limit: 1);
    if (result.isNotEmpty) {
      return result.first['password'];
    }
    return null;
  }

  Future<void> updatePassword(String newPassword) async {
    final db = await database;
    await db.update('users', {'password': newPassword});
  }
}
