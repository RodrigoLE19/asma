import 'package:asma/preferences/pref_usuarios.dart';
import 'package:asma/presentation/models/evaluations_results/screen_high_risk_view.dart';
import 'package:asma/presentation/models/evaluations_results/screen_low_risk_view.dart';
import 'package:asma/presentation/models/home/views/evaluations_view.dart';
import 'package:asma/presentation/models/home/views/user_profile_view.dart';
import 'package:asma/presentation/models/register_user/view/register_user_view.dart';
import 'package:asma/presentation/models/splash/view/screen_start.dart';
import 'package:asma/presentation/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import '../models/home/views/hist_evaluations_view.dart';
import '../models/home/views/home_view.dart';
import '../models/home/views/menu_home_view.dart';
import '../models/offine/view/offine_view.dart';
import '../models/sign_in/view/sign_in_view.dart';
import '../models/splash/view/splash_view.dart';

Map<String, Widget Function(BuildContext)> get appRoutes{
  var prefs=PreferenciasUsuario();
  return {
    Routes.splash: (context) => SplashView(),
    Routes.signIn: (context) => SignInView(),
    Routes.home: (context) => HomeView(),
    Routes.offline: (context) => OffineView(),
    Routes.registerUser: (context) => RegisterUserView(),
    Routes.screen_start: (context) => ScreenStart(),
    Routes.menu_home:(context)=>MenuHomeView(),
    Routes.user_profile: (context) => UserProfileView(),
    Routes.evaluations: (context) => EvaluationsView(),
    Routes.history_evaluations: (context) => HistoryEvaluationsView(),
    Routes.screen_high_risk: (context) => ScreenHighRiskView(),
    Routes.screen_low_risk: (context) => ScreenLowRiskView(),

  };
}