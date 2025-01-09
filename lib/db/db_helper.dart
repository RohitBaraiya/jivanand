import 'package:jivanand/db/model/CartModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String _dbName = 'veer_creation.db';
  static const int _dbVersion = 1;

  static const String _tableName = 'tble_cart';

/*  static const String columnId = 'id';
  static const String columnPId = 'p_id';
  static const String columnPName = 'p_name';
  static const String columnImg = 'img';*/

  // Singleton DBHelper instance
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  // Get the database instance (if not initialized, initialize it)
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate, // Create the table when the database is created
    );
  }

  // Create the table in the database

  Future<void> _onCreate(Database db, int version) async {
    /*String createTableQuery = '''
CREATE TABLE tble_cart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  p_id TEXT,
  p_name TEXT,
  img TEXT,
  cat_id TEXT,
  cat_name TEXT
)
''';*/
    /*String createTableQuery = '''
CREATE TABLE tble_cart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  p_id TEXT,
  p_name TEXT,
  img TEXT,
  cat_id TEXT,
  cat_name TEXT,
  price INTEGER
)
''';*/
    String createTableQuery = '''
CREATE TABLE tble_cart (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  p_id TEXT,
  p_name TEXT,
  img TEXT,
  cat_id TEXT,
  cat_name TEXT,
  price REAL,
  thum TEXT,
  stock INTEGER,
  buy_qty INTEGER,
  remark TEXT
)
''';
    await db.execute(createTableQuery);
  }

  // Insert a new CardModel row into the table
  Future<int> insert(CardModel card) async {
    Database db = await instance.database;
    return await db.insert(_tableName, card.toMap());
  }

  // Update an existing CardModel in the table
  Future<int> update(CardModel card) async {
    Database db = await instance.database;
    return await db.update(
      _tableName,
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  // Delete a CardModel by its ID
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all rows (or drop the table and recreate it)
  /*Future<void> deleteTable() async {
    Database db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS $_tableName');
    await db.execute('''
      CREATE TABLE $_tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnPId TEXT, 
        $columnPName TEXT, 
        $columnImg TEXT
      )
    ''');
  }*/
  Future<void> deleteTable() async {
    Database db = await instance.database;
    await db.execute('DELETE FROM tble_cart');
  }

  // Get all CardModels from the table
  Future<List<CardModel>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return CardModel.fromMap(maps[i]);
    });
  }

  // Get a single CardModel by ID
  Future<CardModel?> queryById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CardModel.fromMap(maps.first);
    }
    return null;
  }


  Future<int> getRecordCount() async {
    Database db = await instance.database;

    // Run a SQL query to get the count of rows in tble_cart
    var result = await db.rawQuery('SELECT COUNT(*) FROM tble_cart');

    // The result is a list, with the first element being the count as a Map
    int count = Sqflite.firstIntValue(result) ?? 0;

    return count;
  }


  Future<bool> doesRecordExist(int id) async {
    Database db = await DBHelper.instance.database;

    // Query the table to check if a record with the given id exists
    var result = await db.query(
      'tble_cart',
      where: 'p_id = ?', // Condition to check for the specific id
      whereArgs: [id], // The id to check for
    );

    // If the result is not empty, the record exists
    return result.isNotEmpty;
  }
}
