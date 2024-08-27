import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CoachesScreen extends StatelessWidget {
  const CoachesScreen({Key? key}) : super(key: key);

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat.yMMMMd().add_jms().format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaches'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('coaches').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No coaches found.'));
          }

          final coaches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: coaches.length,
            itemBuilder: (context, index) {
              final coach = coaches[index];
              final bio = coach['bio'] ?? '';
              final certifications = coach['certifications'] ?? '';
              final fullName = coach['fullName'] ?? '';
              final location = coach['location'] ?? '';
              final pricing = coach['pricing'] ?? 0;
              final profileImageUrl = coach['profileImageUrl'];
              final sports = List<String>.from(coach['sports'] ?? []);

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      profileImageUrl != null
                          ? CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(profileImageUrl),
                      )
                          : CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/default_profile_image.jpg'),
                      ),
                      const SizedBox(height: 10),
                      // Full Name
                      Text(
                        fullName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Bio
                      Text('Bio: $bio'),
                      const SizedBox(height: 10),
                      // Certifications
                      Text('Certifications: $certifications'),
                      const SizedBox(height: 10),
                      // Location
                      Text('Location: $location'),
                      const SizedBox(height: 10),
                      // Pricing
                      Text('Pricing: \MAD ${pricing.toString()}'),
                      const SizedBox(height: 10),
                      // Sports
                      Text('Sports: ${sports.join(', ')}'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
