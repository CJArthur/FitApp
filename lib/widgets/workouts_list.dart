import 'package:fitapp/controllers/workouts_controller.dart';
import 'package:fitapp/data/models/workout.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
//import 'package:path/path.dart';
import 'package:provider/provider.dart';

class WorkoutsList extends StatelessWidget {
  const WorkoutsList({super.key, required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkoutsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.displayDate,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onAddPressed,
                child: const Icon(CupertinoIcons.add_circled_solid),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Expanded(child: _buildBody(controller)),
      ],
    );
  }

  Widget _buildBody(WorkoutsController controller) {
    if (controller.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (controller.workouts.isEmpty) {
      return const Center(
        child: Text(
          'Тренировок пока нет, день отдыха',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.workouts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final workout = controller.workouts[index];
        return _WorkoutCard(workout: workout);
      },
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout});

  final Workout workout;

  // Палитра
  static const _accentColors = [
    Color(0xFFFF6B6B), // Коралловый
    Color(0xFF0072B2), // Синий
    Color(0xFFE69F00), // Оранжевый
    Color(0xFF56B4E9), // Голубой
    Color(0xFFCC79A7), // Розово-лиловый
  ];

  @override
  Widget build(BuildContext context) {
    // Выбираем цвет по id, чтобы не менялся при скролле
    final stripeColor = _accentColors[workout.id.hashCode.abs() % _accentColors.length];

    return Dismissible(
      key: ValueKey(workout.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
      ),
      onDismissed: (_) {
        context.read<WorkoutsController>().removeWorkout(workout.id!);
      },
      
      // 1. Внешний контейнер(цветная подложка)
      child: Container(
        padding: const EdgeInsets.only(left: 3.5), // Толщина цветной дуги слева
        decoration: BoxDecoration(
          color: stripeColor,
          borderRadius: BorderRadius.circular(16),
        ),

        // 2. Внутренний контейнер(сама карточка)
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentCard.resolveFrom(context),
            borderRadius: BorderRadius.circular(16), // Тот же радиус дает сужение на углах
            border: Border.all(color: AppColors.accentCard.resolveFrom(context))
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.coach} · ${workout.durationMinutes} мин',
                      style: const TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
                    ),
                  ],
                ),
              ),
              // Кружок справа как на референсе
              // Container(
              //   width: 32,
              //   height: 32,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: CupertinoColors.systemGrey.withOpacity(0.15),
              //   ),
              //   child: Center(
              //     child: Container(
              //       width: 10,
              //       height: 10,
              //       decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: CupertinoColors.systemGrey,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}