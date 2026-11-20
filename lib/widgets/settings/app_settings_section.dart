import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/controllers/app_settings_controller.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppSettingsSection extends StatelessWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<AppSettingsController>();
    final accent = AppColors.accent.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 28, 0, 12),
          child: Text(l10n.appSection, style: TextStyle(
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
              title: Text(l10n.darkTheme, style: TextStyle(fontSize: 14)),
              trailing: CupertinoSwitch(
                value: controller.isDarkMode,
                activeTrackColor: accent,
                onChanged: controller.setDarkMode,
              ),
            ),
            CupertinoListTile(
              title: Text(l10n.units, style: TextStyle(fontSize: 14)),
              additionalInfo: Text(l10n.unitSystem, style: TextStyle(fontSize: 14)),
            ),
            CupertinoListTile(
              title: Text(l10n.interfaceLanguage, style: TextStyle(fontSize: 14)),
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
                // Контроллер меняет язык, main.dart обновляет locale приложения.
                onValueChanged: (value) {
                  if (value != null) {
                    controller.setLanguage(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
