import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audit/audit_context.dart';
import '../audit/audit_service.dart';
import '../database/app_database.dart';
import 'password_validator.dart';

/// User roles — Admin / Lab Tech / Viewer
class UserRoles {
  static const String admin = 'admin';
  static const String labtech = 'labtech';
  static const String viewer = 'viewer';

  /// Display-friendly name
  static String displayName(String role) {
    switch (role) {
      case admin:
        return 'Admin';
      case labtech:
        return 'Lab Tech';
      case viewer:
        return 'Viewer';
      default:
        return role.toUpperCase();
    }
  }

  /// All roles for dropdown
  static const List<String> all = [admin, labtech, viewer];

  /// Permission helpers
  /// Admin: full access to everything
  /// Lab Tech: can log, graph, alarm, print calibration — but NOT start/reset/edit calibration
  /// Viewer: view-only, no actions at all

  /// Can perform calibration actions (start, reset, edit table)
  static bool canCalibrate(String role) => role == admin;

  /// Can perform logging, graph, alarm actions
  static bool canLog(String role) => role == admin || role == labtech;

  /// Can set alarm values
  static bool canAlarm(String role) => role == admin || role == labtech;

  /// Can access admin settings
  static bool canAccessAdmin(String role) => role == admin;

  /// Is view-only (no actions at all)
  static bool isViewOnly(String role) => role == viewer;
}

/// Auth service — handles local auth with SQLite + bcrypt.
/// First signup creates the Admin account; subsequent users are
/// created by the Admin from within the app.
class AuthService extends ChangeNotifier {
  AuthService._();

  static AuthService? _instance;

  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  final AppDatabase _db = AppDatabase.instance;

  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  /// Role hierarchy check — admin can mutate anyone, others cannot
  static bool canMutate(String targetRole, String currentRole) {
    if (currentRole != UserRoles.admin) return false;
    return true;
  }

  /// Initialize: check for existing session
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId != null) {
        _currentUser = await _db.getUserById(userId);
        if (_currentUser != null) {
          AuditContext.setActor(
            userId: _currentUser!.id,
            userName: _currentUser!.name,
          );
        }
      }
    } catch (e) {
      debugPrint('Auth init error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Register a new user
  Future<String> register({
    required String name,
    required String email,
    required String password,
    String role = UserRoles.viewer,
    int sessionDuration = 30,
    int passwordExpiryDays = 90,
  }) async {
    // Validate password strength
    final validationError = PasswordValidator.validate(password);
    if (validationError != null) {
      throw Exception(validationError);
    }

    // Check if email already exists
    final existing = await _db.getUserByEmail(email);
    if (existing != null) {
      throw Exception('Email already registered');
    }

    final hash = BCrypt.hashpw(password, BCrypt.gensalt());
    final userId = await _db.insertUser(UsersCompanion.insert(
      name: name,
      email: email,
      passwordHash: hash,
      role: Value(role),
      sessionDuration: Value(sessionDuration),
      passwordExpiryDays: Value(passwordExpiryDays),
    ));

    // Save initial password to history
    await _db.addPasswordHistory(userId, hash);
    await AuditService.instance.log(
      category: AuditService.catUser,
      action: 'create',
      entityType: 'user',
      entityId: userId.toString(),
      details: {'email': email, 'role': role, 'name': name},
    );

    return 'User registered successfully';
  }

  /// Login
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await _db.getUserByEmail(email);
    if (user == null) {
      await AuditService.instance.log(
        category: AuditService.catAuth,
        action: 'login',
        status: 'failed',
        details: {'email': email, 'reason': 'Unknown account'},
      );
      throw Exception('Account not registered or deleted');
    }

    final isCorrect = BCrypt.checkpw(password, user.passwordHash);
    if (!isCorrect) {
      await AuditService.instance.log(
        category: AuditService.catAuth,
        action: 'login',
        entityType: 'user',
        entityId: user.id.toString(),
        status: 'failed',
        details: {'email': email, 'reason': 'Incorrect password'},
      );
      throw Exception('Invalid email or password');
    }

    // Block inactive users
    if (!user.isActive) {
      throw Exception('Your account has been deactivated. Contact an admin.');
    }

    _currentUser = user;
    AuditContext.setActor(userId: user.id, userName: user.name);

    // Persist session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);

    notifyListeners();
    await AuditService.instance.log(
      category: AuditService.catAuth,
      action: 'login',
      entityType: 'user',
      entityId: user.id.toString(),
      details: {'email': user.email},
    );

    // Check password expiry (after successful login)
    if (isPasswordExpired(user)) {
      throw PasswordExpiredException(
          'Your password has expired. Please change it now.');
    }

    return user;
  }

  /// Check if a user's password has expired
  bool isPasswordExpired(User user) {
    if (user.passwordExpiryDays == 0) return false; // 0 = never expires
    final expiresAt = user.passwordChangedAt
        .add(Duration(days: user.passwordExpiryDays));
    return DateTime.now().isAfter(expiresAt);
  }

  /// Days until password expires (for UI warning)
  int daysUntilExpiry(User user) {
    if (user.passwordExpiryDays == 0) return -1; // never
    final expiresAt = user.passwordChangedAt
        .add(Duration(days: user.passwordExpiryDays));
    return expiresAt.difference(DateTime.now()).inDays;
  }

  /// Change password — validates strength, prevents reuse of last 5
  Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    // Validate new password strength
    final validationError = PasswordValidator.validate(newPassword);
    if (validationError != null) {
      throw Exception(validationError);
    }

    // Verify current password
    final user = await _db.getUserById(userId);
    if (user == null) throw Exception('User not found');
    if (!BCrypt.checkpw(currentPassword, user.passwordHash)) {
      throw Exception('Current password is incorrect');
    }

    // Check against last 5 passwords
    final history = await _db.getPasswordHistory(userId);
    final last5 = history.take(5);
    for (final h in last5) {
      if (BCrypt.checkpw(newPassword, h.passwordHash)) {
        throw Exception(
            'Cannot reuse any of your last 5 passwords. Choose a different password.');
      }
    }

    // Update password
    final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    await _db.changeUserPassword(userId, newHash);

    // Refresh current user
    _currentUser = await _db.getUserById(userId);
    if (_currentUser != null) {
      AuditContext.setActor(
        userId: _currentUser!.id,
        userName: _currentUser!.name,
      );
    }
    notifyListeners();
    await AuditService.instance.log(
      category: AuditService.catAuth,
      action: 'password_changed',
      entityType: 'user',
      entityId: userId.toString(),
    );
  }

  /// Logout
  Future<void> logout() async {
    final user = _currentUser;
    if (user != null) {
      await AuditService.instance.log(
        category: AuditService.catAuth,
        action: 'logout',
        entityType: 'user',
        entityId: user.id.toString(),
      );
    }
    _currentUser = null;
    AuditContext.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }

  /// Check if any admin user exists (first-time setup check)
  Future<bool> adminExists() async {
    final user = await _db.getAdminUser();
    return user != null;
  }

  // Keep backward compat for any remaining references
  Future<bool> superuserExists() => adminExists();
}

/// Special exception for password expiry — used to trigger
/// the change-password dialog on login.
class PasswordExpiredException implements Exception {
  final String message;
  PasswordExpiredException(this.message);

  @override
  String toString() => message;
}
