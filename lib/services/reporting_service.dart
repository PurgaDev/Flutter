import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purga/model/server.dart';
import 'package:purga/services/authentification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportingService {
  final String baseUrl = "$server/api/reporting";
  final AuthentificationService authService = AuthentificationService();

  Future<Map?> createReporting(
      String description, File image, LatLng location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? authToken = prefs.getString("user_auth_token");
      if (authToken == null || authToken.isEmpty) {
        throw Exception("Vous devez vous authentifier");
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/create/'),
      );
      request.fields.addAll({
        'longitude': location.longitude.toString(),
        'latitude': location.latitude.toString(),
        'description': description,
      });
      request.headers.addAll({
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      });
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();
      if (response.statusCode == 201) {
        final data = json.decode(await response.stream.bytesToString());
        return {
          "message": "Signalement pris en compte.",
          "reporting": data,
        };
      } else if (response.statusCode == 400) {
        final data = json.decode(await response.stream.bytesToString());
        print("Données reçues : $data");
        if (data.containsKey('message')) {
          throw Exception(data['message']);
        }
        if (data.containsKey('image') && data['image'] != null) {
          throw Exception(data['image'][0]);
        }
      } else if (response.statusCode == 401) {
        authService.refreshToken();
        return await createReporting(description, image, location);
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("$e");
    }
    return null;
  }

  Future<List<dynamic>?> getReportingList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String? authToken = prefs.getString("user_auth_token");
      if (authToken == null || authToken.isEmpty) {
        throw Exception("Vous devez vous authentifiez");
      }
      String uri = "$baseUrl/my/";
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List.of(data);
      } else if (response.statusCode == 401) {
        authService.refreshToken();
        return await getReportingList();
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
  }
}
