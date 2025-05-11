
import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  static Future<http.Response> Evaluation(Map<String, dynamic> body) async {
    /*final ipURL = '192.168.1.6'; //LOCAL SERVIDOR
    //final ipURL = '172.20.10.5'; //LOCAL IP CELULAR
    final bodyJson=jsonEncode(body);
    return await http.post(
      headers: {
        'Content-Type': 'application/json',
      },

      Uri.parse(

          'http://$ipURL:8080/evaluation'),
      body: bodyJson,
    );*/
    // URL del servidor desplegado en Google Cloud Platform
    final ipURLGCP = 'https://modeloapitesis-532594014132.us-east1.run.app';

    // Asegurarse de que los valores sean del tipo correcto (números como números, no como strings)
    final Map<String, dynamic> formattedBody = {
      'questionIMC': double.tryParse(body['questionIMC'].toString()) ?? body['questionIMC'],
      'questionWheezing': int.tryParse(body['questionWheezing'].toString()) ?? body['questionWheezing'],
      'questionShortnessOfBreath': int.tryParse(body['questionShortnessOfBreath'].toString()) ?? body['questionShortnessOfBreath'],
      'questionChestTightness': int.tryParse(body['questionChestTightness'].toString()) ?? body['questionChestTightness'],
      'questionCoughing': int.tryParse(body['questionCoughing'].toString()) ?? body['questionCoughing'],
    };

    // Convertir el mapa a JSON correctamente
    final bodyJson = jsonEncode(formattedBody);

    print('DATOS ORIGINALES: $body');
    print('DATOS FORMATEADOS: $formattedBody');
    print('DATOS JSON: $bodyJson');

    try {
      final response = await http.post(
        Uri.parse('$ipURLGCP/evaluation'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: bodyJson,
      );

      print('CÓDIGO DE RESPUESTA: ${response.statusCode}');
      print('CUERPO DE RESPUESTA: ${response.body}');

      /*if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error del servidor: ${response.statusCode}');
        return null;
      }*/

      return response;
    } catch (e) {
      print('ERROR EN LA PETICIÓN: $e');
      rethrow;
    }
  }
}