import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/welcome.dart'; // Import the WelcomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChamaApp());
}

class ChamaApp extends StatelessWidget {
  const ChamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AwaChama',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WelcomeScreen(), // Start with the WelcomeScreen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Home(),
      },
    );
  }
}
