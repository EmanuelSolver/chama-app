import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package

class RegisterChamaPage extends StatefulWidget {
  const RegisterChamaPage({super.key});

  @override
  _RegisterChamaScreenState createState() => _RegisterChamaScreenState();
}

class _RegisterChamaScreenState extends State<RegisterChamaPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Chama fields
  String chamaName = '';
  String chamaLocation = '';
  String chamaRegistrationNumber = '';
  String meetSchedule = 'weekly'; // Default value
  String? selectedDay; // For weekly option
  String? selectedDate; // For monthly option

  // Admin user details
  String firstName = '';
  String secondName = '';
  String email = '';
  String mobileNo = '';
  String nationalId = '';

  // Function to handle form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create the admin user with Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: 'Password123',
        );
        User? user = userCredential.user;

        if (user != null) {
          // Prepare data for Firestore for the Chama
          final Map<String, dynamic> chamaData = {
            'name': chamaName,
            'location': chamaLocation,
            'registration_no': chamaRegistrationNumber,
            'meet_schedule': meetSchedule,
            'day_or_date': meetSchedule == 'weekly' ? selectedDay : selectedDate,
            'created_on': FieldValue.serverTimestamp(),
            'admin_id': user.uid, // Link the admin to the Chama
          };

          // Add the chama data to Firestore
          DocumentReference chamaRef = await FirebaseFirestore.instance.collection('chama').add(chamaData);

          // Save the admin user details to Firestore under the 'users' collection
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'first_name': firstName,
            'second_name': secondName,
            'mobile_no': mobileNo,
            'national_id': nationalId,
            'user_role': 'chamaAdmin',
          });

          // Save the Chama membership details to Firestore under the 'chamaMembership' collection  
          await FirebaseFirestore.instance.collection('chamamembership').doc(user.uid).set({
            'chama_id': chamaRef.id, // Chama ID from the newly created Chama document
            'is_admin': true,         // Since this user is the Chama admin
            'joined_date': FieldValue.serverTimestamp(), // Set the current timestamp
            'status': 'active',       // Set the membership as active
          });


          // Clear the form after successful submission
          setState(() {
            chamaName = '';
            chamaLocation = '';
            chamaRegistrationNumber = '';
            meetSchedule = 'weekly';
            selectedDay = null;
            selectedDate = null;
            firstName = '';
            secondName = '';
            email = '';
            mobileNo = '';
            nationalId = '';
          });

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chama and Admin registered successfully')),
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
        title: const Text('Register a Chama and Admin'),
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

                  if (meetSchedule == 'monthly') ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedDate,
                      decoration: const InputDecoration(labelText: 'Select a Day of the Month (1-28)'),
                      items: List.generate(28, (index) {
                        final day = (index + 1).toString();
                        return DropdownMenuItem(value: day, child: Text(day));
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a day of the month for monthly meetings';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  
                  // Admin details section
                  const Text('Admin Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the first name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        firstName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Second Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the second name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        secondName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mobile Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the mobile number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        mobileNo = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'National ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the national ID';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        nationalId = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Register Chama and Admin'),
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
