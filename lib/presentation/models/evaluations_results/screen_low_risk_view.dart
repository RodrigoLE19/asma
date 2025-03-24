
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ScreenLowRiskView extends StatefulWidget {
  const ScreenLowRiskView({super.key});

  @override
  State<ScreenLowRiskView> createState() => _ScreenLowRiskViewState();
}

class _ScreenLowRiskViewState extends State<ScreenLowRiskView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D9CB1),
              Color(0xFF003E49),
            ]
          )
        ),
        child: Column(
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
                    margin: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Color(0xFF2ECC71),
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
                            color: const Color(0xFF2ECC71), // Verde degradado inicial
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
                        const SizedBox(height: 70),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Su evaluación indica que presenta una crisis asmática leve',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2ECC71),
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}