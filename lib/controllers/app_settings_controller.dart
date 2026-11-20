import 'package:flutter/cupertino.dart';

// Настройки интерфейса отделены от личных данных пользователя.
// Пока они хранятся в памяти и действуют до закрытия приложения.
class AppSettingsController extends ChangeNotifier {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  String _language = 'ru';
  String get language => _language;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    // main.dart читает language и передаёт его в locale приложения.
    _language = value;
    notifyListeners();
  }
}
