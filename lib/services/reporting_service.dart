import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purga/model/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportingService {
  final String baseUrl = "$server/api/reporting";

  Future<String> createReporting(
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
        return "Signalement pris en compte.";
      } else if (response.statusCode == 400) {
        final data = json.decode(await response.stream.bytesToString());
        if (data['image']) {
          throw Exception(data['image'][0]);
        }
        if (data['message']) {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception("Erreur reseau: $e");
    }
    return "";
  }
}
