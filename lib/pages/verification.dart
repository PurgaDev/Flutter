import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:purga/pages/base_layout.dart';
import 'package:purga/services/authentification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _counter = 60;
  Timer? _timer;
  final _authService = AuthentificationService();
  String _optCode = "";
  bool _isLoading = false;
  String _phoneNumber = "";

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
    _startTimer();
  }

  Future<void> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString("user_phone_number");
    if (phoneNumber != null) {
      setState(() {
        _phoneNumber = phoneNumber;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _resendOptCode() async {
    if (_counter != 0) return;
    try {
      await _authService.sendPhoneNumber(_phoneNumber);
      setState(() {
        _counter = 60;
      });
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Code renvoyé"),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        showCloseIcon: true,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 5),
        backgroundColor: Theme.of(context).colorScheme.error,
        showCloseIcon: true,
      ));
    }
  }

  Future<void> _verifyOptCode(String phoneNumber) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.verifyOtpCode(phoneNumber, _optCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_auth_token", token['access']!);
      await prefs.setString("auth_refresh_token", token['refresh']!);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BaseLayout()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 5),
        showCloseIcon: true,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your Verification Code",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                onChanged: (String value) {
                  setState(() {
                    _optCode = value;
                  });
                },
                length: 4,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldWidth: 60,
                  fieldHeight: 60,
                  inactiveColor: Colors.black,
                  activeColor: const Color(0xFF235F4E),
                  selectedColor: Colors.green,
                ),
                keyboardType: TextInputType.number,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildVerificationBox(_codeController1),
              //     _buildVerificationBox(_codeController2),
              //     _buildVerificationBox(_codeController3),
              //     _buildVerificationBox(_codeController4),
              //   ],
              // ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Nous avons envoyé un code de vérification par ",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter_18pt',
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Couleur par défaut
                  ),
                  children: [
                    const TextSpan(
                      text: "SMS",
                      style: TextStyle(
                        color: Color(0xFF235F4E), // Mot "SMS" en vert
                      ),
                    ),
                    TextSpan(
                      text: " au numéro de téléphone +237 $_phoneNumber",
                      style: const TextStyle(
                        color: Colors.black, // Retour à la couleur par défaut
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Vous n'avez pas reçu ?",
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 46, 31, 31),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: _resendOptCode,
                child: Text(
                  "Ressayer dans 00:$_counter",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF235F4E),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _verifyOptCode(_phoneNumber),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF235F4E),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                        ),
                        child: const Text(
                          "Vérifier",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationBox(TextEditingController controller) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          // Setting border color to green
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF235F4E), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF235F4E), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
