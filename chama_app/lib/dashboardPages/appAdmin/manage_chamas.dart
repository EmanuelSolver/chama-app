import 'package:flutter/material.dart';

class ManageChamasPage extends StatelessWidget {
  const ManageChamasPage({super.key});

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
                // Add logic to create a new chama
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
              'List of Chamas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Chama List (Sample data)
            Expanded(
              child: ListView.builder(
                itemCount: chamas.length, // Fetch this from the backend or state
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        chamas[index]['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Members: ${chamas[index]['members']}'),
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

// Sample list of chamas for display purposes
final List<Map<String, dynamic>> chamas = [
  {'name': 'Chama A', 'members': 12},
  {'name': 'Chama B', 'members': 18},
  {'name': 'Chama C', 'members': 10},
  {'name': 'Chama D', 'members': 22},
];
