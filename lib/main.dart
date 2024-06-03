import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification_ui/profile.dart';
import 'package:otp_verification_ui/registration.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter OTP Verification',
      debugShowCheckedModeBanner: false,
      home: MainApp(),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Future<void> _checkAuthentication() async {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // User exists, navigate to profile screen
          Navigator.pushReplacement(
            context as BuildContext,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else {
          // User does not exist, navigate to registration screen
          Navigator.pushReplacement(
            context as BuildContext,
            MaterialPageRoute(builder: (context) => Registration()),
          );
        }
      }
    });
  }
}
