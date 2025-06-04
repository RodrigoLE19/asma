import 'dart:ffi';

import 'package:asma/domain/models/evaluation.dart';
import 'package:asma/domain/models/evaluations_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../domain/repositories/evaluations_repository.dart';

class EvaluationsRepositoryImpl implements EvaluationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> registerEvaluationUser(Evaluation evaluation, 
  String resultEvaluation, String tiempoDeteccionInicio, 
  String tiempoDeteccionFin, double resultTiempo, 
  String uidUser) async{
    try {
      await _firestore.collection('evaluations').add({
        'evaluation': evaluation.toMap(),
        'resultEvaluation': resultEvaluation,
        'tiempoDeteccionInicio': tiempoDeteccionInicio,
        'tiempoDeteccionFin': tiempoDeteccionFin,
        'resultTiempo': resultTiempo,
        'uidUser': uidUser,
        'createdAt': FieldValue.serverTimestamp(),
        'Evaluation':(resultEvaluation=='ALTA PROBABILIDAD')?'No Respondió':'No Necesario'
      });
    } catch (e) {
      // Manejar el error
      print("Error al registrar la evaluación: $e");
      throw e;
    }
  }

  @override
  Future<List<EvaluationsDetails>> getEvaluationUser(String uidUser) async{
    try {
      final querySnapshot = await _firestore
          .collection('evaluations')
          .where('uidUser', isEqualTo: uidUser)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Aquí se mapean los datos específicos de la clase Evaluation
        final evaluation = Evaluation(
          questionIMC: data['questionIMC'],
          questionWheezing: data['questionWheezing'],
          questionShortnessOfBreath: data['questionShortnessOfBreath'],
          questionChestTightness: data['questionChestTightness'],
          questionCoughing: data['questionCoughing'],
        );
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final resultEvaluation = data['resultEvaluation'] as String;
        //final resultTiempo = data['resultTiempo'] as double;
        print(data);
        final tiempoDeteccionInicio = data['tiempoDeteccionInicio'] as String;
        final tiempoDeteccionFin = data['tiempoDeteccionFin'] as String;
        final resultTiempo = (data['resultTiempo'] as double?) ?? 0.0;

        return EvaluationsDetails(
          evaluation: evaluation,
          resultEvaluation: resultEvaluation,
          tiempoDeteccionInicio: tiempoDeteccionInicio,
          tiempoDeteccionFin: tiempoDeteccionFin,
          resultTiempo: resultTiempo,
          date: createdAt,
          time: createdAt,
        );
      }).toList();
    } catch (e) {
      print("Error en getEvaluationUser: $e");
      throw Exception('Error al obtener evaluaciones: $e');
    }
  }

  @override
  //Funcion para traer las evaluaciones con todas sus fechas
  Future<QuerySnapshot> fetchEvaluations(String userId) async{
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('evaluations')
          .where('uidUser', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot;
    } catch (e) {
      throw Exception('Error al obtener evaluaciones: $e');
    }
  }

  @override
  //Funcion para traer las evaluaciones filtrandolas por una fecha
  Future<QuerySnapshot> fetchEvaluationsByDate(String userId, DateTime selectedDate) async{
    try {
      final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('evaluations')
          .where('uidUser', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot;
    } catch (e) {
      throw Exception('Error al obtener evaluaciones por fecha: $e');
    }
  }

  /*Future<double> calcularPromedioTiempoEvaluation(DateTime fechaFiltro, int questionOneValue) async{
    try {
      // Convertir la fecha de filtro a un rango de inicio y fin para la consulta
      DateTime startOfDay = DateTime(fechaFiltro.year, fechaFiltro.month, fechaFiltro.day);
      DateTime endOfDay = DateTime(fechaFiltro.year, fechaFiltro.month, fechaFiltro.day, 23, 59, 59);
      
      final querySnaphot = await FirebaseFirestore.instance.collection('evaluation').where('evaluation.questionOne')
    }

  }*/

  @override
  Future<Map<String, dynamic>> getLatestEvaluationStatus(String uidUser) async {

    final snapshot = await _firestore
        .collection('evaluations')
        .where('uidUser', isEqualTo: uidUser)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return {'highRisk': false, 'responded': false};
    }

    final evaluationData = snapshot.docs.first.data() as Map<String, dynamic>;
    final isHighRisk = evaluationData['resultEvaluation'] == 'ALTO RIESGO';
    print("RESULTADO EVALUACION: $isHighRisk");
    final responded = evaluationData['Evaluation'] == 'No Respondió';
    print("RESULTADO ENCUESTA: $responded");
    return {'highRisk': isHighRisk, 'responded': responded};
  }

  @override
  Future<QuerySnapshot<Object?>> loadLatestEvaluation(String uidUser) async{
    try {
      final querySnapshot = await _firestore
          .collection('evaluations')
          .where('resultEvaluation', isEqualTo: 'ALTO RIESGO')
          .where('Evaluation', isEqualTo: 'No Respondió')
          .where('uidUser', isEqualTo: uidUser)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      return querySnapshot;
    } catch (e) {
      throw Exception('Error al obtener evaluaciones: $e');
    }
  }


  @override
  Future<void> updateEvaluationField(String documentId) async {
    try {
      var evaluationsRef = _firestore.collection('evaluations').doc(documentId);
      await evaluationsRef.update({
        'Evaluation': 'Respondió',
      });
      print("Evaluación actualizada exitosamente.");
    } catch (e) {
      print("Error al actualizar la evaluación: $e");
    }
  }

  Future<List<double>> calcularPromedioTiempoPostEvaluationAll() async {
    try {
      final startOfDay = DateTime(2025, 5, 23, 00, 00, 00);
      // Construir la consulta con filtros opcionales
      final querySnapshot = await FirebaseFirestore.instance.collection('evaluations')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .get();

      // Agregar filtro por fecha si se proporciona
      /*if (fechaFiltro != null) {
        DateTime startOfDay = DateTime(fechaFiltro.year, fechaFiltro.month, fechaFiltro.day);
        DateTime endOfDay = startOfDay.add(Duration(days: 1));
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
            .where('createdAt', isLessThan: endOfDay);
      }*/

      // Agregar filtro personalizado si se proporciona
      /*if (campoFiltro != null && valorFiltro != null) {
        query = query.where(campoFiltro, isEqualTo: valorFiltro);
      }*/

      //final querySnapshot = await query.get();

      /*if (querySnapshot.docs.isEmpty) {
        print("No hay registros en la colección evaluations.");
        return 0.0;
      }*/

      double totalTiempo = 0;
      int count = 0;

      // Iterar sobre los documentos y sumar los valores de resultTiempo
      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Verificar que existe el campo resultTiempo
        if (data['resultTiempo'] != null) {
          // Convertir a double en caso de que sea int o String
          double tiempoValue = 0;

          if (data['resultTiempo'] is num) {
            tiempoValue = data['resultTiempo'].toDouble();
          } else if (data['resultTiempo'] is String) {
            tiempoValue = double.tryParse(data['resultTiempo']) ?? 0;
          }

          totalTiempo += tiempoValue;
          count++;

          // Debug: mostrar cada valor
          print('Documento ID: ${doc.id}, resultTiempo: $tiempoValue');
        }
      }

      // Calcular el promedio
      double promedio = count > 0 ? totalTiempo / count : 0.0;

      print('Total documentos procesados: $count');
      print('Suma total de tiempos: $totalTiempo');
      print('Promedio calculado: ${promedio.toStringAsFixed(2)}');

      return [promedio, count.toDouble()];

    } catch (e) {
      throw Exception('Error al calcular el promedio de tiempo en postevaluation: $e');
    }
  }

  Future<List<double>> calcularPromedioTiempoPostEvaluationByDate(DateTime selectedDate) async {
    try {
      // Definir el rango de fechas
      DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));
      final querySnapshot = await FirebaseFirestore.instance
          .collection('evaluations')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThan: endOfDay)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No hay registros para esa fecha.");
        return [0.0,0.0]; // Retorna 0 si no hay registros
      }

      double totalMilisegundos = 0;
      int count = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        if (data['createdAt'] != null) {
          // Convertir a double en caso de que sea int o String
          double tiempoValue = 0;

          if (data['resultTiempo'] is num) {
            tiempoValue = data['resultTiempo'].toDouble();
          } else if (data['resultTiempo'] is String) {
            tiempoValue = double.tryParse(data['resultTiempo']) ?? 0;
          }

          totalMilisegundos += tiempoValue;
          count++;

          // Debug: mostrar cada valor
          print('Documento ID: ${doc.id}, resultTiempo: $tiempoValue');
        }
      }
      double promedio = count > 0 ? totalMilisegundos / count : 0.0;
      return [promedio, count.toDouble()];

    } catch (e) {
      throw Exception('Error al calcular el promedio de tiempo en postevaluation por fecha: $e');
    }
  }


}