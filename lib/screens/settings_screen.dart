import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/controllers/profile_controller.dart';
import 'package:fitapp/widgets/settings/account_section.dart';
import 'package:fitapp/widgets/settings/app_settings_section.dart';
import 'package:fitapp/widgets/settings/profile_form.dart';
import 'package:fitapp/widgets/settings/profile_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Экран отвечает за загрузку профиля и расположение готовых блоков.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<ProfileController>();
    if (controller.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }
    if (controller.hasLoadError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.profileLoadError),
            CupertinoButton(
              onPressed: controller.load,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    return CupertinoPageScaffold(
      // Все четыре блока остаются в дереве при прокрутке.
      // Поэтому введённый текст формы не теряется при переходе вниз страницы.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Шапка обновится после сохранения и notifyListeners в контроллере.
            ProfileHeader(profile: controller.profile),
            // Форма создаётся после загрузки: поля сразу содержат данные из БД.
            ProfileForm(initialProfile: controller.profile),
            const AppSettingsSection(),
            const AccountSection(),
          ],
        ),
      ),
    );
  }
}
