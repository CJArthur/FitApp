import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  // Храним Future открытия: оба контроллера при старте ждут одно подключение,
  // даже если одновременно впервые обратились к базе.
  Future<Database>? _db;

  // Версия миграции бд
  static const _currentVersion = 2;

  // Геттер который возвращает бд. если null откроет, если нет то просто бд вернет
  Future<Database> get database => _db ??= _open();

  Future<void> _createProfileTable(Database db) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        middle_name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        height REAL,
        weight REAL,
        target_weight REAL
      )
    ''');
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
        await _createProfileTable(db);
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
            case 2:
              // Для уже установленного приложения добавляем только профиль.
              // Таблица тренировок и её записи остаются на месте.
              await _createProfileTable(db);
              break;
          }
        }
      },
    );
  }
}
