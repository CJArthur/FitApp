import 'package:fitapp/screens/main_screen.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const WorkoutApp());

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: AppTheme.dark, // или AppTheme.system
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [Locale('ru')],
      home: MainScreen(),
    );
  }
}