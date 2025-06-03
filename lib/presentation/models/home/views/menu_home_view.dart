import 'package:asma/presentation/global/dialogs/custom_navigator_bar.dart';
import 'package:asma/presentation/models/home/views/evaluations_view.dart';
import 'package:asma/presentation/models/home/views/user_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../preferences/pref_usuarios.dart';
import '../../../global/controller/menu_home_provider_controller.dart';
import '../../../global/controller/session_controller.dart';
import 'hist_evaluations_view.dart';

class MenuHomeView extends StatefulWidget {
  const MenuHomeView({super.key});

  @override
  State<MenuHomeView> createState() => _MenuHomeViewState();
}

class _MenuHomeViewState extends State<MenuHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeViewBody(),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }

}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    final SessionController sessionController=context.read();
    final user=sessionController.state!;
    var prefs=PreferenciasUsuario();
    storeToken(context, user.uid, prefs.token);
    print('TOKEN DE MOVIL: '+prefs.token);
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      prefs.tipoLogin = args['typeLogin'];
    }
    final uiProviderSelected = Provider.of<MenuHomeProviderController>(context);
    final currentIndex = uiProviderSelected.seleccionMenu;

    switch (currentIndex) {
      case 0:
        return EvaluationsView();
      case 1:
        return HistoryEvaluationsView();
      default:
        return UserProfileView();
    }
  }

  Future<void> storeToken(BuildContext context,String uid, String token) async {
    try{
      await context.read<AuthenticationRepository>().storeToken(uid, token);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"))
      );
    }
  }


}