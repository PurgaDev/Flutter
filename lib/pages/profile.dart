import 'package:flutter/material.dart';
import 'package:purga/pages/login.dart';
import 'package:purga/services/user_service.dart';
import 'package:purga/services/authentification_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final _authService = AuthentificationService();

  bool _isLoading = false;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      final cachedData = await _userService.loadUserData();
      if (cachedData != null) {
        setState(() => _userData = cachedData);
      } else {
        await fetchUserData();
      }
    } catch (e) {
      print("Erreur: $e");
    }
  }

  Future<void> fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      final data = await _userService.fetchUserData();
      setState(() => _userData = data!);
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> logoutUser() async {
    setState(() => _isLoading = true);

    try {
      await _authService.logoutUser();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print("Erreur: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color(0xFF235F4E),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, right: 30),
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
                  ),
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
                  Text(
                    "${_userData['first_name'] ?? 'Chargement...'} ${_userData['last_name'] ?? ''}",
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
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Une route propre ne dépend pas seulement de l'efficacité du service de nettoyage, mais de l'éducation des personnes qui passent par là.",
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
      ),
    );
  }
}
