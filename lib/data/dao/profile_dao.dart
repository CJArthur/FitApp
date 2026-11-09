import 'package:fitapp/data/database.dart';
import 'package:fitapp/data/models/user_profile.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<UserProfile> getProfile() async {
    final db = await _db.database;
    final rows = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (rows.isEmpty) {
      return const UserProfile();
    }
    return UserProfile.fromMap(rows.first);
  }

  Future<void> save(UserProfile profile) async {
    final db = await _db.database;
    // id всегда равен 1: повторное сохранение заменяет локальный профиль,
    // а не создаёт ещё одного пользователя.
    await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
