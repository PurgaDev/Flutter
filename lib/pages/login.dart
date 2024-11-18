import 'package:flutter/material.dart';
import 'package:purga/pages/register.dart';
import 'package:purga/pages/verification.dart';
import 'package:purga/services/authentification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _phoneNumber = "";
  bool _isLoading = false;
  final _authService = AuthentificationService();

  Future<void> _sendPhoneNumber() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendPhoneNumber(_phoneNumber);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_phone_number", _phoneNumber);
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const VerificationScreen()),
      );
    } catch (e) {
      print(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image en haut
              SizedBox(
                height: 300,
                child: Image.asset('assets/login.jpeg'),
              ),
              const SizedBox(height: 30),
              // Titre "Login"
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Texte "Numéro de téléphone"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Numéro de téléphone",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'Inter_18pt',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Champ de saisie pour le numéro de téléphone
              Row(
                children: [
                  // Bouton +237
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: const Text(
                      "+237",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter_18pt',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Champ de saisie du numéro
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: TextField(
                        onChanged: (String value) {
                          setState(() {
                            _phoneNumber = value;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '6 99 99 99 99',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Bouton "Se connecter"
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _sendPhoneNumber,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor:
                              const Color(0xFF235F4E), // Couleur du bouton
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter_18pt',
                              color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              // Texte pour créer un compte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Pas de compte?",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontFamily: 'Inter_18pt',
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "S'inscrire...",
                      style: TextStyle(
                          color: Color(0xFF235F4E),
                          fontSize: 16,
                          fontFamily: 'Inter_18pt',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
