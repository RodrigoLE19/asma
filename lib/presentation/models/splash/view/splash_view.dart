import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../../main.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          _init();
        }
    );
  }

  Future<void>_init()async{
    final routeName=await() async{
      //SE USA CONTEXT.READ(), PORQUE ES LO MISMO QUE USAR PROVIDER.OF(CONTEXT)
      final ConnectivityRepository connectivityRepository=context.read();
      final AuthenticationRepository authenticationRepository= context.read();
      final SessionController sessionController=context.read();
      final hasInternet=await connectivityRepository.hasInternet;


      if(!hasInternet){
        return Routes.offline;
      }
      final isSignedIn= await authenticationRepository.isSigneIn;

      if(!isSignedIn){
        return Routes.signIn;
      }

      final user=await authenticationRepository.getUserData();
      if(user!=null){
        sessionController.setUser(user);
        return Routes.menu_home;
      }
      return Routes.signIn;
    }();
    if(mounted){
      _goTo(routeName);
    }
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:  SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}