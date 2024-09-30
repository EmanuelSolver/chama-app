import 'package:flutter/material.dart';

class RegisterChamaScreen extends StatefulWidget {
  const RegisterChamaScreen({super.key});

  @override
  _RegisterChamaScreenState createState() => _RegisterChamaScreenState();
}

class _RegisterChamaScreenState extends State<RegisterChamaScreen> {
  final _formKey = GlobalKey<FormState>();
  String chamaName = '';
  int membersCount = 0;
  TimeOfDay meetingTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register a Chama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Chama Name'),
                onChanged: (value) {
                  setState(() {
                    chamaName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of Members'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    membersCount = int.parse(value);
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: meetingTime,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      meetingTime = selectedTime;
                    });
                  }
                },
                child: Text('Select Meeting Time: ${meetingTime.format(context)}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save chama details and proceed
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
