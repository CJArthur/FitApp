import 'package:fitapp/data/dao/profile_dao.dart';
import 'package:fitapp/data/models/user_profile.dart';
import 'package:flutter/cupertino.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this._dao);

  final ProfileDao _dao;
  UserProfile _profile = const UserProfile();
  UserProfile get profile => _profile;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _hasLoadError = false;
  bool get hasLoadError => _hasLoadError;

  Future<void> load() async {
    _isLoading = true;
    _hasLoadError = false;
    notifyListeners();
    try {
      _profile = await _dao.getProfile();
    } catch (_) {
      _hasLoadError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(UserProfile profile) async {
    await _dao.save(profile);
    // Обновляем сохранённое состояние только после успешной записи в БД.
    // Пока пользователь печатает в форме, верхние карточки не меняются.
    _profile = profile;
    notifyListeners();
  }
}
