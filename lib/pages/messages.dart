import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Map<String, dynamic>> _messages = [
    {
      "title": "Chaque geste compte",
      "content":
          "Recycler aujourd'hui permet de réduire les déchets dans les décharges et de préserver nos ressources naturelles. Agissez maintenant pour un avenir plus propre.",
      "icon": Icons.recycling,
    },
    {
      "title": "Réduisez les déchets",
      "content":
          "En remplaçant les sacs plastiques par des sacs réutilisables, vous contribuez à limiter la pollution plastique qui menace les océans.",
      "icon": Icons.delete_sweep,
    },
    {
      "title": "Plantez un arbre",
      "content":
          "Les arbres jouent un rôle essentiel dans la lutte contre le changement climatique en absorbant le dioxyde de carbone (CO2) et en produisant de l'oxygène.",
      "icon": Icons.nature,
    },
    {
      "title": "Compostez vos déchets",
      "content":
          "Transformez vos restes alimentaires et déchets verts en compost pour nourrir la terre naturellement. Cela réduit la quantité de déchets envoyés aux décharges.",
      "icon": Icons.eco,
    },
    {
      "title": "Recyclage du papier",
      "content":
          "Recycler une tonne de papier permet de sauver 17 arbres, 26 000 litres d'eau et de réduire les émissions de CO2.",
      "icon": Icons.menu_book,
    },
    {
      "title": "Donnez vos vêtements",
      "content":
          "Plutôt que de jeter des vêtements usagés, donnez-les à des associations. Vous offrez ainsi une seconde vie à vos affaires tout en aidant ceux dans le besoin.",
      "icon": Icons.volunteer_activism,
    },
    {
      "title": "Marchez ou pédalez",
      "content":
          "Privilégiez la marche ou le vélo pour vos courts trajets. Cela diminue votre empreinte carbone et améliore votre santé.",
      "icon": Icons.directions_bike,
    },
    {
      "title": "Économisez l'eau",
      "content":
          "Ne laissez pas l'eau couler inutilement. En fermant le robinet, vous pouvez économiser plusieurs litres d'eau potable chaque jour.",
      "icon": Icons.water_drop,
    },
    {
      "title": "Réutilisez vos objets",
      "content":
          "Donnez une seconde vie à vos vieux objets. Transformez des bocaux en pots de fleurs ou des palettes en meubles.",
      "icon": Icons.handyman,
    },
    {
      "title": "Recyclez vos appareils électroniques",
      "content":
          "Les déchets électroniques contiennent des métaux précieux. Déposez-les dans des points de collecte spécialisés pour un recyclage adapté.",
      "icon": Icons.phonelink_erase,
    },
    {
      "title": "Optez pour des produits locaux",
      "content":
          "En achetant des produits locaux, vous réduisez l'empreinte carbone liée au transport et soutenez l'économie locale.",
      "icon": Icons.local_florist,
    },
    {
      "title": "Choisissez le verre",
      "content":
          "Contrairement au plastique, le verre est recyclable à l'infini sans perte de qualité. Favorisez les contenants en verre.",
      "icon": Icons.local_drink,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages Éco-Responsables",
          style: TextStyle(
            color: Color(0xFF235F4E), // Couleur verte pour le thème
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 80, 156, 73),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF235F4E)),
      ),
      backgroundColor: const Color.fromARGB(255, 201, 216, 200),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF235F4E).withOpacity(0.2),
                child: Icon(
                  _messages[index]['icon'],
                  color: const Color(0xFF235F4E),
                  size: 30,
                ),
              ),
              title: Text(
                _messages[index]['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF235F4E),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _messages[index]['content'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
