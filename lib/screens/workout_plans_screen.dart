import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/custom_drawer.dart';
import 'workout_detail_screen.dart'; // Import the WorkoutDetailScreen

class WorkoutPlansScreen extends StatefulWidget {
  @override
  _WorkoutPlansScreenState createState() => _WorkoutPlansScreenState();
}

class _WorkoutPlansScreenState extends State<WorkoutPlansScreen> {
  final List<Map<String, String>> predefinedWorkouts = [
    {'name': 'Full Body Workout', 'description': 'A comprehensive workout plan for full body strength.'},
    {'name': 'Cardio Blast', 'description': 'High-intensity cardio workout to boost endurance.'},
    {'name': 'Strength Training', 'description': 'Focus on building muscle strength with targeted exercises.'},
  ];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _addWorkout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('workouts').add({
        'userId': user.uid,
        'workoutName': _nameController.text,
        'description': _descriptionController.text,
        'date': Timestamp.now(),
      });

      // Clear the text fields
      _nameController.clear();
      _descriptionController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout plan added successfully!')),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add workout plan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans'),
      ),
      drawer: const CustomDrawer(), // Include your app drawer here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display predefined workout plans
            Expanded(
              child: ListView.builder(
                itemCount: predefinedWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = predefinedWorkouts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(workout['name']!),
                      subtitle: Text(workout['description']!),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WorkoutDetailScreen(
                            workoutData: {
                              'workoutName': workout['name']!,
                              'description': workout['description']!,
                              'duration': 'Not specified', // You can customize this
                              'caloriesBurned': 'Not specified', // You can customize this
                              'date': 'Not specified', // You can customize this
                            },
                          ),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
            // Form to add custom workout plan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add Your Workout Plan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Workout Name'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addWorkout,
                    child: Text('Add Workout Plan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
