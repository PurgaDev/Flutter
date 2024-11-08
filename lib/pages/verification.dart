import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:purga/providers/auth_provider.dart';
import 'package:purga/services/navigation_service.dart';
import 'package:purga/viewmodel/login_view_model.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _counter = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewModel loginViewModel =
        LoginViewModel(Provider.of<AuthProvider>(context));

    final navigationService = Provider.of<NavigationService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            navigationService.goBack();
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
                onChanged: loginViewModel.onPingCodeChanged,
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
                text: const TextSpan(
                  text: "Nous avons envoyé un code de vérification par ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter_18pt',
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Couleur par défaut
                  ),
                  children: [
                    TextSpan(
                      text: "SMS",
                      style: TextStyle(
                        color: Color(0xFF235F4E), // Mot "SMS" en vert
                      ),
                    ),
                    TextSpan(
                      text: " au numéro de téléphone +237 6*******99",
                      style: TextStyle(
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
                onPressed: _counter <= 0? loginViewModel.login() : null,
                child: const Text(
                  "Ressayer dans 00:30",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF235F4E),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: loginViewModel.verificationOtpCode,
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
