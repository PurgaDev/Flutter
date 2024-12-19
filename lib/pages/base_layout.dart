import 'package:flutter/material.dart';
import 'package:purga/model/user.dart';
import 'package:purga/pages/reporting_page.dart';
import 'package:purga/pages/waste_management.dart';
import 'package:purga/pages/profile.dart';
import 'package:purga/services/user_service.dart';
import 'package:purga/pages/messages.dart';

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

  User? user; // Contiendra les informations utilisateur

  @override
  void initState() {
    super.initState();
    loadInitialData(); // Charger les données utilisateur
  }

  /// Initialise les données utilisateur
  Future<void> loadInitialData() async {
    final userService = UserService();
    final userData = await userService.loadUserData();
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    } else {
      await fetchUserData();
    }
  }

  /// Récupère les données utilisateur depuis l'API
  Future<void> fetchUserData() async {
    final userService = UserService();
    final userData = await userService.fetchUserData();
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    }
  }

  /// Change d'onglet dans le BottomNavigationBar
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
      appBar: _selectedIndex == 2
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/user_default.png"),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MessagePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
