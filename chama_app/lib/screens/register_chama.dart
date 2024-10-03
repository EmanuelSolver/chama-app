import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterChamaScreen extends StatefulWidget {
  const RegisterChamaScreen({super.key});

  @override
  _RegisterChamaScreenState createState() => _RegisterChamaScreenState();
}

class _RegisterChamaScreenState extends State<RegisterChamaScreen> {
  final _formKey = GlobalKey<FormState>();

  String chamaName = '';
  int membersCount = 0;
  String adminName = '';
  String adminEmail = '';
  String adminMobile = '';
  String adminIdNumber = '';

  String meetSchedule = 'weekly'; // Default value
  String? selectedDay; // For weekly option
  DateTime? selectedDate; // For monthly option

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
                  // Number of members field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Number of Members'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of members';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        membersCount = int.parse(value);
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
                        DropdownMenuItem(
                          value: 'Monday',
                          child: Text('Monday'),
                        ),
                        DropdownMenuItem(
                          value: 'Tuesday',
                          child: Text('Tuesday'),
                        ),
                        DropdownMenuItem(
                          value: 'Wednesday',
                          child: Text('Wednesday'),
                        ),
                        DropdownMenuItem(
                          value: 'Thursday',
                          child: Text('Thursday'),
                        ),
                        DropdownMenuItem(
                          value: 'Friday',
                          child: Text('Friday'),
                        ),
                        DropdownMenuItem(
                          value: 'Saturday',
                          child: Text('Saturday'),
                        ),
                        DropdownMenuItem(
                          value: 'Sunday',
                          child: Text('Sunday'),
                        ),
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
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(selectedDate == null
                          ? 'Select Meeting Date'
                          : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
                    ),
                  ],

                  // Group admin details
                  const SizedBox(height: 20),
                  const Text(
                    'Group Admin Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Admin Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the admin name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        adminName = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Admin Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the admin email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        adminEmail = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Admin Mobile Number'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the admin mobile number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        adminMobile = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Admin ID Number'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the admin ID number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        adminIdNumber = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
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
