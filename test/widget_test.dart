import 'package:fitapp/controllers/app_settings_controller.dart';
import 'package:fitapp/data/models/user_profile.dart';
import 'package:fitapp/l10n/app_localizations.dart';
import 'package:fitapp/widgets/settings/app_settings_section.dart';
import 'package:fitapp/widgets/settings/profile_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('RU / EN changes labels and keeps the text in the form', (tester) async {
    final settings = AppSettingsController();

    // Проверяем настоящий переключатель и форму. База для этого не нужна.
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: Consumer<AppSettingsController>(
          builder: (context, controller, child) => CupertinoApp(
            locale: Locale(controller.language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const CupertinoPageScaffold(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileForm(initialProfile: UserProfile()),
                    AppSettingsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ЛИЧНЫЕ ДАННЫЕ'), findsOneWidget);
    final nameField = find.byType(CupertinoTextField).first;
    await tester.enterText(nameField, 'Артём');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('EN'));
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(settings.language, 'en');
    expect(find.text('PERSONAL DETAILS'), findsOneWidget);
    expect(find.text('Dark theme'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Артём'), findsOneWidget);

    await tester.ensureVisible(find.text('RU'));
    await tester.tap(find.text('RU'));
    await tester.pumpAndSettle();

    expect(settings.language, 'ru');
    expect(find.text('ЛИЧНЫЕ ДАННЫЕ'), findsOneWidget);
    expect(find.text('Сохранить'), findsOneWidget);
    expect(find.text('Артём'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    settings.dispose();
  });
}
