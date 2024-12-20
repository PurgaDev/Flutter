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
      }
      else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await sendPhoneNumber(phoneNumber);
      } 
       else {
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
        }
        else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await verifyOtpCode(phoneNumber,otp);
      } 
         else {
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
      final url = Uri.parse('$baseUrl/register/');
      final requestBody = {
        'first_name': firstname,
        'last_name': lastname,
        'phone_number': phoneNumber,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Enregistrement réussi : ${response.body}');
        return true;
      } 
      else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await register(firstname,lastname,phoneNumber);
      } 
      else {
        print('Erreur serveur : ${response.reasonPhrase}');
        return false; // Retourne false en cas d'erreur serveur
      }
    } catch (e) {
      print('Erreur réseau : $e');
      throw Exception("Erreur réseau : $e");
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
      } 
      else if (response.statusCode == 401) {
        final AuthentificationService authService = AuthentificationService();
        authService.refreshToken();
        return await refreshToken();
      } 
      else {}
    } catch (e) {}
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("user_auth_token");
    final String apiUrl = "$server/api/user/logout/";

    if (authToken == null) {
      throw Exception("Vous devez vous authentifier.");
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      await prefs.remove("user_auth_token");
    } else {
      throw Exception("Erreur lors de la déconnexion.");
    }
  }

}
