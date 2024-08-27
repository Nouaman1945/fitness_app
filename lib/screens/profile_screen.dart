import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Screen Content'),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
    );
  }
}
