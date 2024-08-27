import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/splash_out.dart';
// Ensure the correct path is imported
import 'Login_screen.dart'; // Ensure the correct path is imported

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreenOut()),
      );
    } catch (e) {
      // Handle sign-out errors here
      print('Sign-out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Fitness App'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hello, User!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome back to your fitness journey. Here are some of the things you can do:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Profile Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('View Profile', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigate to Workout Plans Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Workout Plans', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigate to Nutrition Plans Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Nutrition Plans', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigate to Settings Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Settings', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
