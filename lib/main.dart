import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purga/model/user.dart';
import 'package:purga/pages/start_screen.dart';
import 'package:purga/providers/auth_provider.dart';
import 'package:purga/services/navigation_service.dart';

void main() async {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final User _user = User();

  MyApp({super.key});

  // This widget is the root of your application.`````
  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();
    return MultiProvider(
      providers: [
        Provider(create: (_) => navigationService),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(_user, navigationService)),
      ],
      child: MaterialApp(
        title: 'Purga',
        navigatorKey: navigationService.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const StartScreen(),
      ),
    );
  }
}
