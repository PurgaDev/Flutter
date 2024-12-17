import 'package:flutter/material.dart';
import 'package:purga/pages/verification.dart';
import 'package:purga/services/authentification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purga/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthentificationService();
  SharedPreferences? prefs;
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  bool _isLoading = false;

  @override
  void initState() {
    initPreference();
    super.initState();
  }

  void initPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs = _prefs;
    });
  }

  void _register() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_phoneNumber.trim() == "" ||
          _firstName.trim() == "" ||
          _lastName.trim() == "") {
        throw Exception("Tous les champs sont obligatoire");
      } else {
        if (prefs != null) {
          await _authService.register(_firstName, _lastName, _phoneNumber);
          await _authService.sendPhoneNumber(_phoneNumber);
          await prefs!.setString("user_phone_number", _phoneNumber);
        } else {
          throw Exception("Veuillez reeassayer.");
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerificationScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
        showCloseIcon: true,
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                height: 200,
                child: Image.asset('assets/login.jpeg'),
              ),
              const SizedBox(height: 50),
              // "Register"
              const Text(
                "Creer votre compte",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              // "Nom"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prenom",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'Inter_18pt',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // nom
              TextField(
                onChanged: (String value) => setState(() => _firstName = value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Votre prenom',
                ),
              ),
              const SizedBox(height: 10),

              // "Nom"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nom",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'Inter_18pt',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // nom
              TextField(
                onChanged: (String value) => setState(() => _lastName = value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Votre nom',
                ),
              ),
              const SizedBox(height: 10),

              //"Numéro de téléphone"
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
              const SizedBox(height: 5),
              // numéro de téléphone
              Row(
                children: [
                  // Bouton +237
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  // numéro
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (String value) =>
                            setState(() => _phoneNumber = value),
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
              const SizedBox(height: 15),
              //"S'inscrire"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: const Color(0xFF235F4E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 20,
                            ),
                      const SizedBox(width: 10),
                      const Text(
                        "S'inscrire",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter_18pt',
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Texte pour créer un compte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Déjà enregistré?",
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
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Se cnnecter...",
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
