import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

/// Auth service — replaces backend's user.service.ts JWT auth.
/// Uses local SQLite + bcrypt with SharedPreferences for session persistence.
class AuthService extends ChangeNotifier {
  final AppDatabase _db = AppDatabase.instance;

  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  /// Role hierarchy check (matches backend's canMutate)
  static bool canMutate(String targetRole, String currentRole) {
    if (currentRole == 'user') return false;
    if (currentRole == 'admin' && targetRole == 'superuser') return false;
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

  /// Register a new user (matches backend's registerUser)
  Future<String> register({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    // Check if email already exists
    final existing = await _db.getUserByEmail(email);
    if (existing != null) {
      throw Exception('Email already registered');
    }

    // Only one superuser allowed
    if (role == 'superuser') {
      final superuser = await _db.getSuperuser();
      if (superuser != null) {
        throw Exception('Superuser already exists');
      }
    }

    final hash = BCrypt.hashpw(password, BCrypt.gensalt());
    await _db.insertUser(UsersCompanion.insert(
      name: name,
      email: email,
      passwordHash: hash,
      role: Value(role),
    ));

    return 'User registered successfully';
  }

  /// Login (matches backend's loginUser)
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

  /// Check if superuser exists (matches backend's getSuperuser)
  Future<bool> superuserExists() async {
    final user = await _db.getSuperuser();
    return user != null;
  }
}
