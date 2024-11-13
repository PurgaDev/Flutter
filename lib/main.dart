import 'package:flutter/material.dart';
import 'package:purga/pages/start_screen.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.`````
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
    );
  }
}
