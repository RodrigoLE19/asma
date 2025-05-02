import 'package:asma/main.dart';
import 'package:asma/presentation/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../global/controller/session_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final user = sessionController.state;

    // Verifica si el usuario es null
    if (user == null) {
      // Si el usuario es null, puedes redirigir a la pantalla de inicio de sesión o mostrar un mensaje
      Future.microtask(() {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.signIn, (Route<dynamic> route) => false);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Muestra un indicador de carga mientras redirige
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text(user.gender?.isEmpty ?? true ? 'Actualizar' : user.gender ?? 'Desconocido'),
            Text(user.displayName ?? 'Usuario'),
            TextButton(
              onPressed: () async {
                await context.read<AuthenticationRepository>().singOut();
                sessionController.signOut();
                //await GoogleSignIn().signOut();
                //await context.read<AuthenticationRepository>().signOutGoogle();

                Navigator.of(context).pushNamedAndRemoveUntil(Routes.signIn, (Route<dynamic> route) => false);
              },
              child: const Text("CERRAR SESION", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
    /*return Scaffold(
      body: Center(
        child: TextButton(onPressed: () async {
          await context.read<AuthenticationRepository>().singOut();
          sessionController.signOut();
          Navigator.pushReplacementNamed(
            context,
            Routes.signIn,
          );
        },
          child: Text('Sing out'),
        ),
      ),
    );*/
  }
}
