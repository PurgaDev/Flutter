import 'dart:convert';
import 'package:purga/model/server.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationService {
  final String baseUrl = '$server/api/user';

  Future<bool> sendPhoneNumber(String phoneNumber) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/login/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'phone_number': '+237$phoneNumber'}));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }

  Future<String> verifyOtpCode(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/verification/'),
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({'phone_number': '+237$phoneNumber', 'otp_code': otp}),
      );
      if (response.statusCode == 200) {
        final response = await http.post(
          Uri.parse('$baseUrl/token/'),
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'phone_number': '+237$phoneNumber', 'otp_code': otp}),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['access'];
        } else {
          throw Exception(response.reasonPhrase);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }

  Future<bool> register(
      String firstname, String lastname, String phoneNumber) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/register/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phone_number': phoneNumber,
            'fisrt_name': firstname,
            'last_name': lastname
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Erreur reseau: $e');
    }
  }

  Future<void> refreshToken() async {
    String uri = "$baseUrl/token/refresh";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse(uri),
        body: {"refresh": prefs.getString('auth_refresh_token')},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await prefs.setString("user_auth_token", data['access']);
      } else {}
    } catch (e) {}
  }
}
