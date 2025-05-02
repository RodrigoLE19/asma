
import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  static Future<http.Response> Evaluation(Map<String, String> body) async {
    final ipURL = '192.168.1.8'; //LOCAL SERVIDOR
    final bodyJson=jsonEncode(body);
    return await http.post(
      headers: {
        'Content-Type': 'application/json',
      },

      Uri.parse(

          'http://$ipURL:8080/evaluation'),
      body: bodyJson,
    );
  }

}