import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(Widget widget) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
