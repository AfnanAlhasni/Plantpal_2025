import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_home_page.dart';
import 'forgot_password_page.dart';
import 'validator.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signIn';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Sign in successful!'),
            ],
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, AuthHomePage.routeName);
      });
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No account found with this email. Please register first.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password. Please try again.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled. Contact support.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many unsuccessful attempts. Please try again later.';
      } else {
        message = 'Error: ${e.message ?? 'Unknown error occurred.'}';
      }

      setState(() => _error = message);
    } catch (e) {
      setState(() => _error = 'Error: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.orange[700]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.orange[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Sign In'),
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', Icons.email)
                          .copyWith(helperText: 'example@email.com'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration('Password', Icons.lock)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.orange[700],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: Validator.validatePassword,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text('Login',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/signUp'),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
