import 'package:fitapp/controllers/app_settings_controller.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppSettingsController>();
    final accent = AppColors.accent.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 28, 0, 12),
          child: Text('ПРИЛОЖЕНИЕ', style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey,
          )),
        ),
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          backgroundColor: CupertinoColors.transparent,
          decoration: BoxDecoration(
            color: AppColors.accentCard.resolveFrom(context),
            borderRadius: BorderRadius.circular(16),
          ),
          children: [
            CupertinoListTile(
              title: const Text('Тёмная тема', style: TextStyle(fontSize: 14)),
              trailing: CupertinoSwitch(
                value: controller.isDarkMode,
                activeTrackColor: accent,
                onChanged: controller.setDarkMode,
              ),
            ),
            const CupertinoListTile(
              title: Text('Единицы измерения', style: TextStyle(fontSize: 14)),
              additionalInfo: Text('кг / см', style: TextStyle(fontSize: 14)),
            ),
            CupertinoListTile(
              title: const Text('Язык интерфейса', style: TextStyle(fontSize: 14)),
              trailing: CupertinoSlidingSegmentedControl<String>(
                groupValue: controller.language,
                thumbColor: accent,
                children: {
                  'ru': Text('RU', style: TextStyle(
                    fontSize: 13,
                    color: controller.language == 'ru'
                        ? AppColors.accentText.resolveFrom(context)
                        : CupertinoColors.label.resolveFrom(context),
                  )),
                  'en': Text('EN', style: TextStyle(
                    fontSize: 13,
                    color: controller.language == 'en'
                        ? AppColors.accentText.resolveFrom(context)
                        : CupertinoColors.label.resolveFrom(context),
                  )),
                },
                // Меняем только положение переключателя, без перевода.
                onValueChanged: (value) {
                  if (value != null) {
                    controller.setLanguage(value);
                  }
                },
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8, left: 12),
          child: Text('Выбор языка — макет, перевод пока не подключён.',
              style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ),
      ],
    );
  }
}
