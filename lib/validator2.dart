// lib/validator2.dart

class PlantValidator {
  /// -------------------------------
  /// TEXT INPUT VALIDATIONS
  /// -------------------------------

  /// Validates plant name (letters & spaces, min 3 chars)
  static String? validatePlantName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter plant name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }

    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Only letters and spaces are allowed';
    }
    return null;
  }

  /// Validates a new user-added dropdown text entry
  static String? validateNewDropdownText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }

    if (value.trim().length < 3) {
      return '$fieldName must be at least 3 characters';
    }

    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Only letters and spaces are allowed';
    }

    return null;
  }

  /// -------------------------------
  /// IMAGE NAME VALIDATION (OPTIONAL)
  /// -------------------------------
  static String? validateImageName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the image file name';
    }

    final regex = RegExp(r'^[a-zA-Z0-9_\-]+\.(jpg|jpeg|png|gif|bmp|webp)$');
    if (!regex.hasMatch(value.trim().toLowerCase())) {
      return 'Enter a valid image name (e.g. plant.jpg)';
    }

    return null;
  }

  /// -------------------------------
  /// DROPDOWN VALIDATIONS
  /// -------------------------------

  static String? validateScientificName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a scientific name';
    }
    return null;
  }

  static String? validateHabitat(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a habitat';
    }
    return null;
  }

  static String? validateCategoryType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category type';
    }
    return null;
  }

  static String? validateRoute(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a plant info route';
    }

    if (!value.startsWith('/')) {
      return 'Route must start with "/" (e.g. /Mango)';
    }

    final regex = RegExp(r'^\/[A-Za-z0-9\s]+$');
    if (!regex.hasMatch(value)) {
      return 'Route can only contain letters, numbers, and spaces';
    }

    return null;
  }

  /// -------------------------------
  /// OPTIONAL URL VALIDATION
  /// -------------------------------
  static String? validateLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional
    }

    final regex = RegExp(
      r'^(https?:\/\/)?([\w\-])+(\.[\w\-]+)+[/#?]?.*$',
      caseSensitive: false,
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid URL (e.g. https://example.com)';
    }

    return null;
  }
}
