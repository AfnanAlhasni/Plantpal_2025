// lib/validator.dart
class Validator {
  // EMAIL
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // PASSWORD for Sign-In Page
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // FULL NAME
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Name must contain only letters';
    }
    return null;
  }

  // PHONE NUMBER
  static String? validatePhone(String? value) {
    final _omPhoneRegex = RegExp(r'^[79]\d{7}$');
    if (value == null || value.trim().isEmpty) {
      return 'Enter your phone number';
    }
    if (!_omPhoneRegex.hasMatch(value.trim())) {
      return 'Phone must be 8 digits and start with 7 or 9';
    }
    return null;
  }

  // AGE
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }

    final age = int.tryParse(value);

    if (age == null) {
      return 'Age must be a valid number';
    }

    if (age == 0) {
      return 'Age cannot be zero';
    }

    if (age < 0) {
      return 'Age cannot be negative';
    }

    if (age > 120) {
      return 'Please enter a valid age';
    }

    return null; // valid
  }
}
