import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../routes/routes.dart';

class ScreenStart extends StatelessWidget {
  const ScreenStart({super.key});

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
                Navigator.pushReplacementNamed(context, Routes.splash);

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

