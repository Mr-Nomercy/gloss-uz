library form_validators;

class GlossFormValidators {
  GlossFormValidators._();

  static String? required(String? value, {String message = "Maydon to'ldirilishi shart"}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? phone(String? value, {String message = "To'g'ri telefon raqam kiriting"}) {
    if (value == null || value.isEmpty) return message;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 9) return message;
    return null;
  }

  static String? email(String? value, {String message = "To'g'ri email kiriting"}) {
    if (value == null || value.isEmpty) return message;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return message;
    return null;
  }

  static String? password(
    String? value, {
    int minLength = 6,
    String? message,
  }) {
    if (value == null || value.isEmpty) return "Parol kiritish shart";
    if (value.length < minLength) return message ?? "Kamida $minLength ta belgi bo'lishi kerak";
    return null;
  }

  static String? confirmPassword(
    String? value,
    String original, {
    String message = "Parollar mos kelmadi",
  }) {
    if (value == null || value.isEmpty) return "Parolni tasdiqlang";
    if (value != original) return message;
    return null;
  }

  static String? numeric(
    String? value, {
    bool allowNegative = false,
    String message = "Faqat raqam kiriting",
  }) {
    if (value == null || value.isEmpty) return message;
    final numRegex = allowNegative
        ? RegExp(r'^-?\d+$')
        : RegExp(r'^\d+$');
    if (!numRegex.hasMatch(value)) return message;
    return null;
  }

  static String? minLength(
    String? value,
    int min, {
    String? message,
  }) {
    if (value == null || value.length < min) {
      return message ?? "Kamida $min ta belgi";
    }
    return null;
  }

  static String? maxLength(
    String? value,
    int max, {
    String? message,
  }) {
    if (value != null && value.length > max) {
      return message ?? "Ko'pi bilan $max ta belgi";
    }
    return null;
  }

  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    String? run(String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    }

    return run;
  }
}
