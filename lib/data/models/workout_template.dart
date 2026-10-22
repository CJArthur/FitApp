class WorkoutTemplate {
  const WorkoutTemplate({
    required this.title,
    required this.time,
    required this.coach,
    required this.durationMinutes,
  });

  final String title;
  final String time;
  final String coach;
  final int durationMinutes;
}

// Тренировки для выбора
const workoutTemplates = [
  WorkoutTemplate(title: 'Групповой бокс', time: '18:00', coach: 'Алексей Петров', durationMinutes: 60),
  WorkoutTemplate(title: 'Кроссфит', time: '19:00', coach: 'Мария Сидорова', durationMinutes: 45),
  WorkoutTemplate(title: 'Йога', time: '08:00', coach: 'Елена Кузнецова', durationMinutes: 60),
  WorkoutTemplate(title: 'Силовая', time: '20:00', coach: 'Игорь Волков', durationMinutes: 50),
];