import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final Map<String, dynamic> workoutData;

  const WorkoutDetailScreen({
    Key? key,
    required this.workoutData,
  }) : super(key: key);

  Future<void> _saveWorkout(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('user_workouts').add({
          'userId': user.uid,
          'workoutName': workoutData['workoutName'],
          'duration': workoutData['duration'],
          'caloriesBurned': workoutData['caloriesBurned'],
          'date': workoutData['date'],
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved successfully!'),
          ),
        );
      } catch (e) {
        print('Error saving workout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save workout. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              workoutData['workoutName'] ?? 'No Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Duration: ${workoutData['duration']} minutes',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Calories Burned: ${workoutData['caloriesBurned']} kcal',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${workoutData['date']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveWorkout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Save this Workout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
