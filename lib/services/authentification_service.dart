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
      } else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await sendPhoneNumber(phoneNumber);
      } else {
        print("$phoneNumber ${response.body}");
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<Map<String, String>> verifyOtpCode(
      String phoneNumber, String otp) async {
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
          return {'access': data['access'], 'refresh': data['refresh']};
        } else if (response.statusCode == 401) {
          final AuthentificationService authService = AuthentificationService();
          authService.refreshToken();
          return await verifyOtpCode(phoneNumber, otp);
        } else {
          print(response.body);
          throw Exception(response.reasonPhrase);
        }
      } else {
        print(response.body);
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }

  Future<bool> register(
      String firstname, String lastname, String phoneNumber) async {
    try {
      final url = Uri.parse('$baseUrl/register/');
      final requestBody = {
        'first_name': firstname,
        'last_name': lastname,
        'phone_number': "+237$phoneNumber",
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Enregistrement réussi : ${response.body}');
        return true;
      } else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await register(firstname, lastname, phoneNumber);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> data = await json.decode(response.body);
        if (data.containsKey("phone_number")) {
          throw Exception(data['phone_number'][0]);
        }
      } else {
        print('Erreur serveur : ${response.reasonPhrase}');
        print(response.headers);
        throw Exception(
            '${response.reasonPhrase}'); // Retourne false en cas d'erreur serveur
      }
    } catch (e) {
      print('Erreur réseau : $e');
      throw Exception("$e");
    }
    return true;
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
      } else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await refreshToken();
      } else {}
    } catch (e) {}
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("user_auth_token");
    final String? refreshToken = prefs.getString("auth_refresh_token");
    final String apiUrl = "$server/api/user/logout/";

    if (authToken == null || refreshToken == null) {
      throw Exception("Vous devez vous authentifier.");
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"refresh_token": refreshToken},
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      await prefs.setString("user_auth_token", "");
      await prefs.remove("user_auth_token");
    } else {
      print(response.body);
      throw Exception("Erreur lors de la déconnexion.");
    }
  }
}
