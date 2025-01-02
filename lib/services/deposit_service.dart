import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purga/model/server.dart';
import 'package:purga/services/user_service.dart';

// Modèle de dépôt
class Deposit {
  final int id;
  final double latitude;
  final double longitude;
  final String description;
  final bool cleaned;

  Deposit({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.cleaned,
  });

  // Factory pour convertir un JSON en objet Deposit
  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'] ?? '',
      cleaned: json['cleaned'],
    );
  }
}

// Fonction pour récupérer les dépôts depuis l'API avec un token d'authentification
Future<List<Deposit>> fetchDeposits() async {
  final String url = '$server/api/deposit/read';

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_auth_token');

    if (token == null || token.isEmpty) {
      throw Exception(
          'Token d\'authentification manquant. Veuillez vous reconnecter.');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Deposit.fromJson(json)).toList();
    } else {
      throw Exception(
          'Erreur ${response.statusCode} : ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Erreur lors de la récupération des dépôts : $e');
    throw Exception('Impossible de charger les dépôts.');
  }
}

// Fonction pour récupérer le rôle de l'utilisateur
Future<String> getUserRole() async {
  final userService = UserService();
  final userData = await userService.loadUserData();
  return userData?['role'] ?? 'citizen'; // Rôle par défaut
}

Future<int?> getUserId() async {
  final userService = UserService();
  final userData = await userService.loadUserData();
  return userData?['pk']; // Retourne la clé primaire de l'utilisateur
}

// Fonction pour récupérer les itinéraires optimisés pour les chauffeurs
Future<List<List<LatLng>>> fetchRoutes() async {
  final String url = '$server/api/deposit/optimize/';
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('user_auth_token');

  if (token == null || token.isEmpty) {
    throw Exception(
        'Token d\'authentification manquant. Veuillez vous reconnecter.');
  }

  final int? userId =
      await getUserId(); // Récupération de l'identifiant utilisateur
  if (userId == null) {
    throw Exception('Identifiant utilisateur introuvable.');
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<List<LatLng>> routes = [];

    for (var route in data) {
      // Filtrer les itinéraires pour le chauffeur connecté
      if (route['driver_id'] == userId) {
        List<LatLng> points = (route['coordinates'] as List)
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        routes.add(points);
      }
    }

    return routes;
  } else {
    throw Exception('Erreur ${response.statusCode} : ${response.reasonPhrase}');
  }
}

Future<Map<String, dynamic>> markDepositAsCleaned({
  required int driverId,
  required int depositId,
}) async {
  final String url = '$server/api/deposit/createclean/';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'driver_id': driverId,
      'id': depositId,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erreur ${response.statusCode} : ${response.reasonPhrase}');
  }
}
