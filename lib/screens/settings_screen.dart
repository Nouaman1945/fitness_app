import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen Content'),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
