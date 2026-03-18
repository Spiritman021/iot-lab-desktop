/// Password strength validation utility.
/// Enforces: min 8 chars, uppercase, lowercase, number, special character.
class PasswordValidator {
  PasswordValidator._();

  /// Validate a password and return null if valid, or error message if invalid.
  static String? validate(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,\.<>\?/\\|`~]'))) {
      return 'Password must contain at least one special character';
    }
    return null; // Valid
  }

  /// Returns a list of all unmet requirements (for UI feedback).
  static List<PasswordRequirement> getRequirements(String password) {
    return [
      PasswordRequirement(
        label: 'At least 8 characters',
        met: password.length >= 8,
      ),
      PasswordRequirement(
        label: 'One uppercase letter (A-Z)',
        met: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        label: 'One lowercase letter (a-z)',
        met: password.contains(RegExp(r'[a-z]')),
      ),
      PasswordRequirement(
        label: 'One number (0-9)',
        met: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        label: 'One special character (!@#\$%...)',
        met: password.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:,\.<>\?/\\|`~]')),
      ),
    ];
  }
}

class PasswordRequirement {
  final String label;
  final bool met;

  const PasswordRequirement({required this.label, required this.met});
}
