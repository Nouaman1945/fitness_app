import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/LandingPageCoach.dart';
import 'package:fitness_app/screens/LandingPageIndiv.dart';
import 'package:flutter/material.dart';
import 'widgets/splash_screen.dart';
import 'screens/onboarding_flow.dart';
import 'screens/workout_plans_screen.dart';
import 'screens/nutrition_plans_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

import 'screens/login_screen.dart'; // Ensure the correct import path for Login Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show a splash screen while checking authentication
          }
          if (snapshot.hasData) {
            // User is authenticated
            return snapshot.data!.email == 'coach@example.com' // Example condition for Coach
                ? const LandingPageCoach()
                : const LandingPage(); // Replace with your individual landing page
          } else {
            // User is not authenticated
            return const LoginScreen(); // Replace with your login screen
          }
        },
      ),
      routes: {
        '/onboarding': (context) => OnboardingFlow(),
        '/workout_plans': (context) => WorkoutPlansScreen(),
        '/nutrition_plans': (context) => NutritionPlansScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/login': (context) => const LoginScreen(), // Route for Login Screen
      },
    );
  }
}
