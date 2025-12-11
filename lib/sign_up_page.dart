import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'sign_in_page.dart';
import 'validator.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signUp';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _obscurePassword = true;

  // Password requirement checks
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecial = false;

  final _omPhoneRegex = RegExp(r'^[79]\d{7}$');

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _checkPassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasLowercase = password.contains(RegExp(r'[a-z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSpecial = password.contains(RegExp(r'[!@#\$&*~%^(),.?":{}|<>]'));
    });
  }

  Widget _buildRequirement(String text, bool met) {
    return Row(
      children: [
        Icon(met ? Icons.check_circle : Icons.cancel,
            color: met ? Colors.green : Colors.red, size: 18),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      final user = userCredential.user;
      if (user == null) throw Exception("User creation failed");

      final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      await dbRef.set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registration Successful(تم التسجيل بنجاح)'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 20),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, SignInPage.routeName);
      });
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                      controller: _fullNameController,
                      decoration: _inputDecoration('Full Name', Icons.person),
                      validator: Validator.validateFullName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email', Icons.email)
                          .copyWith(helperText: 'example@email.com'),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('Phone Number', Icons.phone)
                          .copyWith(hintText: 'Start with 7 or 9', counterText: ''),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      maxLength: 8,
                      validator: Validator.validatePhone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: _inputDecoration('Age', Icons.calendar_today),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: Validator.validateAge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: _inputDecoration('Password', Icons.lock)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                      onChanged: _checkPassword,
                      validator: (v) {
                        if (!(hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecial))
                          return 'Password does not meet all requirements';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRequirement("At least 8 characters", hasMinLength),
                        _buildRequirement("Uppercase letter", hasUppercase),
                        _buildRequirement("Lowercase letter", hasLowercase),
                        _buildRequirement("Number", hasNumber),
                        _buildRequirement("Special character (@, #, ...)", hasSpecial),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                        child: const Text('Register', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/signIn'),
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold),
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
