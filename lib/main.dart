import 'package:flutter/material.dart';
import 'package:purga/pages/base_layout.dart';
import 'package:purga/pages/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // verification du token
  final prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString("user_auth_token");

  runApp(
    MyApp(isAuthenticated: authToken != null && authToken.isNotEmpty),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, required this.isAuthenticated});

  // This widget is the root of your application.`````
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Purga',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF235F4E)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: isAuthenticated? const BaseLayout(): const StartScreen());
  }
}
