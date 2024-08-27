import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Account Settings'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                // Navigate to Account Settings
              },
            ),
            ListTile(
              title: const Text('Privacy Settings'),
              leading: const Icon(Icons.lock),
              onTap: () {
                // Navigate to Privacy Settings
              },
            ),
            ListTile(
              title: const Text('Notification Settings'),
              leading: const Icon(Icons.notifications),
              onTap: () {
                // Navigate to Notification Settings
              },
            ),
            ListTile(
              title: const Text('Help & Support'),
              leading: const Icon(Icons.help),
              onTap: () {
                // Navigate to Help & Support
              },
            ),
          ],
        ),
      ),
    );
  }
}
