import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  static String databaseName = 'contact.db';
  static String tableName = 'contact';
  Database? _database;

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        email TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        avtar TEXT NOT NULL,
        );
        ''';
        db.execute(sql);
      },
    );
  }

  Future<void> insertData(
      {required int id,
      required String email,
      required String firstName,
      required String lastName,
      required String avtar}) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName (id, email, firstName, lastName, avtar)
    VALUES (?, ?, ?, ?, ?);
    ''';
    List args = [id, email, firstName, lastName, avtar];
    await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }
}
