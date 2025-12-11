// feedback_validator.dart

class FeedbackValidator {
  /// Validate full name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }
    if (value.trim().length < 3) {
      return "Name must be at least 3 characters long";
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    // Basic email pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  /// Validate message
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Message cannot be empty";
    }
    if (value.trim().length < 10) {
      return "Message must be at least 10 characters";
    }
    return null;
  }

  /// Validate rating (1–5 required)
  static String? validateRating(double rating) {
    if (rating == 0) {
      return "Please select a rating";
    }
    return null;
  }
}
