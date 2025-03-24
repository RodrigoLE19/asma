
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../evaluations_results/screen_high_risk_view.dart';

class EvaluationsView extends StatefulWidget {
  const EvaluationsView({super.key});

  @override
  State<StatefulWidget> createState() => _EvaluationsViewState();
}

class _EvaluationsViewState extends State<EvaluationsView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(), // Muestra el contenido dinámico según la pestaña
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2D9CB1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Evaluación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Mis Evaluaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Estadisticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF003E49),
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Mantiene todas las pestañas visibles
      ),
    );
  }
  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildEvaluationPage();
      case 1:
        return _buildHistoryPage();
      case 2:
        return _buildStatisticsPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildEvaluationPage();
    }
  }
  Widget _buildEvaluationPage() {
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
                          text: "Rodrigo",
                          style: TextStyle(color: Color(0xFF073D47), fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Completa el formulario para determinar el nivel de tu crisis asmática",
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
                  buildQuestionCard("2. ¿Tienes dificultad para respirar?"),
                  // Pregunta 3
                  buildQuestionCard("3. ¿Tienes tos?"),
                  // Pregunta 4
                  buildQuestionCard("4. ¿Le silba el pecho?"),
                  // Pregunta 5
                  buildQuestionCard("5. ¿Sientes opresión en el pecho?"),
                  // Pregunta 6
                  buildQuestionCard("6. ¿Tiene dificultad para hablar?"),
                  // Pregunta 7
                  buildQuestionCard("7. ¿Puedes hablar oraciones largas?"),
                  // Pregunta 8
                  buildQuestionCard("8. Tu respiración es mas rapida que lo normal?"),
                  // Pregunta 9
                  buildQuestionCard("9. ¿Notas que usas los músculos del cuello o de las costillas para respirar?"),
                  // Pregunta 10
                  buildQuestionCard("10. ¿Escuchas un sonido silbante cuando respiras?"),
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
                        Navigator.push(
                          context,
                          //MaterialPageRoute(builder: (context) => ScreenMildGravityView()),
                          MaterialPageRoute(builder: (context) => ScreenHighRiskView()),
                        );
                      },
                      child: Text(
                        "Enviar",
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
              onPressed: () {},
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
                  // Lógica de cálculo del IMC
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
              keyboardType: TextInputType.text,
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

  Widget buildQuestionCard(String questionText) {
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
              ElevatedButton(onPressed: () {},
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
              // Título de la pregunta

              SizedBox(height: 15),
              // Botones "Sí" y "No"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildResponseButton("Sí"),
                  buildResponseButton("No"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResponseButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Acción al presionar
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Color(0xFF2D9CB1)),
        ),
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0, // Sin sombra
      ),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF2D9CB1), fontSize: 16),
      ),
    );
  }
}
// Página de Historial
Widget _buildHistoryPage() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/LogoApp.png',
                        height: 150,
                        width: 150,
                      ),
                      Text(
                        "Hola, Rodrigo",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          // Contenedor blanco con fecha y título
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
                // Fecha actual
                Text(
                  "Fecha: 24/1/2025",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 10),
                // Título del historial con fondo azul
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  //color: Color(0xFF2D9CB1),
                  child: Center(
                    child: Text(
                      "Historial de Evaluaciones",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Filtro por fecha con fondo azul
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D9CB1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Fecha desde:",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "--/--/--",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white24,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Fecha hasta:",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "--/--/--",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white24,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(Icons.refresh, color: Color(0xFF2D9CB1)),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Tabla de resultados
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Color(0xFF2D9CB1)),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Color(0xFFDFEFF2)),
                    columns: [
                      DataColumn(
                        label: Text(
                          "Fecha",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Hora",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Resultado",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text("25/1/2025")),
                        DataCell(Text("18:00")),
                        DataCell(Text("Gravedad Leve")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("26/1/2025")),
                        DataCell(Text("13:15")),
                        DataCell(Text("Gravedad Severa")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("27/1/2025")),
                        DataCell(Text("10:30")),
                        DataCell(Text("Gravedad Leve")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("28/1/2025")),
                        DataCell(Text("9:00")),
                        DataCell(Text("Gravedad Leve")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("29/1/2025")),
                        DataCell(Text("8:15")),
                        DataCell(Text("Gravedad Severa")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("30/1/2025")),
                        DataCell(Text("19:30")),
                        DataCell(Text("Gravedad Leve")),
                      ]),
                    ],
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

// Pagina de Indicadores
Widget _buildStatisticsPage() {
  return Center(
    child: Text(
      "Indicadores",
      style: TextStyle(fontSize: 24),
    ),
  );
}

// Página de Perfil
Widget _buildProfilePage() {
  return Center(
    child: Text(
      "Página de Perfil",
      style: TextStyle(fontSize: 24),
    ),
  );
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EvaluationsView(),
  ));

}