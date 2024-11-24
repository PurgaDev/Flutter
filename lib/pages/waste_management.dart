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

  // Liste des points à afficher (dépôts simulés)
  final List<LatLng> _depots = [
    const LatLng(3.9480, 11.521),
    const LatLng(3.8995, 11.5045),
    const LatLng(3.8870, 11.4998),
    const LatLng(3.8702, 11.5012),
    const LatLng(3.8490, 11.5030),
  ];

  // Marqueurs à afficher sur la carte
  final Set<Marker> _markers = {};

  // Icône personnalisée
  late BitmapDescriptor _binIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
  }

  // Charger l'icône personnalisée
  void _loadCustomIcon() async {
    // ignore: deprecated_member_use
    _binIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(56, 56)),
      'assets/icons8-trash-48.png',
    );
    _loadMarkers(); // Charger les marqueurs une fois l'icône chargée
    setState(() {});
  }

  // Ajouter des marqueurs
  void _loadMarkers() {
    for (int i = 0; i < _depots.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('depot_$i'),
          position: _depots[i],
          icon: _binIcon, // Utilisez l'icône personnalisée
          infoWindow: InfoWindow(
            title: 'Dépôt ${i + 1}', // Numérotation des dépôts
            snippet:
                'Latitude: ${_depots[i].latitude}, Longitude: ${_depots[i].longitude}',
          ),
        ),
      );
    }
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
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
                markers: _markers,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
