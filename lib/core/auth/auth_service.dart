import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

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
  }) async {
    // Check if email already exists
    final existing = await _db.getUserByEmail(email);
    if (existing != null) {
      throw Exception('Email already registered');
    }

    final hash = BCrypt.hashpw(password, BCrypt.gensalt());
    await _db.insertUser(UsersCompanion.insert(
      name: name,
      email: email,
      passwordHash: hash,
      role: Value(role),
      sessionDuration: Value(sessionDuration),
    ));

    return 'User registered successfully';
  }

  /// Login
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await _db.getUserByEmail(email);
    if (user == null) {
      throw Exception('Account not registered or deleted');
    }

    final isCorrect = BCrypt.checkpw(password, user.passwordHash);
    if (!isCorrect) {
      throw Exception('Invalid email or password');
    }

    // Block inactive users
    if (!user.isActive) {
      throw Exception('Your account has been deactivated. Contact an admin.');
    }

    _currentUser = user;

    // Persist session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);

    notifyListeners();
    return user;
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
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
