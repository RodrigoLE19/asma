import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../domain/repositories/evaluations_repository.dart';
import '../../../global/controller/session_controller.dart';
import '../../../global/dialogs/show_modal_report.dart';

class HistoryEvaluationsView extends StatefulWidget {
  const HistoryEvaluationsView({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryEvaluationsViewState();
}

class _HistoryEvaluationsViewState extends State<HistoryEvaluationsView> {
  DateTime? selectedDate; // Variable para almacenar la fecha seleccionada
  late Future<QuerySnapshot> fetchEvaluationsByDate;
  String? selectedFilter = 'TODOS'; // Valor inicial

  String get formattedDate {
    if (selectedDate == null) {
      return ''; // Devuelve vacío si no hay fecha seleccionada.
    }
    return DateFormat('yyyy-MM-dd').format(selectedDate!);
  }

  // Función para mostrar el DatePicker
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024), // Establece la primera fecha disponible
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final user = sessionController.state!;
    Future<List<double>> calcularPromedioTiempoPorQuestionOne() {
      if (selectedDate == null) {
        // Si no se selecciona fecha y el filtro es 'TODOS', calcular el promedio de todas las postevaluaciones
        return context.read<EvaluationsRepository>()
            .calcularPromedioTiempoPostEvaluationAll();
      }  else if (selectedDate != null) {
        // Si se selecciona una fecha pero no se filtra por atención, calcular el promedio de esa fecha
        return context.read<EvaluationsRepository>()
            .calcularPromedioTiempoPostEvaluationByDate(selectedDate!);
      }  else {
        // Si no se cumple ninguna de las condiciones anteriores, retornar 0.0
        return Future.value([0.0,0.0]);
      }
    }
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('user').doc(user.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
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
          final DateTime fechaActual = DateTime.now();
          final DateFormat formato = DateFormat('dd/MM/yyyy');
          final String fechaActualFormateada = formato.format(fechaActual);
          final datosUsuario = userData['displayName'];
          final fetchEvaluations = context
              .read<EvaluationsRepository>()
              .fetchEvaluations(user.uid);
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
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
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
                                text: '$datosUsuario',
                                style: TextStyle(color: Colors.white, fontSize: 36),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                        SizedBox(height: 30,),
                        Text("Fecha actual: "+'$fechaActualFormateada',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Historial de Evaluaciones",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 10),
                              /*Text(
                                'Promedio tiempo pregunta 1: ${promedioTiempo.toStringAsFixed(2)} segundos',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),*/
                            ],
                          ),
                        ),
                        //CODIGO COMENTADO SIN TIEMPO
                        /*Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              //color: Color(0xFF2D9CB1),
                              child: Center(
                                child: Text(
                                  "Historial de Evaluaciones",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                            ),*/
                        SizedBox(height: 15,),
                        Container(
                            width: double.infinity,  // Hace que el botón ocupe todo el ancho
                            height: 40,  // Ajusta la altura del botón
                            decoration: BoxDecoration(
                              color: Color(0XFF2D9CB1),  // Color de fondo
                              borderRadius: BorderRadius.circular(0),  // Bordes redondeados
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,  // Centra el contenido del botón
                                    children: [
                                      Icon(
                                        size: 20,
                                        Icons.filter_list_rounded,  // Icono de calendario
                                        color: Colors.black,  // Color del icono
                                      ),
                                      SizedBox(width: 10),  // Espacio entre el icono y el texto
                                      Text(
                                        selectedDate == null
                                        //?AppLocalizations.of(context)!.filterDate
                                            ? 'Filtrar Fecha'
                                            : DateFormat('dd/MM/yyyy').format(selectedDate!),
                                        style: TextStyle(color: Colors.black,fontSize: 12),  // Estilo del texto
                                      ),
                                    ],
                                  ),
                                ),
                                //SizedBox(width: 40,),
                                SizedBox(width: 0,),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDate = null;
                                      selectedFilter = 'TODOS';
                                    });
                                  },
                                  icon: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,  // Centra el contenido del botón
                                    children: [
                                      Icon(
                                        size: 20,
                                        Icons.restart_alt,  // Icono de calendario
                                        color: Colors.black,  // Color del icono
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          width: double.infinity,
                          height: 300,
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          color: Color(0xFFD9D9D9),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: FutureBuilder<QuerySnapshot>(
                              future: selectedDate != null
                                  ? context
                                  .read<EvaluationsRepository>()
                                  .fetchEvaluationsByDate(user.uid, selectedDate!)
                                  : fetchEvaluations,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error al cargar evaluaciones'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text(
                                          'No hay evaluaciones disponibles'));
                                } else {
                                  final evaluations = snapshot.data!.docs;
                                  // Mostrar las evaluaciones dinámicamente en el Table
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                      border: TableBorder.symmetric(
                                        inside: BorderSide(width: 1, color: Colors.black),
                                      ),
                                      // Usamos IntrinsicColumnWidth para que el ancho se ajuste al contenido
                                      columnWidths: const <int, TableColumnWidth>{
                                        0: IntrinsicColumnWidth(),
                                        1: IntrinsicColumnWidth(),
                                        2: IntrinsicColumnWidth(),
                                        3: IntrinsicColumnWidth(),
                                        4: IntrinsicColumnWidth(),
                                        5: IntrinsicColumnWidth(),
                                      },
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(color: Color(0XFF2D9CB1)),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Resultado', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Tiempo Inicio (ml)', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Tiempo Fin (ml)', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Tiempo (ml)', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        ...evaluations.map((doc) {
                                          final data = doc.data() as Map<String, dynamic>;
                                          final createdAt = (data['createdAt'] as Timestamp).toDate();
                                          final resultEvaluation = data['resultEvaluation'] as String;

                                          final tiempoDeteccionInicioSinFormato = data['tiempoDeteccionInicio'] as String? ?? '';
                                          final tiempoDeteccionInicio = tiempoDeteccionInicioSinFormato.split(" ").length > 1
                                              ? tiempoDeteccionInicioSinFormato.split(" ")[1]
                                              : '';

                                          final tiempoDeteccionFinSinFormato = data['tiempoDeteccionFin'] as String? ?? '';
                                          final tiempoDeteccionFin = tiempoDeteccionFinSinFormato.split(" ").length > 1
                                              ? tiempoDeteccionFinSinFormato.split(" ")[1]
                                              : '';

                                          final resultTiempo = (data['resultTiempo'] as num?)?.toStringAsFixed(2) ?? '0.00';

                                          return _buildTableRow(
                                            DateFormat('dd/MM/yyyy').format(createdAt),
                                            DateFormat('HH:mm').format(createdAt),
                                            resultEvaluation,
                                            tiempoDeteccionInicio,
                                            tiempoDeteccionFin,
                                            resultTiempo,
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  );

                                }
                              },
                            ),
                          ),
                        ),
                        //Text("Average Atention Time:  min con  s."),
                        SizedBox(height: 20),
                        Container(
                          //alignment: Alignment.topLeft,
                          width: double.infinity,
                          height: 150,
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          color: Color(0xFFD9D9D9),
                          child: FutureBuilder<List<double>>(
                            // Llama a la función para obtener el promedio de tiempo
                            future: calcularPromedioTiempoPorQuestionOne(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                // Mostrar un indicador de carga mientras se obtienen los datos
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                print(snapshot.hasError);
                                // Manejo de errores
                                return Center(child: Text("Error al cargar el tiempo promedio"));
                              } else if (!snapshot.hasData) {
                                // Si no hay datos o el promedio es 0
                                return Center(child: Text("No hay datos para mostrar"));
                              } else {
                                // Mostrar el tiempo promedio calculado
                                double promedioMilisegundos = snapshot.data![0];
                                double cantidadRegistros = snapshot.data![1];
                                print(promedioMilisegundos);

                                String tiempoPromedioRedondeado = promedioMilisegundos.toStringAsFixed(0);
                                /*int minutos = promedioMinutos.floor();
                                int segundos = ((promedioMinutos - minutos) * 60).round();
                                double tiempo = minutos + segundos / 60;*/
                                // double tiempo = promedioMinutos.floor() +
                                //     double.parse(((promedioMinutos - promedioMinutos.floor()) * 60 / 60).toStringAsFixed(2));

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      //Divider(),
                                      /*Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho
                                                    child: ShowModalReport(
                                                      tableData: [
                                                        {'fecha': '2024-11-18', 'hora': '10:30', 'resultado': 'Positivo', 'seAtendio': 'Sí'},
                                                        {'fecha': '2024-11-18', 'hora': '11:00', 'resultado': 'Negativo', 'seAtendio': 'No'},
                                                        {'fecha': '2024-11-18', 'hora': '11:30', 'resultado': 'Positivo', 'seAtendio': 'Sí'},
                                                        {'fecha': '2024-11-19', 'hora': '09:00', 'resultado': 'Negativo', 'seAtendio': 'No'},
                                                        {'fecha': '2024-11-19', 'hora': '09:30', 'resultado': 'Negativo', 'seAtendio': 'Sí'},
                                                      ],
                                                      dateFromFilter: formattedDate,
                                                      timeProm: promedioMinutos
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   isScrollControlled: true, // Permitir scroll si el contenido es largo
                                            //   builder: (context) {
                                            //     return ShowModalReport(
                                            //       reportTitle: "Reporte de Actividad",
                                            //       reportDetails: "Aquí van los detalles del reporte.",
                                            //     );
                                            //   },
                                            // );
                                          }, icon: Icon(Icons.add_chart)),
                                          //Text("Tiempo Promedio de Detección: $promedioMinutos en ml"),
                                          //Text("Número de Casos Nuevos: $cantidadRegistros"),
                                          // Text("Exportar Excel")
                                        ],
                                      )*/
                                      _buildCardItem("Tiempo Promedio de Detección", "$tiempoPromedioRedondeado milisegundos"),
                                      SizedBox(height: 5),
                                      _buildCardItem("Número de Casos Nuevos", "$cantidadRegistros"),
                                      SizedBox(height: 5),
                                      _buildCardItem("Tasa de Aciertos", "80 %"),
                                    ],
                                  ),
                                );
                              }
                            },
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
      }
    );
  }

  Widget _buildCardItem(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20), // Espacio entre los cards
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con fondo azul que ocupa todo el ancho
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF2D9CB1), // Azul de fondo
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity, // Esto hace que el fondo ocupe todo el ancho
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white, // Texto blanco
              ),
            ),
          ),
          SizedBox(height: 6),
          // Contenido del valor debajo del encabezado
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(/*BuildContext context,*/ String fecha, String hora, String resultado,
      String tiempoInicio, String tiempoFin,String tiempo/*, String uidUser*/) {
    return TableRow(
      decoration: BoxDecoration(color: Color(0xFFE5EFF4)),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(fecha),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(hora),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(resultado),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(tiempoInicio),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(tiempoFin),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(tiempo),
        ),
      ],
    );
  }

}
