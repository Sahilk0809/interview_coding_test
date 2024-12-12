import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton class
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
      onCreate: (db, version) async {
        // Creating table
        String sql = '''
        CREATE TABLE $tableName (
        id INTEGER NOT NULL,
        email TEXT NOT NULL,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        avatar TEXT NOT NULL
        );
        ''';
        await db.execute(sql);
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
    // Inserting data to the database
    String sql = '''
    INSERT INTO $tableName (id, email, first_name, last_name, avatar)
    VALUES (?, ?, ?, ?, ?);
    ''';
    List args = [id, email, firstName, lastName, avtar];
    await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    // Fetching data from the database
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }

  Future<int> deleteData() async {
    final db = await database;
    // Deleting data from database
    String sql = '''
    DELETE FROM $tableName;
    ''';
    return await db.rawDelete(sql);
  }
}
