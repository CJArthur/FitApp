import 'package:fitapp/controllers/workouts_controller.dart';
import 'package:fitapp/data/dao/workouts_dao.dart';
import 'package:fitapp/screens/main_screen.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite работает нативно только на Android/iOS,
  // для теста на винде поставили FFI-движок
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const WorkoutApp());
}

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
