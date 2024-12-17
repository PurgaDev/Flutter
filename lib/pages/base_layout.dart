import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:purga/model/user.dart';
import 'package:purga/pages/reporting_page.dart';
import 'package:purga/pages/waste_management.dart';
import 'package:purga/pages/profile.dart';
import 'package:http/http.dart' as http;
import 'package:purga/model/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    const MapScreen(),
    const ReportingPage(),
    const ProfilePage(),
  ];

  User? user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final String apiUrl = '$server/api/user/';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final String? authToken = prefs.getString("user_auth_token");
      if (authToken == null || authToken.isEmpty) {
        throw Exception("Vous devez vous authentifier");
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(data);
        });
      } else {
        print("Erreur: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // Image de profil avec bordures noires
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                    "assets/user_default.png"), // Remplacez par votre image de profil
                radius: 24,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.firstName ?? "Chargement...",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.phoneNumber ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // Ajouter une action ici
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(
                    Icons.home,
                    size: 30,
                    color: _selectedIndex == 0
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 0) const SizedBox(height: 6),
                  if (_selectedIndex == 0)
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF235F4E),
                    ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(
                    Icons.list,
                    size: 30,
                    color: _selectedIndex == 1
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 1) const SizedBox(height: 6),
                  if (_selectedIndex == 1)
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF235F4E),
                    ),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 30,
                    color: _selectedIndex == 2
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 2) const SizedBox(height: 6),
                  if (_selectedIndex == 2)
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF235F4E),
                    ),
                ],
              ),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: const IconThemeData(color: Color(0xFF235F4E)),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
        ),
      ),
    );
  }
}
