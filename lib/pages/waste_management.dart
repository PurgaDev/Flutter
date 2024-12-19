
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purga/services/deposit_service.dart'; // Importation du service
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(3.8480, 11.5021);

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late BitmapDescriptor _binIcon;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
    _loadDataBasedOnRole();
  }

  // Charger l'icône personnalisée
  void _loadCustomIcon() async {
    _binIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(56, 56)),
      'assets/icons8-trash-48.png',
    );
    setState(() {});
  }

  // Charger les données en fonction du rôle de l'utilisateur
  void _loadDataBasedOnRole() async {
    try {
      final role = await getUserRole();

      if (role == 'citizen') {
        await _loadDeposits();
      } else if (role == 'driver') {
        await _loadRoutes();
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Charger les dépôts pour les citoyens
  Future<void> _loadDeposits() async {
    try {
      final deposits = await fetchDeposits();
      for (var deposit in deposits) {
        _markers.add(
          Marker(
            markerId: MarkerId('${deposit.latitude}_${deposit.longitude}'),
            position: LatLng(deposit.latitude, deposit.longitude),
            icon: _binIcon,
            infoWindow: InfoWindow(
              title: deposit.description,
              snippet: 'Nettoyé : ${deposit.cleaned ? "Oui" : "Non"}',
            ),
          ),
        );
      }
    } catch (e) {
      throw Exception('Impossible de charger les dépôts.');
    }
  }

  // Charger les itinéraires pour les chauffeurs
  Future<void> _loadRoutes() async {
    try {
      final routes = await fetchRoutes();
      for (var route in routes) {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: route,
          color: Colors.blue,
          width: 5,
        ));
      }
    } catch (e) {
      throw Exception('Impossible de charger les itinéraires.');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        _buildSearchBar(),
        const SizedBox(height: 16),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildGoogleMap(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
                  hintText: "Rechercher un dépôt.....",
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
    );
  }

  Widget _buildGoogleMap() {
    return Padding(
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
          polylines: _polylines,
        ),
      ),
    );
  }
}
