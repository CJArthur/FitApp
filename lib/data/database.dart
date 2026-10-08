import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  // Переменная для хранения открытой БД. Изначально null.
  Database? _db;

  // Версия миграции бд
  static const _currentVersion = 1;

  // Геттер который возвращает бд. если null откроет, если нет то просто бд вернет
  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath =
        await getDatabasesPath(); // системный путь для хранения БД на телефоне
    final path = join(dbPath, 'workouts.db'); // склейка путей

    return openDatabase(
      path,
      version: _currentVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            title TEXT NOT NULL,
            time TEXT NOT NULL,
            coach TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL
          )
        ''');
        // await db.execute('''
        // потом добавлю новую таблицу
        // ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        for (var v = oldVersion + 1; v <= newVersion; v++) {
          switch (v) {
            case 1:
              await db.execute('''
                CREATE TABLE workouts (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  date TEXT NOT NULL,
                  title TEXT NOT NULL,
                  time TEXT NOT NULL,
                  coach TEXT NOT NULL,
                  duration_minutes INTEGER NOT NULL
                )
              ''');
              break;
          }
        }
      },
    );
  }
}
