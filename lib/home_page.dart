import 'package:flutter/material.dart';
import 'options_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA4F4A1), Color(0xFFA4F4A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo without any shape
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                // Animated welcome text
                Text(
                  'Welcome to Plantpal - grow together!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black38,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Get Started button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text(
                      'Get Started',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, OptionsPage.routeName),
                  ),
                ),
                const SizedBox(height: 20),
                // Learn More button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text(
                      'Learn More',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.green[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Learn More'),
                        content: const Text(
                          'This app helps you explore, manage, and enjoy your plants. 🌿🌱',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
