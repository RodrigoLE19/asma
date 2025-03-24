
import 'package:asma/presentation/models/splash/view/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../register_user/view/register_user_view.dart';
import '../../sign_in/view/sign_in_view.dart';


class ScreenStart extends StatefulWidget {
  const ScreenStart({super.key});

  @override
  State<StatefulWidget> createState() => _ScreenStartState();
}

class _ScreenStartState extends State<ScreenStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D9CB1),
              Color(0xFF003E49),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/LogoApp.png',
              width: 300,
              height: 300,
            ),
            Text(
              "Respira Fácil",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF073D47), // Color de fondo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Bordes redondeados
                ),
                minimumSize: Size(250, 50), // Tamaño del botón
              ),
              onPressed: () {
                // Navega a la vista de cuestionario
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashView()),
                  /*MaterialPageRoute(builder: (context) => RegisterUserView()),*/
                );
              },
              child: Text(
                "Comenzar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}