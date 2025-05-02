import 'package:asma/data/services/remote/authentication_firebase.dart';
import 'package:asma/preferences/pref_usuarios.dart';
import 'package:asma/presentation/global/controller/menu_home_provider_controller.dart';
import 'package:asma/presentation/global/controller/session_controller.dart';
import 'package:asma/presentation/my_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories_implementation/account_repository_impl.dart';
import 'data/repositories_implementation/authentication_repository_impl.dart';
import 'data/repositories_implementation/connectivity_repository_impl.dart';
import 'data/repositories_implementation/evaluations_repository_impl.dart';
import 'data/repositories_implementation/preferences_repository_impl.dart';
import 'data/services/remote/account_user_firebase.dart';
import 'data/services/remote/internet_checker.dart';
import 'domain/repositories/account_repository.dart';
import 'domain/repositories/authentication_repository.dart';
import 'domain/repositories/connectivity_repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'domain/repositories/evaluations_repository.dart';
import 'domain/repositories/preferences_repository.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuario.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferences=await SharedPreferences.getInstance();
  //final prefs = PreferenciasUsuario();
  runApp(
      MultiProvider(
        providers: [
          Provider<AccountRepository>(
            create: (_) => AccountRepositoryImpl(
              AccountUserFirebase(),
              FlutterSecureStorage(),
            ),
          ),
          Provider<PreferencesRepository>(
            create: (_) => PreferencesRepositoryImpl(preferences),
          ),
          Provider<ConnectivityRepository>(
            create: (_) => ConnectivityRepositoryImpl(
              Connectivity(),
              InternetChecker(),
            ),
          ),
          Provider<AuthenticationRepository>(
            create: (_) => AuthenticationRepositoryImpl(
              const FlutterSecureStorage(),
              AuthenticationFirebase()
              //AuthenticationGoogle(),
            ),
          ),
          Provider<EvaluationsRepository>(
            create: (_) => EvaluationsRepositoryImpl(),
          ),
          ChangeNotifierProvider<SessionController>(
            create: (_) => SessionController(),
          ),
          /*ChangeNotifierProvider<LanguageProviderController>(
            create: (_) => LanguageProviderController(),
          ),*/
          ChangeNotifierProvider<MenuHomeProviderController>(
            create: (_) => MenuHomeProviderController(),
          ),
        ],
        child: const MyApp(),
      ),
    );
    /*Injector(
      connectivityRepository: ConnectivityRepositoryImpl(
        Connectivity(),
        InternetChecker(),
      ),
      authenticationRepository: AuthenticationRepositoryImpl(
        const FlutterSecureStorage(),
        AuthenticationFirebase(),
      ),
      child: const MyApp(),
    ),*/
}
class CustomWillPopScope extends StatelessWidget {
  final Widget child;

  CustomWillPopScope({required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: child,
    );
  }
}

/*class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.connectivityRepository,
    required this.authenticationRepository,
  });

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;
  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector= context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }


}*/
