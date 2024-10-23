import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? secondName;
  String? nationalId;
  String? mobileNo;
  String? password;
  String? userId; // Store the user ID
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId'); // Fetch userId from localStorage

    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        firstName = userDoc['first_name'];
        secondName = userDoc['second_name'];
        nationalId = userDoc['national_id'];
        mobileNo = userDoc['mobile_no'];
        isLoading = false;
      });
    }
  }

  // Update user profile in Firestore and Authentication
  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Save the form state

      try {
        // Update Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'first_name': firstName,
          'second_name': secondName,
          'national_id': nationalId,
          'mobile_no': mobileNo,
        });

        // Update password if provided
        if (password != null && password!.isNotEmpty) {
          User? firebaseUser = FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            await firebaseUser.updatePassword(password!);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: firstName,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      onSaved: (value) => firstName = value,
                      validator: (value) => value!.isEmpty ? 'Enter your first name' : null,
                    ),
                    TextFormField(
                      initialValue: secondName,
                      decoration: const InputDecoration(labelText: 'Second Name'),
                      onSaved: (value) => secondName = value,
                      validator: (value) => value!.isEmpty ? 'Enter your second name' : null,
                    ),
                    TextFormField(
                      initialValue: nationalId,
                      decoration: const InputDecoration(labelText: 'National ID'),
                      onSaved: (value) => nationalId = value,
                      validator: (value) => value!.isEmpty ? 'Enter your National ID' : null,
                    ),
                    TextFormField(
                      initialValue: mobileNo,
                      decoration: const InputDecoration(labelText: 'Mobile Number'),
                      onSaved: (value) => mobileNo = value,
                      validator: (value) => value!.isEmpty ? 'Enter your mobile number' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password (leave empty to keep current password)'),
                      obscureText: true,
                      onSaved: (value) => password = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
