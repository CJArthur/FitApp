import 'package:fitapp/data/dao/workouts_dao.dart';
import 'package:fitapp/data/models/workout.dart';
import 'package:flutter/cupertino.dart';

class WorkoutsController extends ChangeNotifier {
  // Принимаем дао снаружи
  WorkoutsController(this._dao);

  final WorkoutsDao _dao;

  // Переменные приватные _, чтобы UI не мог изменить их напрямую
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Формат в котором храним дату("2026-10-15")
  // Исп padleft чтобы "2026-1-5" превратится в "2026-01-05" для точного совпадения с БД
  String _format(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
  
  String get displayDate {
    final d = _selectedDate.day.toString().padLeft(2, '0');
    final m = _selectedDate.month.toString().padLeft(2, '0');
    final y = _selectedDate.year.toString();
    return '$d.$m.$y';
  }

  // Вызывается при старте и при выборе новой даты в ленте
  Future<void> selectDate(DateTime date) async {
    _selectedDate = date;
    _isLoading = true;
    notifyListeners(); // экран покажет загрузку

    // Ждем данные из бд
    _workouts = await _dao.getByDate(_format(date));

    _isLoading = false;
    notifyListeners(); // новые данные
  }

  // Single Source of Truth
  Future<void> addWorkout(Workout workout) async {
    await _dao.insert(workout); // Сохр в бд
    await selectDate(_selectedDate); // перечитываем из БД — список обновится
  }

  Future<void> removeWorkout(int id) async {
    await _dao.delete(id);
    await selectDate(_selectedDate);
  }
}
