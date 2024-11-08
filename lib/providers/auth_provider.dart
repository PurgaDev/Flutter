import 'package:flutter/material.dart';
import 'package:purga/model/user.dart';
import 'package:purga/pages/verification.dart';
import 'package:purga/services/navigation_service.dart';

class AuthProvider with ChangeNotifier {
  final User user;
  final NavigationService navigationService;
  AuthProvider(this.user, this.navigationService);

  navigateToVerificationPage() {
    navigationService.navigateTo(const VerificationScreen());
  }
}
