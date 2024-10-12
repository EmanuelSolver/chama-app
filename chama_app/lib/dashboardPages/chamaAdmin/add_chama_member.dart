import 'package:flutter/material.dart';

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
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you would usually send the data to the backend or process it
      print('Name: ${_nameController.text}');
      print('ID: ${_idController.text}');
      print('Phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');

      // Clear the form after submission
      _nameController.clear();
      _idController.clear();
      _phoneController.clear();
      _emailController.clear();

      // Show a success message (you can replace this with a backend submission logic)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully')),
      );
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
                  labelText: 'Member Name',
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
