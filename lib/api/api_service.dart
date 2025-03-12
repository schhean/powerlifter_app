import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.api-ninjas.com/v1/exercises?muscle=';
  final String apiKey = 'MXmk5gbRiERxTpaP34XKkg==M3zmUKpMVDGeut0H';

  Future<List<dynamic>> fetchData(String muscle) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$muscle'),
        headers: {
          'X-Api-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Conversion en liste dynamique #current
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la requête API : $error');
    }
  }
}
