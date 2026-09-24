import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('John Doe')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: CupertinoColors.black),
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
