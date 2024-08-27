import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'EditProfileScreen.dart';


class ProfileScreen extends StatelessWidget {
  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {}; // Handle case where user is not logged in
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {}; // Handle case where user data is not found
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {}; // Return empty map on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error loading profile data'));
          } else {
            final userData = snapshot.data!;
            final profileImageUrl = userData['profileImageUrl'] ?? 'assets/images/default_profile_image.jpg';
            final fullName = userData['fullName'] ?? 'John Doe';
            final bio = userData['bio'] ?? 'No bio available';
            final fitnessGoal = userData['fitnessGoal'] ?? 'No fitness goal set';
            final gender = userData['gender'] ?? 'Not specified';
            final email = userData['email'] ?? 'No email provided'; // Assuming email is stored in Firestore

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profileImageUrl),
                    onBackgroundImageError: (error, stackTrace) {
                      // Handle image load error
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/default_profile_image.jpg'),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Profile Name
                  Text(fullName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // Profile Bio
                  Text(bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  // Fitness Goal
                  Text('Fitness Goal: $fitnessGoal', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  // Gender
                  Text('Gender: $gender', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  // Profile Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Total Calories Burned', style: TextStyle(fontSize: 18)),
                          Text('10000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Total Workouts', style: TextStyle(fontSize: 18)),
                          Text('50', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Streak', style: TextStyle(fontSize: 18)),
                          Text('21 days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Profile Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()),
                          );
                        },
                        child: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to view achievements
                        },
                        child: Text('View Achievements'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
    );
  }
}
