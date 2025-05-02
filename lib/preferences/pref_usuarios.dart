import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{
  //generar instancia
  static late SharedPreferences _prefs;

  //inicializar las preferencias
  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  String get ultimaPagina => _prefs.getString('ultimaPagina') ?? 'InicioSesion';
  set ultimaPagina(String value) => _prefs.setString('ultimaPagina', value);

  String get ultimouid => _prefs.getString('ultimouid') ?? '';
  set ultimouid(String value) => _prefs.setString('ultimouid', value);

  String get ultimouidgoogle => _prefs.getString('ultimouidgoogle') ?? '';
  set ultimouidgoogle(String value) => _prefs.setString('ultimouidgoogle', value);

  int get ultimaPaginaIndex => _prefs.getInt('ultimaPaginaIndex') ?? 0;
  set ultimaPaginaIndex(int value) => _prefs.setInt('ultimaPaginaIndex', value);

  String get tipoLogin => _prefs.getString('tipoLogin') ?? '';
  set tipoLogin(String value) => _prefs.setString('tipoLogin', value);


  String get token{
    return _prefs.getString('token') ?? '';
  }

  set token(String value){
    _prefs.setString('token', value);
  }
  //bool get hasShownHighRiskModal => _prefs.getBool('hasShownHighRiskModal') ?? false;
  //set hasShownHighRiskModal(bool value) => _prefs.setBool('hasShownHighRiskModal', value);
  //String get selectedLanguage => _prefs.getString('selectedLanguage') ?? 'es'; // 'es' por defecto para español
  //set selectedLanguage(String value) => _prefs.setString('selectedLanguage', value);

  /*String get ultimaPagina{
    return _prefs.getString('ultimaPagina') ?? 'InicioSesion';
  }

  int get ultimaPaginaIndex => _prefs.getInt('ultimaPaginaIndex') ?? 0;
  set ultimaPaginaIndex(int value) => _prefs.setInt('ultimaPaginaIndex', value);

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get tipoLogin => _prefs.getString('tipoLogin') ?? '';
  set tipoLogin(String value) => _prefs.setString('tipoLogin', value);*/

}

