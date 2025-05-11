import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/evaluation.dart';
import '../models/evaluations_details.dart';

abstract class EvaluationsRepository{

  Future<void> registerEvaluationUser(
      String nombrePaciente,
      Evaluation evaluation,
      String resultEvaluation,
      double resultTiempo,
      String uidUser,
      );
  Future<List<EvaluationsDetails>> getEvaluationUser(
      String uidUser
      );
  Future<QuerySnapshot> fetchEvaluations(
      String userId
      );
  //Cargar Ultima Evaluacion Alto Riesgo
  Future<QuerySnapshot> loadLatestEvaluation(
      String uidUser
      );
  Future<QuerySnapshot> fetchEvaluationsByDate(String userId, DateTime selectedDate);
  Future<void> updateEvaluationField(String documentId);
  Future<Map<String, dynamic>> getLatestEvaluationStatus(String uidUser);

}