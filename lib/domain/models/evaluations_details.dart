import 'dart:ffi';

import 'evaluation.dart';

class EvaluationsDetails {
  final Evaluation evaluation;
  final String resultEvaluation;
  final double resultTiempo;
  final DateTime date;
  final DateTime time;

  EvaluationsDetails({
    required this.evaluation,
    required this.resultEvaluation,
    required this.resultTiempo,
    required this.date,
    required this.time,
  });
}