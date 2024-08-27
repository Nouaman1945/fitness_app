import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/screens/LandingPageIndiv.dart';
import 'package:flutter/material.dart';
import 'widgets/splash_screen.dart';
import 'screens/onboarding_flow.dart';
import 'screens/workout_plans_screen.dart';
import 'screens/nutrition_plans_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

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
      initialRoute: '/splash', // Start with the splash screen
      routes: {
        '/splash': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingFlow(),
        '/workout_plans': (context) => WorkoutPlansScreen(),
        '/LandingPageIndiv': (context) => LandingPage(),
        '/nutrition_plans': (context) => NutritionPlansScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
