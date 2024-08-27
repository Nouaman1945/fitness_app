import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/splash_out.dart';
import 'Login_screen.dart';
import 'workout_plans_screen.dart'; // Import your workout plans screen
import 'nutrition_plans_screen.dart'; // Import your nutrition plans screen
import 'settings_screen.dart'; // Import your settings screen
import 'profile_screen.dart'; // Import your profile screen

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
        title: const Text('Fitness Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading user data'));
          } else {
            final userData = snapshot.data!;
            final fullName = userData['fullName'] ?? 'User';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hello, $fullName!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome back to your fitness journey. Here\'s what you can do:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _DashboardCard(
                          icon: Icons.person,
                          title: 'View Profile',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ));
                          },
                        ),
                        _DashboardCard(
                          icon: Icons.fitness_center,
                          title: 'Workout Plans',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => WorkoutPlansScreen(),
                            ));
                          },
                        ),
                        _DashboardCard(
                          icon: Icons.restaurant,
                          title: 'Nutrition Plans',
                          color: Colors.green,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NutritionPlansScreen(),
                            ));
                          },
                        ),
                        _DashboardCard(
                          icon: Icons.settings,
                          title: 'Settings',
                          color: Colors.red,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
