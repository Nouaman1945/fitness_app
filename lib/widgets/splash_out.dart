import 'package:flutter/material.dart';
import '../screens/Login_screen.dart';
// Ensure the correct path is imported

class SplashScreenOut extends StatelessWidget {
  const SplashScreenOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          'Logging Out...',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
