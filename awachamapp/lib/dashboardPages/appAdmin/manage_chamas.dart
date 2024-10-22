import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'register_chama.dart'; // Import the register chama page

class ManageChamasPage extends StatefulWidget {
  const ManageChamasPage({super.key});

  @override
  _ManageChamasPageState createState() => _ManageChamasPageState();
}

class _ManageChamasPageState extends State<ManageChamasPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> chamas = []; // Store fetched chama data
  bool isLoading = true; // Show loading spinner

  @override
  void initState() {
    super.initState();
    fetchChamas(); // Fetch Chamas from Firestore when the page loads
  }

  // Function to fetch Chamas from Firestore
  Future<void> fetchChamas() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('chama').get();

  setState(() {
    chamas = snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'chama_name': doc['name'] ?? 'Unnamed Chama', // Fallback if null
              'location': doc['location'] ?? 'Unknown location', // Fallback if null
              'meet_schedule': doc['meet_schedule'] ?? 'Not specified', // Fallback if null
              'day_or_date': doc['day_or_date'] ?? 'Not specified', // Fallback if null
              'registration_no': doc['registration_no'] ?? 'N/A', // Fallback if null
            })
        .toList();
    isLoading = false;
  });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Chamas'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add New Chama Button
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Register Chama Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterChamaPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Chama'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            const SizedBox(height: 20),

            // Chama List Title
            const Text(
              'Registered Chamas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display loading spinner while fetching data
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (chamas.isEmpty)
              const Center(child: Text('No Chamas found.'))
            else
              // Chama List
              Expanded(
                child: ListView.builder(
                  itemCount: chamas.length,
                  itemBuilder: (context, index) {
                    // Fetch chama details
                    var chama = chamas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          chama['chama_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: ${chama['location']}'),
                            Text('Meet Schedule: ${chama['meet_schedule']}'),
                            Text('Day/Date: ${chama['day_or_date']}'),
                            Text('Registration No: ${chama['registration_no']}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String result) {
                            if (result == 'view') {
                              // Handle view chama details
                            } else if (result == 'edit') {
                              // Handle edit chama details
                            } else if (result == 'delete') {
                              // Handle delete chama
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: Text('View'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
