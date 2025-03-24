import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/views/evaluations_view.dart';

class ScreenHighRiskView extends StatefulWidget {
  const ScreenHighRiskView({super.key});

  @override
  State<ScreenHighRiskView> createState() => _ScreenSevereGravityViewState();
}

class _ScreenSevereGravityViewState extends State<ScreenHighRiskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2D9CB1),
                  Color(0xFF003E49),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/LogoApp.png',
                      height: 150,
                      width: 150,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 120, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Color(0xFFD73535),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD73535), // Verde degradado inicial
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            'RESULTADO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Su evaluación indica que presenta una crisis asmática severa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFD73535),
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Botón en el fondo de la pantalla
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF073D47),
              ),
              child: GestureDetector(
                onTap: () {
                  // Navega a la vista de cuestionario
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EvaluationsView()),
                  );
                },
                child: Center(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
