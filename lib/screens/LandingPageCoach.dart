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
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome back, Coach $_fullName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            _buildDashboardCard(
              icon: Icons.person,
              title: 'My Clients',
              subtitle: 'Manage your clients',
              onTap: () {
                // Navigate to the My Clients screen
              },
            ),
            _buildDashboardCard(
              icon: Icons.fitness_center,
              title: 'Workout Plans',
              subtitle: 'Create and manage workout plans',
              onTap: () {
                // Navigate to the Workout Plans screen
              },
            ),
            _buildDashboardCard(
              icon: Icons.restaurant,
              title: 'Nutrition Plans',
              subtitle: 'Create and manage nutrition plans',
              onTap: () {
                // Navigate to the Nutrition Plans screen
              },
            ),
            _buildDashboardCard(
              icon: Icons.assessment,
              title: 'Progress Tracking',
              subtitle: 'View and track client progress',
              onTap: () {
                // Navigate to the Progress Tracking screen
              },
            ),
            _buildDashboardCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Manage account settings',
              onTap: () {
                // Navigate to the Settings screen
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.deepPurple),
          title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
        ),
      ),
    );
  }
}

