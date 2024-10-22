import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Personal Info Variables
  String username = '';
  String email = '';
  String mobileNo = '';
  String firstName = '';
  String lastName = '';
  String nationalId = '';
  String userRole = '';
  String registrationNo = '';

  // Chama Info Variables
  String chamaName = '';
  String chamaLocation = '';
  String chamaday = '';
  String meetSchedule = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from SharedPreferences
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Unknown User';
      email = prefs.getString('email') ?? 'Unknown Email';
      mobileNo = prefs.getString('mobileNo') ?? 'Unknown Mobile No';
      firstName = prefs.getString('firstName') ?? 'Unknown First Name';
      lastName = prefs.getString('lastName') ?? 'Unknown Last Name';
      nationalId = prefs.getString('nationalId') ?? 'Unknown Id';
      userRole = prefs.getString('userRole') ?? 'Member';

      // Chama Info
      chamaName = prefs.getString('chamaName') ?? 'No Chama';
      chamaLocation = prefs.getString('chamaLocation') ?? 'Unknown Location';
      chamaday = prefs.getString('chamaday') ?? 'No Day Selected';
      meetSchedule = prefs.getString('meetSchedule') ?? 'No Schedule';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$firstName $lastName', // Display full name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userRole,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 30, thickness: 1),

              // Personal Information Section
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildInfoTile('Name', username),
              _buildInfoTile('Email', email),
              _buildInfoTile('Mobile No', mobileNo),
              _buildInfoTile('National ID', nationalId), // Convert to String
              const SizedBox(height: 20),
              const Divider(height: 30, thickness: 1),

              // Chama Information Section
              const Text(
                'Chama Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildInfoTile('Chama Name', chamaName),
              _buildInfoTile('Chama Location', chamaLocation),
              _buildInfoTile('Chama Day', chamaday),
              _buildInfoTile('Meet Schedule', meetSchedule),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Use Expanded to prevent overflow
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded( // Use Expanded to prevent overflow
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end, 
            ),
          ),
        ],
      ),
    );
  }
}
