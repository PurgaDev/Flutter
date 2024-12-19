// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purga/model/server.dart';

class UserService {
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("user_auth_token");
    final String apiUrl = "$server/api/user/";

    if (authToken == null) {
      throw Exception("Vous devez vous authentifier.");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveUserData(data);
      return data;
    } else {
      throw Exception("Erreur lors du chargement des données utilisateur.");
    }
  }
}
