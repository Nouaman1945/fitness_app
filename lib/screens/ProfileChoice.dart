import 'package:flutter/material.dart';
import 'CoachSetupScreen.dart';
import 'IndivSetup.dart';

class AccountSetupScreen extends StatelessWidget {
  const AccountSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Are you a Professional (Coach) or an Individual?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildChoiceButton(
                  context,
                  'Professional (Coach)',
                      () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CoachSetupScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildChoiceButton(
                  context,
                  'Individual',
                      () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const IndividualSetupScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      child: Text(text),
    );
  }
}
