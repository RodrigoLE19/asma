import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository{
  final SharedPreferences _preferences;

  PreferencesRepositoryImpl(this._preferences);

  @override
  // TODO: implement typeLogin
  String? get typeLogin {
    return _preferences.getString('typeLogin');
  }

  @override
  Future<void> setTypeLogin(String typeLogin) {
    return _preferences.setString('typeLogin', typeLogin);
  }



}