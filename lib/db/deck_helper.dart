import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';

class DeckDbHelper {
  static final DeckDbHelper _instance = DeckDbHelper._internal();
  factory DeckDbHelper() => _instance;

  DeckDbHelper._internal();

  Future<void> insertDecks(List<Map<String, dynamic>> decks) async {
    final db = await DatabaseHelper().database;

    // Use a transaction for bulk inserts
    await db.transaction((txn) async {
      for (var deck in decks) {
        await txn.insert(
          'decks',
          deck,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> getDecks() async {
    final db = await DatabaseHelper().database;
    return await db.query('decks');
  }

  Future<void> deleteDeck(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
