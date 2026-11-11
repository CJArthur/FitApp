import 'package:fitapp/data/models/user_profile.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

// Получает сохранённую модель от экрана и показывает её значения.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AvatarPlaceholder(),
        const SizedBox(height: 16),
        Text(
          profile.displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        // Читаем сохранённую модель, а не текст полей формы.
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Рост', value: profile.height, unit: 'см')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(label: 'Вес', value: profile.weight, unit: 'кг')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(label: 'Цель', value: profile.targetWeight, unit: 'кг')),
          ],
        ),
      ],
    );
  }
}

String _formatNumber(double? value) {
  if (value == null) return '';
  // Целое число выводим как 78, дробное — как 78.5.
  if (value == value.truncateToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentCard.resolveFrom(context),
          border: Border.all(color: AppColors.accent.resolveFrom(context), width: 2),
        ),
        child: const Icon(CupertinoIcons.person_fill, size: 42, color: CupertinoColors.systemGrey),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.unit});

  final String label;
  final double? value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.accentCard.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: value == null ? '—' : _formatNumber(value),
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              children: [TextSpan(text: ' $unit', style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.normal, color: CupertinoColors.systemGrey,
              ))],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
    );
  }
}
