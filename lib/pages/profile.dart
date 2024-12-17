import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // En-tête avec fond vert et bouton de déconnexion
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF235F4E), // Couleur verte
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Photo de profil avec crayon de modification
          Transform.translate(
            offset: const Offset(0, -50),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.grey.shade600,
                  ),
                ),
                // Icon Crayon avec bordure verte
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF235F4E), width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Color(0xFF235F4E),
                  ),
                ),
              ],
            ),
          ),

          // Nom et coordonnées
          const Text(
            "John Doe",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4), // Réduction de l'espace ici
          const Text(
            "+237 679078289",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "john.doe@gmail.com",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF235F4E),
              fontWeight: FontWeight.w500,
            ),
          ),

          // Augmentation de l'espace avant le texte du bas
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
