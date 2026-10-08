import 'package:fitapp/controllers/workouts_controller.dart';
import 'package:fitapp/data/dao/workouts_dao.dart';
import 'package:fitapp/screens/main_screen.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(const WorkoutApp());

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              WorkoutsController(WorkoutsDao())..selectDate(DateTime.now()),
        ),
      ],
      child: const CupertinoApp(
        theme: AppTheme.light,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [Locale('ru')],
        home: MainScreen(),
      ),
    );
  }
}
