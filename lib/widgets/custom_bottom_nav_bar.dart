import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed('/workout_plans');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('/nutrition_plans');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('/LandingPageIndiv');
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed('/profile');
            break;
          case 4:
            Navigator.of(context).pushReplacementNamed('/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Nutrition',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed, // Ensures all items are visible
    );
  }
}
