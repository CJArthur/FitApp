//import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/screens/main_screen.dart';
import 'package:fitapp/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
