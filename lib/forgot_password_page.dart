import 'package:flutter/material.dart';
import 'package:plantpal_2025/services.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;
  bool _emailSent = false;

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
      _emailSent = false;
    });

    try {
      final exists = await DatabaseService().isEmailRegistered(_emailController.text.trim());

      if (!exists) {
        setState(() {
          _statusMessage = 'This email is not registered. Please sign up first.';
        });
      } else {
        await AuthService().sendPasswordResetEmail(_emailController.text.trim());
        setState(() {
          _emailSent = true;
          _statusMessage = 'Password reset link sent to email.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to send reset link.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Enter your registered email and we’ll send you a reset link.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  if (_statusMessage != null)
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _emailSent ? Colors.green : Colors.red,
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Send Reset Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Send Reset Link', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
