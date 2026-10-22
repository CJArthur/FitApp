import 'package:flutter/cupertino.dart';

abstract final class AppColors {
  // цвет меняется автоматически в зависимости от текущей темы
  static const accent = CupertinoDynamicColor.withBrightness(
    color: Color.fromARGB(234, 23, 85, 255),
    darkColor: Color.fromARGB(234, 215, 255, 55),
  );

  // выбор цвета текста в зависимости от темы
  static const accentText = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white, // Светлая тема: белый текст
    darkColor: CupertinoColors.black, // Темная тема: черный текст
  );

  // Стиль карточек в зависимости от темы
  static const accentCard = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.secondarySystemBackground,
    darkColor: CupertinoColors.darkBackgroundGray,
  );

  // Задний фон
  static const background = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF0F1217),
  );

  // Тул бар
  static const bar = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF15181E),
  );

  // Граница между тул баром и осн страницей
  static const tabBarBorder = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.inactiveGray,
  );
}

abstract final class AppTheme {
  static const dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(234, 215, 255, 55), // Салатовый
    scaffoldBackgroundColor: Color(0xFF0F1217),
    barBackgroundColor: Color(0xFF15181E),
  );

  static const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(234, 23, 85, 255), // Синий
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    barBackgroundColor: Color.fromARGB(255, 224, 211, 211),
  );
}
