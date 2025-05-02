import 'package:flutter/cupertino.dart';
import '../../../preferences/pref_usuarios.dart';

class MenuHomeProviderController extends ChangeNotifier{
  int _seleccionMenu = PreferenciasUsuario().ultimaPaginaIndex;
  int get seleccionMenu => _seleccionMenu;

  set seleccionMenu(int i) {
    _seleccionMenu = i;
    PreferenciasUsuario().ultimaPaginaIndex = i;
    notifyListeners();
  }
}