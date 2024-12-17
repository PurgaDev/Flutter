import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purga/model/server.dart';

// Modèle de dépôt
class Deposit {
  final double latitude;
  final double longitude;
  final String description;
  final bool cleaned;

  Deposit({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.cleaned,
  });

  // Factory pour convertir un JSON en objet Deposit
  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
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
    // Récupérer le token depuis SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_auth_token');
    print("voici le token \n");
    print('Token récupéré : $token');
    print("\nFin token");

    if (token == null || token.isEmpty) {
      throw Exception(
          'Token d\'authentification manquant. Veuillez vous reconnecter.');
    }

    // Effectuer la requête HTTP avec le token dans l'en-tête
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Facultatif, selon l'API
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
