import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purga/services/reporting_service.dart';
import 'package:readmore/readmore.dart';
import 'package:purga/pages/waste_management.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  State<ReportingPage> createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final ReportingService reportingService = ReportingService();
  LatLng? _location;
  String _description = "";
  bool isReportCreating = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  Future<void> _onTapedReporting() async {
    if (_location != null && _image != null && _description.isNotEmpty) {
      setState(() {
        isReportCreating = true;
      });
      try {
        String message = await reportingService.createReporting(
            _description, _image!, _location!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const  Duration(seconds: 5),
            showCloseIcon: true,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
            showCloseIcon: true,
          ),
        );
      } finally {
        isReportCreating = false;
        Navigator.of(context).pop();
      }
    }
  }

  Widget createForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Signaler un depot",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // image show
          _image == null
              ? const SizedBox(height: 0)
              : Image.file(_image!, height: 100),

          const SizedBox(height: 10),
          // prendre une photo
          GestureDetector(
            onTap: _takePhoto,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Prendre une photo",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // description
          TextField(
            onChanged: (String value) => setState(() => _description = value),
            minLines: 4,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Ajouter une description',
            ),
          ),
          const SizedBox(height: 15),

          // actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.cancel),
                label: const Text(
                  "Annuler",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onTapedReporting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: isReportCreating
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Icon(Icons.report),
                label: const Text(
                  "Signaler",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mes signalement",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: createForm,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Signaler"),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            "images/im2.jpg",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Validé"),
                            ),
                            const Text(
                              "__/ __/ __",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        ReadMoreText(
                          "Flutter est un framework développé par Google. Il permet de créer des applications multiplateformes, "
                          "avec une seule base de code, en utilisant le langage Dart. Flutter offre une grande flexibilité "
                          "et des performances proches des applications natives. Ce texte illustre comment gérer du texte "
                          "avec une option Lire plus dans Flutter.",
                          trimLines: 3,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          trimCollapsedText: 'Lire plus',
                          trimExpandedText: 'Lire moins',
                          trimMode: TrimMode.Line,
                          colorClickableText:
                              Theme.of(context).colorScheme.primary,
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: 5,
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}
