class Workout {
  const Workout({
    this.id,
    required this.date,
    required this.title,
    required this.time,
    required this.coach,
    required this.durationMinutes,
  });

  final int? id;
  final String date;
  final String title;
  final String time;
  final String coach;
  final int durationMinutes;

  // Метод Для записи в бд
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'time': time,
      'coach': coach,
      'duration_minutes': durationMinutes,
    };
  }

  // Для чтения из бд
  factory Workout.fromMap(Map<String, Object?> map) {
    return Workout(
      id: map['id'] as int?,
      date: map['date'] as String,
      title: map['title'] as String,
      time: map['time'] as String,
      coach: map['coach'] as String,
      durationMinutes: map['duration_minutes'] as int,
    );
  }
}
