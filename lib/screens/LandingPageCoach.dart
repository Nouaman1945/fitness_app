import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LandingPageCoach extends StatefulWidget {
  const LandingPageCoach({Key? key}) : super(key: key);

  @override
  _LandingPageCoachState createState() => _LandingPageCoachState();
}

class _LandingPageCoachState extends State<LandingPageCoach> {
  String _fullName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoachData();
  }

  Future<void> _fetchCoachData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('coaches').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _fullName = doc.data()?['fullName'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching coach data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the onboarding screen or login screen
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } catch (e) {
      print('Error signing out: $e');
      // Optionally, show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome back Coach $_fullName!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
