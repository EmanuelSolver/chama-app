import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddChamaMemberPage extends StatefulWidget {
  const AddChamaMemberPage({super.key});

  @override
  _AddChamaMemberPageState createState() => _AddChamaMemberPageState();
}

class _AddChamaMemberPageState extends State<AddChamaMemberPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Function to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare data for submission
      final Map<String, dynamic> memberData = {
        'username': _nameController.text, // Assuming username is same as member's name
        'first_name': _nameController.text.split(' ')[0], // First part of the name
        'last_name': _nameController.text.split(' ')[1],  // Second part of the name
        'national_id': _idController.text,
        'mobile_no': _phoneController.text,
        'email': _emailController.text,
      };

      try {
        // Replace with your backend URL
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/chama/members/'), // Update with your actual API endpoint
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(memberData),
        );

        if (response.statusCode == 201) {
          // Clear the form after successful submission
          _nameController.clear();
          _idController.clear();
          _phoneController.clear();
          _emailController.clear();

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Member added successfully')),
          );
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add member: ${response.body}')),
          );
        }
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Chama Member'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name input field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Member Name (First Last)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the member name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ID input field
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID number';
                  }
                  if (value.length < 6) {
                    return 'ID number should be at least 6 digits long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone input field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Add Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
