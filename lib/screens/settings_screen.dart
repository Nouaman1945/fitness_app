import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/splash_out.dart'; // Ensure this path is correct

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreenOut()),
      ); // Redirect to splash out screen
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('View Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pushNamed('/profile'); // Navigate to profile screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              onTap: () {
                // Implement password change logic here
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Privacy Settings'),
              leading: const Icon(Icons.privacy_tip),
              onTap: () {
                // Implement privacy settings logic here
              },
            ),
            const Divider(),
            const Spacer(),
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.logout),
              onTap: () => _logout(context),
              tileColor: Colors.redAccent.withOpacity(0.1),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
