import 'package:flutter/material.dart';
import 'package:purga/services/deposit_service.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DepositViewState createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  late Future<List<Deposit>> _depositsFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _depositsFuture = _loadDeposits();
  }

  // Charger les dépôts liés au chauffeur
  Future<List<Deposit>> _loadDeposits() async {
    final role = await getUserRole();
    if (role != 'driver') {
      throw Exception("Seuls les chauffeurs ont accès à cette vue.");
    }
    return await fetchDeposits();
  }

  // Marquer un dépôt comme nettoyé
  Future<void> _markAsCleaned(int depositId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = await getUserId();
      if (userId == null) {
        throw Exception("Utilisateur non authentifié.");
      }

      // Appel API pour marquer comme nettoyé
      final response = await markDepositAsCleaned(driverId: userId, depositId: depositId);

      if (response['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dépôt marqué comme nettoyé.'),
        ));

        // Recharger les dépôts après la mise à jour
        setState(() {
          _depositsFuture = _loadDeposits();
        });
      } else {
        throw Exception("Erreur lors du marquage comme nettoyé.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépôts Assignés'),
      ),
      body: FutureBuilder<List<Deposit>>(
        future: _depositsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun dépôt assigné.'));
          }

          final deposits = snapshot.data!;
          return ListView.builder(
            itemCount: deposits.length,
            itemBuilder: (context, index) {
              final deposit = deposits[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(deposit.description),
                  subtitle: Text(
                      'Lat: ${deposit.latitude}, Lng: ${deposit.longitude}, Nettoyé: ${deposit.cleaned ? "Oui" : "Non"}'),
                  trailing: deposit.cleaned
                      ? const Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _markAsCleaned(deposit.id);
                                },
                          child: const Text('Marquer comme nettoyé'),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
