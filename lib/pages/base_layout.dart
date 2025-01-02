import 'package:flutter/material.dart';
import 'package:purga/model/user.dart';
import 'package:purga/pages/deposit.dart';
import 'package:purga/pages/reporting_page.dart';
import 'package:purga/pages/profile.dart';
import 'package:purga/pages/waste_management.dart';
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
  late List<Widget> _pages = [];
  late List<BottomNavigationBarItem> _bottomNavItems;
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
        _initializeLayout(); // Initialiser le layout après avoir récupéré l'utilisateur
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
        _initializeLayout(); // Initialiser le layout après avoir récupéré l'utilisateur
      });
    }
  }

  /// Initialise les pages et les onglets en fonction du rôle de l'utilisateur
  void _initializeLayout() {
    if (user?.role == 'driver') {
      // Configuration pour les chauffeurs
      _pages = [
        const MapScreen(),
        const DepositView(),
        const ReportingPage(),
        const ProfilePage(),
      ];

      _bottomNavItems = const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping, size: 30), // Icône pour les dépôts
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, size: 30), // Icône pour les rapports
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: 30),
          label: '',
        ),
      ];
    } else {
      // Configuration pour les citoyens ou autres rôles
      _pages = [
        const MapScreen(),
        const ReportingPage(), // Page de rapport pour les citoyens
        const ProfilePage(),
      ];

      _bottomNavItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, size: 30), // Icône pour les rapports
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: 30),
          label: '',
        ),
      ];
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
      appBar: _selectedIndex == (_pages.length - 1)
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
        items:
            _bottomNavItems, // Utiliser la liste des items en fonction du rôle
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
