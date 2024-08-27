import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';

class CardUserDbHelper {
  static final CardUserDbHelper _instance = CardUserDbHelper._internal();
  factory CardUserDbHelper() => _instance;

  CardUserDbHelper._internal();

  Future<void> insertCardUser(Map<String, dynamic> cardUser) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      'card_user',
      cardUser,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> countCardsForUser(int userId) async {
    final db = await DatabaseHelper().database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM card_user WHERE user_id = ?', [userId]))!;
  }

  Future<void> deleteCardUser(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'card_user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
