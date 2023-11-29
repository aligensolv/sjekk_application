import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    // Get the path to the database
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sjekk_v2.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 6, onCreate: _createTable, onUpgrade:(db, oldVersion, newVersion) async{
          await db.execute('''
            CREATE TABLE vl (
              id INTEGER PRIMARY KEY,
              type TEXT,
              brand TEXT,
              rules TEXT,
              status TEXT,
              created_at TEXT,
              description TEXT,
              plate TEXT,
              year TEXT,
              place TEXT,
              car_images TEXT,
              is_car_registered TEXT,
              regisered_car_info TEXT,
              paper_comment TEXT,
              out_comment TEXT
            )
          ''');

          print('violations table was created');      
    },);
  }

  Future<void> _createTable(Database db, int version) async {
    // Create your tables here
    await db.execute('''
      CREATE TABLE printer (
        id INTEGER PRIMARY KEY,
        name TEXT,
        address TEXT
      )
    ''');
    // Add more tables as needed
  }

  // Example: Insert data into the database
  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.insert(tableName, data);
  }

  // Example: Retrieve all data from a table
  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> getPrinter(String tableName, int printerId) async {
  Database db = await instance.database;
  List<Map<String, dynamic>> result = await db.query(tableName, where: 'id = ?', whereArgs: [printerId], limit: 1);

  if (result.isNotEmpty) {
    return result.first;
  } else {
    // Return an empty map or null, depending on your preference
    return {};
  }
}

  // Example: Retrieve data with a specific condition
  Future<List<Map<String, dynamic>>> getDataWithCondition(
      String tableName, String columnName, dynamic value) async {
    Database db = await instance.database;
    return await db.query(tableName, where: '$columnName = ?', whereArgs: [value]);
  }

   Future<int> removeDataById(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Example: Clear all records from a table
  Future<int> clearTable(String tableName) async {
    Database db = await instance.database;
    return await db.delete(tableName);
  }

  // Example: Update a record
  Future<int> updateData(String tableName, int id, Map<String, dynamic> newData) async {
    Database db = await instance.database;
    return await db.update(tableName, newData, where: 'id = ?', whereArgs: [id]);
  }

  // Add more methods as needed for CRUD operations
}
