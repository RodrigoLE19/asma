
import 'package:asma/presentation/models/evaluations_results/screen_high_risk_view.dart';
import 'package:asma/presentation/models/evaluations_results/screen_low_risk_view.dart';
import 'package:asma/presentation/models/home/views/evaluations_view.dart';
import 'package:asma/presentation/models/register_user/view/register_user_view.dart';
import 'package:asma/presentation/models/splash/view/screen_start.dart';
import 'package:asma/presentation/routes/routes.dart';
import 'package:flutter/cupertino.dart';

import '../models/home/views/history_evaluations_view.dart';
import '../models/home/views/home_view.dart';
import '../models/offine/view/offine_view.dart';
import '../models/sign_in/view/sign_in_view.dart';
import '../models/splash/view/splash_view.dart';

Map<String, Widget Function(BuildContext)> get appRoutes{
  return {

    Routes.splash: (context) =>  ScreenStart(),
    Routes.signIn: (context) => SignInView(),
    Routes.home: (context) => HomeView(),
    Routes.offine: (context) => OffineView(),
    Routes.registerUser: (context) => RegisterUserView(),
    Routes.screen_start: (context) => ScreenStart(),
    Routes.evaluations: (context) => EvaluationsView(),
    Routes.history_evaluations: (context) => HistoryEvaluationsView(),
    Routes.screen_high_risk: (context) => ScreenHighRiskView(),
    Routes.screen_low_risk: (context) => ScreenLowRiskView(),

  };
}