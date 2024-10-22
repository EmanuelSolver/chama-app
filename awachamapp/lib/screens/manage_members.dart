import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatting and validation

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  _ManageMembersScreenState createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Member> members = [];

  String name = '';
  String mobileNumber = '';
  String email = '';
  String location = '';
  String idNumber = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        members.add(Member(
          name: name,
          mobileNumber: mobileNumber,
          email: email,
          location: location,
          idNumber: idNumber,
        ));

        // Clear the form fields
        _nameController.clear();
        _mobileController.clear();
        _emailController.clear();
        _locationController.clear();
        _idNumberController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Members'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                  ),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      } else if (value.length != 10) {
                        return 'Enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      mobileNumber = value;
                    }),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      location = value;
                    }),
                  ),
                  TextFormField(
                    controller: _idNumberController,
                    decoration: const InputDecoration(labelText: 'ID Number'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an ID number';
                      } else if (value.length < 6) {
                        return 'ID number must be at least 6 digits';
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      idNumber = value;
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addMember,
                    child: const Text('Add Member'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(members[index].name),
                    subtitle: Text(
                      'Mobile: ${members[index].mobileNumber}\n'
                      'Email: ${members[index].email}\n'
                      'Location: ${members[index].location}\n'
                      'ID Number: ${members[index].idNumber}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          members.removeAt(index);
                        });
                      },
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

class Member {
  final String name;
  final String mobileNumber;
  final String email;
  final String location;
  final String idNumber;

  Member({
    required this.name,
    required this.mobileNumber,
    required this.email,
    required this.location,
    required this.idNumber,
  });
}


