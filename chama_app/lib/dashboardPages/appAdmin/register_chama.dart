import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // Add this for JSON encoding
import 'package:http/http.dart' as http; // Add this for HTTP requests

class RegisterChamaPage extends StatefulWidget {
  const RegisterChamaPage({super.key});

  @override
  _RegisterChamaScreenState createState() => _RegisterChamaScreenState();
}

class _RegisterChamaScreenState extends State<RegisterChamaPage> {
  final _formKey = GlobalKey<FormState>();

  String chamaName = '';
  String chamaLocation = '';
  String chamaRegistrationNumber = '';
  String? selectedAdmin; // Field to select Chama Admin
  String meetSchedule = 'weekly'; // Default value
  String? selectedDay; // For weekly option
  DateTime? selectedDate; // For monthly option
  List<String> adminList = []; // List to hold admin usernames

  @override
  void initState() {
    super.initState();
    _fetchAdmins(); // Fetch the list of admins when the widget initializes
  }

  Future<void> _fetchAdmins() async {
    try {
      // Replace with your actual API endpoint to fetch admins
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/accounts/get_admins/'));
      if (response.statusCode == 200) {
        // Assuming the response is a list of admin usernames
        setState(() {
          adminList = List<String>.from(json.decode(response.body));
        });
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch admins: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching admins: $e')),
      );
    }
  }

  // Function to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare data for submission
      final Map<String, dynamic> chamaData = {
        'chama_name': chamaName,
        'location': chamaLocation,
        'registration_number': chamaRegistrationNumber,
        'admin': selectedAdmin, // Include selected admin
        'meet_schedule': meetSchedule,
        'meeting_details': meetSchedule == 'weekly'
            ? {'day': selectedDay}
            : {'date': selectedDate?.toIso8601String()},
      };

      try {
        // Replace with your backend URL
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/accounts/register_chama/'), // Update with your actual API endpoint
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(chamaData),
        );

        if (response.statusCode == 201) {
          // Clear the form after successful submission
          setState(() {
            chamaName = '';
            chamaLocation = '';
            chamaRegistrationNumber = '';
            selectedAdmin = null; // Clear selected admin
            meetSchedule = 'weekly';
            selectedDay = null;
            selectedDate = null;
          });

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chama registered successfully')),
          );
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register Chama: ${response.body}')),
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
        title: const Text('Register a Chama'),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)], // Green shades
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative circles for modern feel
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Chama name field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Chama Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the chama name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        chamaName = value;
                      });
                    },
                  ),
                  // Chama Location field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Chama Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the chama location';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        chamaLocation = value;
                      });
                    },
                  ),
                  // Chama Registration Number field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Chama Registration Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the chama registration number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        chamaRegistrationNumber = value;
                      });
                    },
                  ),
                  // Chama Admin selection field
                  const SizedBox(height: 20),
                  const Text('Select Chama Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: selectedAdmin,
                    items: adminList.map((admin) {
                      return DropdownMenuItem(
                        value: admin,
                        child: Text(admin),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAdmin = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Choose Admin'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a Chama Admin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Meet schedule options (weekly or monthly)
                  const Text('Meet Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: meetSchedule,
                    items: const [
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text('Weekly'),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text('Monthly'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        meetSchedule = value!;
                        selectedDay = null; // Reset selected day when schedule changes
                        selectedDate = null; // Reset selected date when schedule changes
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Select meet schedule'),
                  ),

                  // If weekly is selected, show day picker
                  if (meetSchedule == 'weekly') ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedDay,
                      decoration: const InputDecoration(labelText: 'Select a Day'),
                      items: const [
                        DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                        DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                        DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
                        DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                        DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                        DropdownMenuItem(value: 'Saturday', child: Text('Saturday')),
                        DropdownMenuItem(value: 'Sunday', child: Text('Sunday')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a day for weekly meetings';
                        }
                        return null;
                      },
                    ),
                  ],

                  // If monthly is selected, show date picker
                  if (meetSchedule == 'monthly') ...[
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Select a Date'),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : '',
                      ),
                      validator: (value) {
                        if (selectedDate == null) {
                          return 'Please select a date for monthly meetings';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Register Chama'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
