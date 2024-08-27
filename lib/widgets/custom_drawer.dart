import 'package:fitness_app/widgets/splash_out.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/profile_screen.dart';
import '../screens/workout_plans_screen.dart';
import '../screens/nutrition_plans_screen.dart';
import '../screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading user data'));
          } else {
            final userData = snapshot.data!;
            final profileImageUrl = userData['profileImageUrl'];

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(userData['fullName'] ?? 'Fitness App User'),
                  accountEmail: null,
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      print('Error loading profile image');
                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('View Profile'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('Workout Plans'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WorkoutPlansScreen(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: const Text('Nutrition Plans'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NutritionPlansScreen(),
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () => _signOut(context),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreenOut()),
      );
    } catch (e) {
      print('Sign-out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
  }
}
