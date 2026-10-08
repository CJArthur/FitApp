import 'package:fitapp/data/database.dart';
import 'package:fitapp/data/models/workout.dart';

class WorkoutsDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<Workout>> getByDate(String date) async {
    final db = await _db.database;
    final rows = await db.query(
      'workouts',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'time ASC',
    );
    return rows.map(Workout.fromMap).toList();
  }

  Future<int> insert(Workout workout) async {
    final db = await _db.database;
    return db.insert('workouts', workout.toMap()..remove('id'));
  }

  Future<void> delete(int id) async {
    final db = await _db.database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }
}
