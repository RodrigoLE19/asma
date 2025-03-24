abstract class PreferencesRepository{

  String? get typeLogin;

  Future<void> setTypeLogin(String typeLogin );
}