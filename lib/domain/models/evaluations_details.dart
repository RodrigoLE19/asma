import 'dart:ffi';

import 'evaluation.dart';

class EvaluationsDetails {
  final Evaluation evaluation;
  final String resultEvaluation;
  final String tiempoDeteccionInicio;
  final String tiempoDeteccionFin;
  final double resultTiempo;
  final DateTime date;
  final DateTime time;

  EvaluationsDetails({
    required this.evaluation,
    required this.resultEvaluation,
    required this.tiempoDeteccionInicio,
    required this.tiempoDeteccionFin,
    required this.resultTiempo,
    required this.date,
    required this.time,
  });
}