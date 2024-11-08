import 'dart:convert';
import 'package:purga/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class LoginViewModel {
  final AuthProvider authProvider;
  final _baseUrl = "http://192.168.1.134:8000";

  LoginViewModel(this.authProvider);

  login() async {
    String url = "$_baseUrl/api/login/";
    final headers = {
      "Content-Type": "application/json",
    };
    final data = json.encode({
      "phoneNumber": "+237${authProvider.user.phoneNumber}",
    });
    try {
      final response =
          await http.post(Uri.parse(url), body: data, headers: headers);
      if (response.statusCode == 200) {
        authProvider.navigateToVerificationPage();
        // start decrementer counter
      } else {
        throw Exception(
          "Erreur ${response.statusCode}: ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      throw Exception("Erreur http: $e");
    }
  }

  onTextFieldChange(String value) {
    authProvider.user.phoneNumber = value;
  }

  onLoginTapped() {
    login();
  }

  verificationOtpCode() async {
    String url = "$_baseUrl/login/verification/";
    final headers = {"Content-Type": "application/json"};

    final data = json.encode({
      "phoneNumber": authProvider.user.phoneNumber,
      "otpCode": authProvider.user.optCode
    });

    try {
      final response =
          await http.post(Uri.parse(url), body: data, headers: headers);
      if (response.statusCode == 200) {
        print(response.body.toString());
        //TODO:: save token to file...
      } else {
        throw Exception(
          "Erreur ${response.statusCode}: ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      throw Exception("Erreur: $e");
    }
  }

  onPingCodeChanged(String value) {
    authProvider.user.optCode = value;
  }
}
