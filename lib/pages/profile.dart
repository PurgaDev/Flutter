import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purga/model/server.dart';
import 'package:purga/pages/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false; // Pour gérer le chargement
  Map<String, dynamic> _userData = {}; // Stocker les données utilisateur

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

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
    return null; // Retourne null si aucune donnée n'est sauvegardée
  }

  Future<void> loadInitialData() async {
    final cachedData = await loadUserData();
    if (cachedData != null) {
      setState(() {
        _userData = cachedData;
      });
    } else {
      await fetchUserData(); // Appelle l'API si aucune donnée n'est sauvegardée
    }
  }

  // Méthode pour récupérer les informations utilisateur
  Future<void> fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("user_auth_token");
    final String apiUrl = "$server/api/user/";

    try {
      if (authToken == null) {
        throw Exception("Vous devez vous authentifier.");
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() async {
          await saveUserData(data);
          _userData = data; // Stocker les données utilisateur
        });
      } else {
        print("Erreur lors du chargement des données utilisateur.");
      }
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Méthode pour déconnecter l'utilisateur
  Future<void> logoutUser() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("user_auth_token");
    final String apiUrl = "$server/api/user/logout/";

    try {
      if (authToken == null) {
        throw Exception("Vous devez vous authentifier.");
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        // Supprimer le token d'authentification
        await prefs.remove("user_auth_token");
        // ignore: use_build_context_synchronously
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print("Erreur lors de la déconnexion.");
      }
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // En-tête avec fond vert et bouton de déconnexion
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color(0xFF235F4E),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, right: 30),
                              child: InkWell(
                                onTap: logoutUser,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.logout, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Photo de profil avec crayon de modification
                   Transform.translate(
                        offset: const Offset(0, -50),
                        child: CircleAvatar(
                          radius: 95,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            size: 190,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),


                    // Nom et coordonnées (sans l'email)
                    Text(
                      "${_userData['first_name'] ?? ''} ${_userData['last_name'] ?? ''}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userData['phone_number'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    // Texte descriptif
                    const SizedBox(height: 50),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Une route propre ne dépend pas seulement de l'éfficacité su service de nettoyage, mais de l'éducation des personnes qui passent par là.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Pardon ne faites pas comme Dilane ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
        );
  }
}
