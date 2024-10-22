import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddChamaMemberPage extends StatefulWidget {
  const AddChamaMemberPage({super.key});

  @override
  _AddChamaMemberPageState createState() => _AddChamaMemberPageState();
}

class _AddChamaMemberPageState extends State<AddChamaMemberPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Retrieve chamaId from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chamaId = prefs.getString('chamaId');

    if (chamaId == null) {
      _showSnackbar('Chama ID not found. Please make sure you are logged in and belong to a Chama.');
      return;
    }

    // Create a new Firebase Auth user for the Chama member
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: 'Password123', 
      );
      
      final String uid = userCredential.user!.uid; // Get the newly created user's uid

      // Prepare member data
      final Map<String, dynamic> memberData = {
        'first_name': _firstNameController.text,
        'second_name': _lastNameController.text,
        'national_id': _idController.text,
        'mobile_no': _phoneController.text,
        'user_role': 'chamaMember',
      };

      // Save member data to Firestore in 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set(memberData);

      // Create a ChamaMembership document for the new member
      await FirebaseFirestore.instance.collection('chamamembership').doc(uid).set({
        'chama_id': chamaId,
        'joined_date': FieldValue.serverTimestamp(),
        'is_admin': false, 
        'status': 'active',
      });

      _clearForm();
      _showSnackbar('Member added successfully');
    } catch (error) {
      _showSnackbar('Error adding member: $error');
    }
  }
}


  // Show a snackbar for feedback
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Clear the form after submission
  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _idController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  // Build the form
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // First Name
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Last Name
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // National ID
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'National ID',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the National ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Submit Button
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // Added to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    );
  }
}
