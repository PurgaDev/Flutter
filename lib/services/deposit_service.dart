import 'dart:convert';
import 'package:http/http.dart' as http;
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

// Fonction pour récupérer les dépôts depuis l'API
Future<List<Deposit>> fetchDeposits() async {
  final String url = '$server/api/deposit/read';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Deposit.fromJson(json)).toList();
  } else {
    throw Exception('Erreur lors du chargement des dépôts');
  }
}
