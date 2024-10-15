import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? userId; 

  @override
  void initState() {
    super.initState();
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Retrieve chamaId from local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? chamaId = prefs.getInt('chamaId');

      if (chamaId == null) {
        _showSnackbar('Chama ID not found. Please make sure you are logged in and belong to a Chama.');
        return;
      }

      // Prepare member data including chamaId
      final Map<String, dynamic> memberData = {
        'username': _usernameController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'national_id': _idController.text,
        'mobile_no': _phoneController.text,
        'email': _emailController.text,
        'chama': chamaId, // Use chamaId from local storage
      };

      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/accounts/register_member/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(memberData),
        );

        if (response.statusCode == 201) {
          _clearForm();
          _showSnackbar('Member added successfully');
        } else {
          _showSnackbar('Failed to add member: ${response.body}');
        }
      } catch (error) {
        _showSnackbar('Error submitting form: $error');
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
    _usernameController.clear();
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

          // Username
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the username';
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
        title: const Text('Add Chama Member'),
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





