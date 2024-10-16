import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'register_chama.dart'; // Import the register chama page

class ManageChamasPage extends StatefulWidget {
  const ManageChamasPage({super.key});

  @override
  _ManageChamasPageState createState() => _ManageChamasPageState();
}

class _ManageChamasPageState extends State<ManageChamasPage> {
  List<dynamic> chamas = []; // To store fetched chama data
  bool isLoading = true; // To show loading spinner

  @override
  void initState() {
    super.initState();
    fetchChamas(); // Fetch Chamas from the backend when the page loads
  }

  // Function to fetch Chamas from the backend
  Future<void> fetchChamas() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/chamas/')); // Replace with your API endpoint

      if (response.statusCode == 200) {
        setState(() {
          chamas = jsonDecode(response.body); // Parse JSON and update chama list
          isLoading = false; // Set loading to false when data is loaded
        });
      } else {
        throw Exception('Failed to load chamas');
      }
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
                            Text('Members: ${chama['members_count']}'),
                            Text('Admin: ${chama['admin'] ?? 'No Admin'}'),
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


