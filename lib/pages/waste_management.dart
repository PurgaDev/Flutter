import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:purga/constantes.dart';
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
  LatLng? _location;

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
        setState(() {
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
        });
      }
    } catch (e) {
      throw Exception('Impossible de charger les dépôts.');
    }
  }

  // Charger les itinéraires pour les chauffeurs
  Future<void> _loadRoutes() async {
    try {
      final routes = await fetchRoutes();
      // print(routes);
      // for (var route in routes) {
      //   setState(() {
      //     _polylines.add(Polyline(
      //       polylineId: const PolylineId('route'),
      //       points: route,
      //       color: Colors.blue,
      //       width: 5,
      //     ));
      //   });
      // }
      List<Map<String, dynamic>> polyCoordinates =
          await _getPolyLines(routes[0]);
      for (var step in polyCoordinates) {
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: step['coordinates'],
              color: Colors.blue,
              width: 3,
            ),
          );

          _markers.add(
            Marker(
              markerId: const MarkerId('deposit'),
              position: step['start'],
              icon: _binIcon,
            ),
          );

          _markers.add(
            Marker(
              markerId: const MarkerId('deposit'),
              position: step['end'],
              icon: _binIcon,
            ),
          );
        });
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Impossible de charger les itinéraires.');
    }
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Le service de localisation n'est pas activé.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permission de localisation refusée.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Permission de localisation refusée définitivement.");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await _checkPermission();
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _location = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _location!, zoom: 14),
          ),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('_currentPosition'),
            position: _location!,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().substring(8)),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getPolyLines(
      List<LatLng> itineraire) async {
    List<Map<String, dynamic>> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    for (int i = 0; i < itineraire.length - 1; i++) {
      Map<String, dynamic> step = {
        "start": LatLng(itineraire[i].latitude, itineraire[i].longitude),
        "end": LatLng(itineraire[i + 1].latitude, itineraire[i + 1].longitude)
      };
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAP_API_KEY,
        request: PolylineRequest(
          origin: PointLatLng(step['start'].latitude, step['start'].longitude),
          destination: PointLatLng(step['end'].latitude, step['end'].longitude),
          mode: TravelMode.driving,
        ),
      );
      if (result.points.isNotEmpty) {
        step['coordinates'] = result.points
            .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
            .toList();
      } else {
        print(result.errorMessage);
        Future.error(result.errorMessage!);
      }
      polylineCoordinates.add(step);
    }

    return polylineCoordinates;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        // _buildSearchBar(),
        // const SizedBox(height: 16),
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
          trafficEnabled: true,
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
