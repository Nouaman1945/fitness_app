import 'package:flutter/material.dart';
import '../screens/LandingPageIndiv.dart';

class SplashScreenLogin extends StatelessWidget {
  const SplashScreenLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          'Logging In...',
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
