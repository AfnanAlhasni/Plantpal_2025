import 'package:flutter/material.dart';
import 'package:plantpal_2025/auth_home_page.dart';
import 'plants_overview_page.dart'; // ✅ Import your home page

class ThankYouPage extends StatelessWidget {
  static const routeName = '/thankYou';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your feedback has been submitted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // ✅ Navigate directly to PlantsOverviewPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthHomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
