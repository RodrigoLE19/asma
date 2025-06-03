import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../domain/repositories/evaluations_repository.dart';
import '../../../global/controller/session_controller.dart';

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
                          height: 550,
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
