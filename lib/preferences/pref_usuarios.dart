
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{
  //generar instancia
  static late SharedPreferences _prefs;

  //inicializar las preferencias
  static Future init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  String get ultimaPagina{
    return _prefs.getString('ultimaPagina') ?? 'InicioSesion';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get tipoLogin => _prefs.getString('tipoLogin') ?? '';
  set tipoLogin(String value) => _prefs.setString('tipoLogin', value);

}

