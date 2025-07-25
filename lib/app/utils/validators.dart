class Validators {
  /// ✅ Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}",
    ).hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// 🔒 Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// 🆕 Example: Validate Name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (value.trim().length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  /// 📞 Example: Validate Phone Number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateOTP(String? v) {
    if (v == null || v.trim().isEmpty) return 'OTP required';
    if (!RegExp(r'^[0-9]{4,6}$').hasMatch(v.trim())) return 'Enter a valid OTP';
    return null;
  }
}
