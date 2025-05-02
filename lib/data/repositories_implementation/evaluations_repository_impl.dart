import 'package:asma/domain/models/evaluation.dart';
import 'package:asma/domain/models/evaluations_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/evaluations_repository.dart';

class EvaluationsRepositoryImpl implements EvaluationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> registerEvaluationUser(String nombrePaciente, Evaluation evaluation, String resultEvaluation, String uidUser) async{
    try {
      await _firestore.collection('evaluations').add({
        'nombrePaciente':nombrePaciente,
        'evaluation': evaluation.toMap(),
        // Asegúrate de tener un método toMap() en tu modelo Evaluation
        'resultEvaluation': resultEvaluation,
        'uidUser': uidUser,
        'createdAt': FieldValue.serverTimestamp(),
        'Evaluation':(resultEvaluation=='ALTO RIESGO')?'No Respondió':'No Necesario'
        // Guarda la fecha de creación
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

        return EvaluationsDetails(
          evaluation: evaluation,
          resultEvaluation: resultEvaluation,
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
      print("filtro por fecha");
      print(selectedDate);
      // Definir el rango de tiempo para el día seleccionado
      final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      // Realizar la consulta filtrando por uidUser y la fecha
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
}