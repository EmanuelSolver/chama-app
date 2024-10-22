import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Fetch user data from Firestore using uid
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Extract user fields from Firestore
          final firstName = userDoc['first_name'];
          final lastName = userDoc['second_name'];
          final userRole = userDoc['user_role'];
          final mobileNo = userDoc['mobile_no'];
          final nationalId = userDoc['national_id'] ?? 0;
          final email = user.email!; // Ensure it's non-null

          // Fetch ChamaMembership document using the user's UID
          final membershipDoc = await FirebaseFirestore.instance
              .collection('chamamembership')
              .doc(user.uid) // Assuming UID is used as the document ID
              .get();

          if (membershipDoc.exists) {
            // Extract Chama ID from the membership document
            final chamaId = membershipDoc['chama_id']; // Ensure this is a String

            // Fetch Chama details using Chama ID
            final chamaDoc = await FirebaseFirestore.instance
                .collection('chama')
                .doc(chamaId)
                .get();

            if (chamaDoc.exists) {
              // Extract Chama details
              final chamaName = chamaDoc['name'];
              final chamaLocation = chamaDoc['location'];
              final chamaday = chamaDoc['day_or_date'];
              final registrationNo = chamaDoc['registration_no'];
              final meetSchedule = chamaDoc['meet_schedule'];

              // Combine first_name and second_name to form the username
              final username = '$firstName $lastName';

              // Debugging prints to check values
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('username', username);
              await prefs.setString('email', email);
              await prefs.setString('userRole', userRole);
              await prefs.setString('mobileNo', mobileNo);
              await prefs.setString('firstName', firstName);
              await prefs.setString('lastName', lastName);
              await prefs.setString('nationalId', nationalId.toString());
              await prefs.setString('chamaId', chamaId.toString());
              await prefs.setString('chamaName', chamaName);
              await prefs.setString('chamaLocation', chamaLocation);
              await prefs.setString('chamaday', chamaday.toString());
              await prefs.setString('registrationNo', registrationNo);
              await prefs.setString('meetSchedule', meetSchedule);

              // Navigate to Dashboard with user details
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    userRole: userRole,
                    username: username,
                    email: email,
                    chama: chamaName, // Pass the chama name or other details
                  ),
                ),
              );
            } else {
              // Handle case where Chama document does not exist
              print('Chama document does not exist');
            }
          } else {
            // Handle case where the membership document does not exist
            print('ChamaMembership document does not exist');
          }

        } else {
          // Handle case where the user document does not exist
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Login failed: $e');
      // Show error to the user using Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Wrong credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient for a bright and modern look
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF8BC34A)
                ], // Green gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 0, 252, 34), // Lawngreen
                                Color.fromARGB(255, 3, 85, 3), // Darker green
                              ], // Gradient colors
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              elevation:
                                  0, // Remove elevation for gradient effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors
                                  .transparent, // Use transparent to show the gradient
                            ),
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
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
