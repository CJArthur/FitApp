import 'package:flutter/cupertino.dart';

abstract final class AppColors {
  static const accent = Color.fromARGB(235, 215, 255, 55);

  static const background = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF0F1217),
  );

  static const bar = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF15181E),
  );
}

abstract final class AppTheme {
  static const dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(234, 215, 255, 55),            // салатовый
    scaffoldBackgroundColor: Color(0xFF0F1217),
    barBackgroundColor: Color(0xFF15181E),
  );

  static const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(234, 215, 255, 55),            // тёмно-оливковый
    scaffoldBackgroundColor: Color.fromARGB(255, 55, 122, 255),
    barBackgroundColor: Color.fromARGB(255, 10, 64, 209),
  );
}
