import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../models/user.dart';

class UserDbHelper {
  static final UserDbHelper _instance = UserDbHelper._internal();
  factory UserDbHelper() => _instance;

  UserDbHelper._internal();

  Future<void> insertUser(UserModel user) async {
    final db = await DatabaseHelper().database;

    Map<String, dynamic> userMap = {
      'id': user.id,
      'name': user.name,
      'energy': user.energy,
    };

    await db.insert(
      'users',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
