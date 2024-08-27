import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NutritionPlansScreen extends StatefulWidget {
  const NutritionPlansScreen({Key? key}) : super(key: key);

  @override
  _NutritionPlansScreenState createState() => _NutritionPlansScreenState();
}

class _NutritionPlansScreenState extends State<NutritionPlansScreen> {
  Future<List<Map<String, dynamic>>> _getNutritionPlans() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('nutrition')
          .where('userId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Plans'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getNutritionPlans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No nutrition plans available.'));
          } else {
            final nutritionPlans = snapshot.data!;

            return ListView.builder(
              itemCount: nutritionPlans.length,
              itemBuilder: (context, index) {
                final plan = nutritionPlans[index];
                return ListTile(
                  title: Text(plan['mealType'] ?? 'No Meal Type'),
                  subtitle: Text('Food Items: ${plan['foodItems'] ?? 'None'}\nTotal Calories: ${plan['totalCalories'] ?? '0'}'),
                  contentPadding: const EdgeInsets.all(16.0),
                );
              },
            );
          }
        },
      ),
    );
  }
}
