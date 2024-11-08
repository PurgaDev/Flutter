import 'package:flutter/material.dart';
import 'package:purga/pages/login.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF235F4E), // Couleur de fond verte
      body: Column(
        children: [
          const Spacer(
              flex: 3), // Ajustement de l'espace au-dessus pour centrer

          // Le texte "Purga"
          const Center(
            child: Text(
              'Purga',
              style: TextStyle(
                fontSize: 100, // Ajustement de la taille de police
                fontFamily: 'KaushanScript', // Police cursive proche de l'image
                color: Colors.white,
              ),
            ),
          ),

          const Spacer(
              flex: 2), // Ajustement de l'espace en dessous pour centrer

          // Bouton "Get Start" en bas
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                 // Lorsque ce bouton est pressé, naviguer vers la page LoginPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Fond transparent
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Colors.white, width: 2), // Bordure blanche
                  borderRadius: BorderRadius.circular(30), // Bordure arrondie
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Commencer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Couleur du texte blanc
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white, // Couleur de l'icône blanc
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Texte en bas
          const Padding(
            padding:
                EdgeInsets.only(bottom: 40), // Réduction de l'espace en bas
            child: Text(
              'Le recyclage est une action citoyenne',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
