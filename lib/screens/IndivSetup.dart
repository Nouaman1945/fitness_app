import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'LandingPageIndiv.dart'; // Ensure the correct import path

class IndividualSetupScreen extends StatefulWidget {
  const IndividualSetupScreen({Key? key}) : super(key: key);

  @override
  _IndividualSetupScreenState createState() => _IndividualSetupScreenState();
}

class _IndividualSetupScreenState extends State<IndividualSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fitnessGoalController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      // Upload image if selected
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profileImages') // Ensure this path is correct in Firebase Storage
            .child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}');

        // Upload the image to Firebase Storage
        final uploadTask = storageRef.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() {
          if (uploadTask.snapshot.state != TaskState.success) {
            throw Exception("File upload failed");
          }
        });

        // Get the download URL
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': _fullNameController.text,
        'email': user.email, // Assuming the user is already signed up
        'age': int.parse(_ageController.text),
        'gender': _genderController.text,
        'fitnessGoal': _fitnessGoalController.text,
        'profileImageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      // Navigate to Landing Page after successful setup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage ()),
      );
    } catch (e) {
      print('Error occurred during data upload: $e');
      setState(() {
        _isLoading = false;
      });

      // Show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while saving your data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Let\'s Get Started!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fitnessGoalController,
                  decoration: const InputDecoration(
                    labelText: 'Fitness Goal',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your fitness goal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Pick Image'),
                  onPressed: _pickImage,
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.file(_image!),
                  ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _uploadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
