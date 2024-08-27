import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class NutritionPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Plans'),
      ),
      body: Center(
        child: Text('Nutrition Plans Screen Content'),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1), // Update index for Nutrition Plans screen
    );
  }
}
