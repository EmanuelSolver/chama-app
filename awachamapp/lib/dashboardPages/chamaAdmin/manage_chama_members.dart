import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'add_chama_member.dart'; // Import the AddChamaMemberPage
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication

class ManageChamaMembersPage extends StatefulWidget {
  const ManageChamaMembersPage({super.key});

  @override
  _ManageChamaMembersPageState createState() => _ManageChamaMembersPageState();
}

class _ManageChamaMembersPageState extends State<ManageChamaMembersPage> {
  List<Member> members = [];
  String? chamaId; // Store chamaId from local storage
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadChamaMembers();
  }

  // Fetch chamaId from localStorage and then fetch members from Firestore
  Future<void> _loadChamaMembers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chamaId = prefs.getString('chamaId'); // Fetch chamaId from localStorage

    if (chamaId != null) {
      // Query chamaMembership for members of this Chama
      FirebaseFirestore.instance
          .collection('chamamembership')
          .where('chama_id', isEqualTo: chamaId)
          .get()
          .then((membershipSnapshot) async {
        List<Member> fetchedMembers = [];

        // Iterate over the members and fetch their details
        for (var membershipDoc in membershipSnapshot.docs) {
          String memberId = membershipDoc.id; // The user ID is used as the document ID
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(memberId)
              .get();

          // Create a Member object and add it to the list
          fetchedMembers.add(Member(
            id: memberId,
            name: "${userDoc['first_name']} ${userDoc['second_name']}",
            savings: 0.0,
            debt: 0.0,
          ));
        }

        setState(() {
          members = fetchedMembers;
          isLoading = false;
        });
      }).catchError((error) {
        print('Error fetching members: $error');
        setState(() {
          isLoading = false;
        });
      });
    } else {
      print('No chamaId found in localStorage');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Redirect to AddChamaMemberPage
  void _addMember() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddChamaMemberPage()),
    );
  }

  // Edit member details by navigating to a form or updating Firestore
  void _editMember(int index) {
    final member = members[index];
    // Navigate to the Edit page or show a form with member details
    // For now, we'll just log the member details
    print('Editing member: ${member.name}');
    // You can implement the navigation to an edit page if needed
  }

  // Warn before deleting a member
  void _confirmDeleteMember(int index) {
    final member = members[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${member.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteMember(index); // Proceed to delete the member
              },
            ),
          ],
        );
      },
    );
  }

  // Delete member from Firestore chamaMembership collection, users, and authentication
  void _deleteMember(int index) async {
    final member = members[index];

    setState(() {
      members.removeAt(index); // Remove from local list
    });

    try {
      // 1. Remove member from Firestore chamaMembership collection
      await FirebaseFirestore.instance
          .collection('chamamembership')
          .doc(member.id) // Using the member's uid as the document id
          .delete();

      // 2. Remove member from Firestore users collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(member.id)
          .delete();

      // 3. Remove member from Firebase Authentication
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null && firebaseUser.uid == member.id) {
        await firebaseUser.delete(); // Deletes the current authenticated user
        print('Member deleted from Firebase Authentication.');
      }

      print('Member deleted successfully from chamaMembership, users, and authentication.');
    } catch (e) {
      print('Error deleting member: $e');
      // Optionally, show an error dialog or toast message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Chama Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMember, // Redirect to AddChamaMemberPage
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(member.name),
                      subtitle: Text('Savings: Ksh ${member.savings}, Debt: Ksh ${member.debt}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editMember(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDeleteMember(index), // Show confirmation dialog
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class Member {
  final String id; // Store member id (uid from Firestore)
  final String name;
  final double savings;
  final double debt;

  Member({
    required this.id, // member's uid from Firestore
    required this.name,
    required this.savings,
    required this.debt,
  });
}
