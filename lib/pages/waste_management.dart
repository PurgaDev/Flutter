import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Position initiale de la carte Google
  final LatLng _center = const LatLng(3.8480, 11.5021);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  int _selectedIndex = 0; // Index de la barre de navigation inférieure

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
                    "assets/default-user.jpeg"), // Remplacez par votre image de profil
                radius: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "+237 679078289",
                  style: TextStyle(
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
      body: Column(
        children: [
          // Espacement ajusté
          const SizedBox(height: 25),

          // Barre de recherche avec largeur réduite
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 247, 243, 243),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF235F4E), width: 1.5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher un dépot.....",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF235F4E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bouton flottant
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85), // Déplacé vers le haut
        child: FloatingActionButton(
          onPressed: () {
            // Ajouter une action pour le bouton
          },
          backgroundColor: const Color(0xFF235F4E),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      // Barre de navigation inférieure
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
                    color: _selectedIndex == 0
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 0)
                    const SizedBox(
                        height: 6), // Espacement entre l'icône et le point vert
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
                    color: _selectedIndex == 1
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 1)
                    const SizedBox(
                        height: 6), // Espacement entre l'icône et le point vert
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
                    color: _selectedIndex == 2
                        ? const Color(0xFF235F4E)
                        : Colors.black,
                  ),
                  if (_selectedIndex == 2)
                    const SizedBox(
                        height: 6), // Espacement entre l'icône et le point vert
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme: const IconThemeData(color: Color(0xFF235F4E)),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
        ),
      ),
    );
  }
}
