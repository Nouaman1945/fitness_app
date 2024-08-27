import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/LandingPageIndiv.dart';
import '/screens/IndivSetup.dart'; // Adjust the import path
import '/screens/login_screen.dart'; // Adjust the import path

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkUserSetup(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  Future<Widget> _checkUserSetup(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc['fullName'] != null) {
        // User is signed in and setup is complete
        return LandingPage();
      } else {
        // User is signed in but setup is not complete
        return IndividualSetupScreen();
      }
    } else {
      // User is not signed in
      return LoginScreen(); // Or whatever screen you use for login
    }
  }
}
