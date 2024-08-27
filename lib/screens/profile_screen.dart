import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc.data() as Map<String, dynamic>;
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No user data available.'));
          } else {
            final userData = snapshot.data!;
            final profileImageUrl = userData['profileImageUrl'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['fullName'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Email: ${userData['email'] ?? 'Not Available'}'),
                  const SizedBox(height: 10),
                  Text('Age: ${userData['age'] ?? 'Not Available'}'),
                  const SizedBox(height: 10),
                  Text('Gender: ${userData['gender'] ?? 'Not Available'}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle profile update
                    },
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
