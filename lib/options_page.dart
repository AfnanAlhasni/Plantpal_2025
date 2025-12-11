import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';
import 'admin_login_page.dart';

class OptionsPage extends StatefulWidget {
  static const routeName = '/options';

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  int _logoTapCount = 0;
  bool _showAdminPassword = false;
  final TextEditingController _adminPasswordController = TextEditingController();
  final String _adminPassword = "Admin@123";

  void _onLogoTapped() {
    setState(() {
      _logoTapCount++;
      if (_logoTapCount >= 3) {
        _showAdminPassword = true;
        _logoTapCount = 0; // 
      }
    });
  }

  void _checkAdminPassword() {
    if (_adminPasswordController.text == _adminPassword) {
      Navigator.pushNamed(context, AdminLoginPage.routeName);
      _adminPasswordController.clear();
      setState(() {
        _showAdminPassword = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grow 🌱'),
        backgroundColor: Colors.green[700],
      ),
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
                // Logo
                GestureDetector(
                  onTap: _onLogoTapped,
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Discover, learn, and grow with us!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add, size: 28),
                    label: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, SignUpPage.routeName),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login, size: 28),
                    label: const Text('Sign In', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, SignInPage.routeName),
                  ),
                ),
                const SizedBox(height: 20),

                if (_showAdminPassword)
                  Column(
                    children: [
                      TextField(
                        controller: _adminPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter admin password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text('Confirm Admin'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _checkAdminPassword,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
