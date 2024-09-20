import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure, // Enable foreign keys on configuration
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    energy INTEGER NOT NULL DEFAULT 160
  )
  ''');

    await db.execute('''
  CREATE TABLE decks (
    deck_id INTEGER PRIMARY KEY,
    deck_name TEXT NOT NULL,
    deck_description TEXT NOT NULL,
    total_XP INTEGER NOT NULL,
    user_XP INTEGER NOT NULL,
    img_url TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    title TEXT
  )
  ''');

    await db.execute('''
  CREATE TABLE card_tiers (
    card_tier_id INTEGER PRIMARY KEY AUTOINCREMENT,
    card_tier_name TEXT NOT NULL,
    card_XP INTEGER NOT NULL,
    card_energy_required INTEGER NOT NULL,
    color TEXT NOT NULL DEFAULT '#000000',
    created_at TEXT,
    updated_at TEXT
  )
  ''');

    await db.execute('''
  CREATE TABLE cards (
    card_id INTEGER PRIMARY KEY AUTOINCREMENT,
    deck_id INTEGER NOT NULL,
    card_name TEXT NOT NULL,
    card_tier_id INTEGER,
    card_description TEXT NOT NULL,
    card_version INTEGER NOT NULL DEFAULT 1,
    img_url TEXT,
    created_at TEXT,
    updated_at TEXT,
    FOREIGN KEY (card_tier_id) REFERENCES card_tiers(card_tier_id) ON DELETE CASCADE,
    FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE
  )
  ''');
  }

  Future<void> _onConfigure(Database db) async {
    // Enable foreign key support
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> deleteExistingDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    await deleteDatabase(path);
    print("Database deleted successfully");
  }

  Future<void> recreateDatabase() async {
    // Delete the existing database
    await deleteExistingDatabase();

    // Access the database, which will recreate it and the tables
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.database;

    print("Database and tables created successfully");
  }
}
