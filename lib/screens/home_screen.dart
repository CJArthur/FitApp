import 'package:fitapp/controllers/workouts_controller.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkoutsController>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('John Doe')),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Добро пожаловать!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _StreakCard(days: 5, workouts: 7),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _DateStrip(controller: controller),
            const SizedBox(height: 16),
            // Сюда позже пойдёт список тренировок (шаг 4)
            Expanded(
              child: Center(
                child: controller.isLoading
                    ? const CupertinoActivityIndicator()
                    : Text(
                        'Тренировок на ${controller.displayDate}: ${controller.workouts.length}',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.days, required this.workouts});

  final int days;
  final int workouts;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accent.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: AppColors.accentText.resolveFrom(context)),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.flame_fill,
                size: 40,
                color: CupertinoColors.systemRed,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Недельная серия',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$days дней подряд',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '$workouts',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Тренировок', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({required this.controller});

  final WorkoutsController controller;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ru_RU',
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: controller.selectedDate,
      calendarFormat: CalendarFormat.week,
      onFormatChanged: (_) {}, // фикс-ем формат
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(day, controller.selectedDate),
      onDaySelected: (selectedDay, focusedDay) {
        context.read<WorkoutsController>().selectDate(selectedDay);
      },

      daysOfWeekHeight: 24,
      
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppColors.accent.resolveFrom(context),
          shape: BoxShape.circle,
        ),
        
        selectedTextStyle: TextStyle(color: AppColors.accentText.resolveFrom(context)),
        todayDecoration: BoxDecoration(
          color: CupertinoColors.systemGrey4,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}