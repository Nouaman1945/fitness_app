import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _bioController;
  late TextEditingController _fitnessGoalController;
  late TextEditingController _genderController;

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final userData = doc.data()!;
        _fullNameController = TextEditingController(text: userData['fullName'] ?? '');
        _bioController = TextEditingController(text: userData['bio'] ?? '');
        _fitnessGoalController = TextEditingController(text: userData['fitnessGoal'] ?? '');
        _genderController = TextEditingController(text: userData['gender'] ?? '');
      }
      _controllersInitialized = true;
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': _fullNameController.text,
        'bio': _bioController.text,
        'fitnessGoal': _fitnessGoalController.text,
        'gender': _genderController.text,
      });
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _controllersInitialized ? [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            TextField(
              controller: _fitnessGoalController,
              decoration: InputDecoration(labelText: 'Fitness Goal'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ] : [
            Center(child: CircularProgressIndicator()), // Show loading indicator while initializing
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _fitnessGoalController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}