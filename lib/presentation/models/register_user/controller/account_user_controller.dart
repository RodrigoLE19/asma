import 'package:flutter/cupertino.dart';

class AccountUserController extends ChangeNotifier{
  String _email='', _password='';
  bool _fetching=false;
  bool _obscureText = true;

  String get email=>_email;
  String get password=>_password;
  bool get fetching=>_fetching;
  bool get obscureText=>_obscureText;

  void onEmailChanged(String text){
    _email=text.trim().toLowerCase();
  }
  void onPasswordChanged(String text){
    _password=text.replaceAll(' ', '');
  }
  void onFetchingChanged(bool value){
    _fetching=value;
    notifyListeners();
  }
  void onObscureTextChanged(bool value){
    _obscureText=value;
    notifyListeners();
  }

}