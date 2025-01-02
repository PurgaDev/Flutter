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

  Future<List<Deposit>> _loadDeposits() async {
    final role = await getUserRole();
    if (role != 'driver') {
      throw Exception("Seuls les chauffeurs peuvent accéder.");
    }
    return await fetchDeposits();
  }

  Future<void> _markAsCleaned(int depositId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = await getUserId();
      if (userId == null) {
        throw Exception("Utilisateur non authentifié.");
      }

      final response = await markDepositAsCleaned(driverId: userId, depositId: depositId);

      if (response['status'] == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Depot marqué comme nettoyé.')),
        );
        setState(() {
          _depositsFuture = _loadDeposits();
        });
      } else {
        throw Exception("Error lors du traitement.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
        title: const Text('Depots Assignés'),
      ),
      body: FutureBuilder<List<Deposit>>(
        future: _depositsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text('Aucun depot assigné', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final deposits = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: deposits.length,
            itemBuilder: (context, index) {
              final deposit = deposits[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.location_on, color: deposit.cleaned ? Colors.green : Colors.red),
                  title: Text(
                    deposit.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Lat: ${deposit.latitude}, Lng: ${deposit.longitude}\nCleaned: ${deposit.cleaned ? "Yes" : "No"}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: deposit.cleaned
                      ? const Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  _markAsCleaned(deposit.id);
                                },
                          child: const Text('Marquer comme Nettoyé'),
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
