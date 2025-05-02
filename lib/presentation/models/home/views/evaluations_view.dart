import 'dart:convert';
import 'package:asma/domain/models/evaluation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/http/http.dart';
import '../../../../domain/repositories/evaluations_repository.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';
import '../../evaluations_results/screen_high_risk_view.dart';

class EvaluationsView extends StatefulWidget {
  const EvaluationsView({super.key});

  @override
  State<StatefulWidget> createState() => _EvaluationsViewState();
}

class _EvaluationsViewState extends State<EvaluationsView> {
  final TextEditingController _peso= TextEditingController();
  final TextEditingController _altura = TextEditingController();
  final TextEditingController _resultadoIMC = TextEditingController();

  Map<int, String> respuestas = {};
  bool highRiskGlobal = false;
  bool respondeGlobal = false;

  Future<Map<String, dynamic>>? evaluationsFuture;
  int? _Wheezing;
  int? _ShortnessOfBreath;
  int? _ChestTightness;
  int? _Coughing;
  double imcResult = 0;

  String? _errorMessage;
  String? _errorMessageMentHlth;
  String _nombrePaciente = '';
  String _generoPaciente = 'MASCULINO';
  bool _isEvaluar = false; // Indica si se va a evaluar a otra persona

  void _onWheezingChanged(int? value) {
    setState(() {
      _Wheezing = value;
    });
  }

  void _onShortnessOfBreathChanged(int? value) {
    setState(() {
      _ShortnessOfBreath = value;
    });
  }

  void _onChestTightnessChanged(int? value) {
    setState(() {
      _ChestTightness = value;
    });
  }

  void _onCoughingChanged(int? value) {
    setState(() {
      _Coughing = value;
    });
  }

  bool _validateFields() {
    return _nombrePaciente!=null || _nombrePaciente!=null &&
      _Wheezing != null &&
      _ShortnessOfBreath != null &&
      _ChestTightness != null &&
      _Coughing != null &&
      imcResult !=0;

  }

  int convertirGenero(String genero) {
    if (genero.toLowerCase() == 'masculino') {
      return 1;
    } else if (genero.toLowerCase() == 'femenino') {
      return 0;
    } else {
      return 2;
    }
  }

  bool validarRespuestas() {
    return respuestas.length == 4 && !respuestas.values.contains('');
  }

  void resultadoIMC(double peso, double altura) {
    double altura_cm = altura / 100;
    double imc = peso / (altura_cm * altura_cm);
    // Convertirlo a 2 decimales por si acaso
    String resultado = imc.toStringAsFixed(2);

    setState(() {
      _resultadoIMC.text = resultado;
    });
  }

  Future<void> _EvaluateQustionary(BuildContext context, String nombrePaciente, String generoPaciente, fechaNacimientoPaciente, bool isEvaluar,
      String uidUser) async{
    if (validarRespuestas() && _resultadoIMC.text.isNotEmpty) {
      print('Todas las preguntas fueron respondidas: $respuestas');
      double resultado_IMC = double.parse(_resultadoIMC.text);
      int resultado_pregunta2 = respuestas[2] == "Sí" ? 1 : 0;
      int resultado_pregunta3 = respuestas[3] == "Sí" ? 1 : 0;
      int resultado_pregunta4 = respuestas[4] == "Sí" ? 1 : 0;
      int resultado_pregunta5 = respuestas[5] == "Sí" ? 1 : 0;
      Evaluation evaluation = Evaluation(
          questionIMC: resultado_IMC,
          questionWheezing: resultado_pregunta2,
          questionShortnessOfBreath: resultado_pregunta3,
          questionChestTightness: resultado_pregunta4,
          questionCoughing: resultado_pregunta5);
      // Convertir la instancia a un mapa
      Map<String, dynamic> evaluationMap = evaluation.toMap();

      // Convertir los valores del mapa a strings para el cuerpo del POST
      Map<String, String> body =
      evaluationMap.map((key, value) => MapEntry(key, value.toString()));
      //print(nombrePaciente);
      print("CUERPO BODY");
      print(body.toString());
      try {
        final response = await Http.Evaluation(body);
        print("RESPONSE");
        print(response.statusCode);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String resultModel = data['AsthmaDiagnosis'];
        final String formateoResultadoModelo =
        resultModel.toString().replaceAll(RegExp(r'[\[\]\{\}]'), '');
        final String resultadoModeloTraducido;
        // Mostrar el resultado en un Snackbar
        if (response.statusCode == 200) {
          if (formateoResultadoModelo == '0') {
            Navigator.pushReplacementNamed(context, Routes.screen_low_risk);
            resultadoModeloTraducido = 'BAJO RIESGO';
            print(resultadoModeloTraducido);
          } else {
            Navigator.pushReplacementNamed(context, Routes.screen_high_risk);
            resultadoModeloTraducido = 'ALTO RIESGO';
            print(resultadoModeloTraducido);
          }
          _registerEvaluationUser(
              context, evaluation, resultadoModeloTraducido, uidUser);

        } else {
          print("Error: ${response.statusCode}");
        }
      } catch (e) {
        print("CATCH DE LA EVALUATION");
        print("Error: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, responde todas las preguntas')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final user = sessionController.state!;
    //final userData = snapshot.data!.data() as Map<String, dynamic>;
    final String uidUser = user.uid;
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('user').doc(user.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
              color: Color(0xFF2B6178),
              child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.grey,
                  )
              )
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No user data available'));
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final datosUsuario = userData['displayName'];
          return Scaffold(
            body: _buildEvaluationPage(uidUser,datosUsuario), // Muestra el contenido dinámico según la pestaña
          );
        }

      }
    );
  }

  Widget _buildEvaluationPage(String uidUser, String nombreUsuario) {
    return Container(
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/LogoApp.png',
                    height: 120,
                    width: 120,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Hola, ",
                          style: TextStyle(color: Colors.white, fontSize: 36),
                        ),
                        TextSpan(
                          text: nombreUsuario,
                          style: TextStyle(color: Color(0xFF073D47), fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Completa el formulario para determinar el nivel de riesgo de crisis asmática",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    //textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Formulario
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Pregunta 1 - Índice de masa corporal
                  buildIMCQuestion(),
                  SizedBox(height: 20),
                  // Pregunta 2
                  buildQuestionCard("2. ¿Le silba el pecho?",2),
                  // Pregunta 3
                  buildQuestionCard("3. ¿Tiene dificultad para respirar?",3),
                  // Pregunta 4
                  buildQuestionCard("4. ¿Sientes opresion o dolor en el pecho?",4),
                  // Pregunta 5
                  buildQuestionCard("5. ¿Tienes tos?",5),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF073D47), // Color de fondo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // Bordes redondeados
                        ),
                        minimumSize: Size(250, 50), // Tamaño del botón
                      ),
                      onPressed: () {
                        // Navega a la vista de cuestionario
                        _EvaluateQustionary(context, "Rodrigo", "Masculino", "19/09/2001", _isEvaluar, uidUser);
                      },
                      child: Text(
                        "Evaluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget buildIMCQuestion() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2D9CB1),
              ),
              child: Text(
                '1. ¿Cuál es tu índice de masa corporal?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _peso,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _altura,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      prefixIcon: Icon(Icons.height),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  resultadoIMC(double.parse(_peso.text), double.parse(_altura.text));
                  //print(double.parse(_peso.text));
                  //print(double.parse(_altura.text));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003E49),
                ),
                child: Text('Calcular',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _resultadoIMC,
              keyboardType: TextInputType.text,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Resultado',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionCard(String questionText, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D9CB1),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                ),
                child: Text(
                  questionText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildResponseButton("Sí", index),
                  buildResponseButton("No", index),
                ],
              ),
              if (respuestas[index] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Respuesta: ${respuestas[index]}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResponseButton(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          respuestas[index] = text;
        });
        print("Pregunta $index -> $text");
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Color(0xFF2D9CB1)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF2D9CB1), fontSize: 16),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EvaluationsView(),
  ));

}

Future<void> _registerEvaluationUser(BuildContext context,
    Evaluation evaluation, String resultEvaluation, String uidUser) async {
  try {
    await context
        .read<EvaluationsRepository>()
        .registerEvaluationUser("Rodrigo", evaluation, resultEvaluation, uidUser);
    print('Registro exitoso');
  } catch (e) {
    print('Error al registrar la evaluación: $e');
  }
}