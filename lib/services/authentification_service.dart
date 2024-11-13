import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthentificationService {
  final String baseUrl = 'http://192.168.1.134:8000';

  Future<bool> sendPhoneNumber(String phoneNumber) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/login/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'phone_number': '+237$phoneNumber'}));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Echec de l'envoie du numero");
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }

  Future<String> verifyOtpCode(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login/verification/'),
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'phone_number': '+237$phoneNumber', 'otp_code': otp}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'];
      } else {
        throw Exception("Echec de verification du code otp");
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }
}
