import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../routes/routes.dart';

class ScreenHighRiskView extends StatefulWidget {
  const ScreenHighRiskView({super.key});

  @override
  State<ScreenHighRiskView> createState() => _ScreenHighRiskViewState();
}

class _ScreenHighRiskViewState extends State<ScreenHighRiskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
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
              // Logo
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/LogoApp.png',
                  height: 150,
                  width: 150,
                ),
              ),
              SizedBox(height: 50),
              // Contenedor con resultado
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tarjeta con resultado
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                            // Encabezado
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFD73535),
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
                            // Texto del resultado
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Su evaluación indica un alto riesgo de desarrollar una crisis asmática',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFD73535),
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Recomendación
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Consulte a su médico lo antes posible y siga sus indicaciones",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Botón de Aceptar
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.menu_home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD73535),
                          minimumSize: Size(250, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Aceptar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

