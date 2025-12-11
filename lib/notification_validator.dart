// notification_validator.dart

class NotificationValidator {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title cannot be empty';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 50) {
      return 'Title cannot exceed 50 characters';
    }
    return null;
  }

  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    if (value.trim().length < 5) {
      return 'Message must be at least 5 characters long';
    }
    if (value.trim().length > 300) {
      return 'Message cannot exceed 300 characters';
    }
    return null;
  }
}
