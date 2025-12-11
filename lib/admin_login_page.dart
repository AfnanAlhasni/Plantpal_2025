import 'package:flutter/material.dart';
import 'admin_page.dart';

class AdminLoginPage extends StatefulWidget {
  static const routeName = '/adminLogin';
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  String? _error;
  bool _loading = false;

  static const _adminEmail = 'admin@gmail.com';
  static const _adminPassword = 'Admin@123'; // Strong password

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
      _error = null;
    });

    if (_email!.trim() == _adminEmail && _password == _adminPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, AdminPage.routeName);
      });
    } else {
      setState(() {
        _error = 'Invalid email or password';
        _loading = false;
      });
    }
  }

  bool _isStrongPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(_error!, style: const TextStyle(color: Colors.red)),
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.orange[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.orange[50],
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your email';
                        }

                        // Basic email regex
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(v.trim())) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                      onSaved: (v) => _email = v,
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.orange[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.orange[50],
                      ),
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!_isStrongPassword(v)) {
                          return 'Password must be at least 8 characters,\ninclude uppercase, lowercase, number and symbol';
                        }
                        return null;
                      },
                      onSaved: (v) => _password = v,
                    ),

                    const SizedBox(height: 16),
                    _loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
