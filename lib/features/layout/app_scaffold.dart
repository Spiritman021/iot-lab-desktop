import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/auth_service.dart';
import '../../core/mqtt/mqtt_service.dart';
import '../auth/change_password_dialog.dart';

/// App scaffold with sidebar, session timer countdown, and auto-logout.
class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  State<AppScaffold> createState() => AppScaffoldState();

  /// Access the scaffold state from descendant widgets
  static AppScaffoldState of(BuildContext context) {
    return context.findAncestorStateOfType<AppScaffoldState>()!;
  }
}

class AppScaffoldState extends State<AppScaffold> {
  late final AuthService _authService;
  late final MqttService _mqttService;

  AuthService get authService => _authService;
  MqttService get mqttService => _mqttService;

  int _selectedIndex = 0;
  bool _isDark = false;

  // ── Session Timer ──
  Timer? _sessionTimer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _authService = AuthService.instance;
    _mqttService = MqttService.instance;

    // Initialize auth and MQTT
    _authService.init().then((_) {
      if (_authService.isAuthenticated) {
        _mqttService.loadSettings().then((_) => _mqttService.connect());
        _startSessionTimer();
      }
    });

    _loadThemePreference();
  }

  // ── Session Timer Methods ──

  void _startSessionTimer() {
    final user = _authService.currentUser;
    if (user == null) return;

    _totalSeconds = user.sessionDuration * 60;
    _remainingSeconds = _totalSeconds;

    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds <= 0) {
        _handleSessionTimeout();
      }
    });
  }

  void resetSessionTimer() {
    final user = _authService.currentUser;
    if (user == null) return;
    setState(() {
      _totalSeconds = user.sessionDuration * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _handleSessionTimeout() {
    _sessionTimer?.cancel();
    _authService.logout();
    if (mounted) {
      context.go('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please log in again.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String get _formattedRemaining {
    final mins = _remainingSeconds ~/ 60;
    final secs = _remainingSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String get _formattedTotal {
    final mins = _totalSeconds ~/ 60;
    return '$mins min${mins > 1 ? 's' : ''}';
  }

  // ── Theme ──

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = !_isDark;
    });
    await prefs.setBool('isDark', _isDark);
  }

  bool get isDark => _isDark;

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/files');
        break;
      case 2:
        context.go('/settings/admin');
        break;
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    final user = _authService.currentUser;
    final isAdmin = user != null && UserRoles.canAccessAdmin(user.role);

    // Build destinations based on role
    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(LucideIcons.home),
        label: Text('Dashboard'),
      ),
      const NavigationRailDestination(
        icon: Icon(LucideIcons.folderOpen),
        label: Text('Files'),
      ),
      if (isAdmin)
        const NavigationRailDestination(
          icon: Icon(LucideIcons.shieldCheck),
          label: Text('Admin'),
        ),
    ];

    int currentIndex = 0;
    if (location.startsWith('/files')) {
      currentIndex = 1;
    } else if (isAdmin && location.startsWith('/settings')) {
      currentIndex = 2;
    }
    if (currentIndex != _selectedIndex) {
      _selectedIndex = currentIndex;
    }

    // Non-admin trying to access /settings — redirect
    if (!isAdmin && location.startsWith('/settings')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/');
      });
    }

    // Session timer color — turns red when < 60 seconds
    final isUrgent = _remainingSeconds < 60 && _remainingSeconds > 0;
    final timerColor = isUrgent ? Colors.red : Theme.of(context).colorScheme.primary;

    // Wrap with Listener to detect mouse/keyboard activity for session reset
    return Listener(
      onPointerDown: (_) => resetSessionTimer(),
      onPointerMove: (_) => resetSessionTimer(),
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (_) => resetSessionTimer(),
        child: Scaffold(
          body: Row(
            children: [
              // Sidebar
              NavigationRail(
                selectedIndex: _selectedIndex.clamp(0, destinations.length - 1),
                onDestinationSelected: _onDestinationSelected,
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.flaskConical, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'IOT Lab',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Session countdown
                      if (_totalSeconds > 0)
                        Tooltip(
                          message: 'Session: $_formattedRemaining left of $_formattedTotal',
                          child: Column(
                            children: [
                              Icon(LucideIcons.timer, size: 14, color: timerColor),
                              const SizedBox(height: 2),
                              Text(
                                _formattedRemaining,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: timerColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                              ),
                              Text(
                                'of $_formattedTotal',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontSize: 8,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      // MQTT Status
                      ListenableBuilder(
                        listenable: _mqttService,
                        builder: (context, _) {
                          return Tooltip(
                            message: _mqttService.isConnected
                                ? 'MQTT Connected'
                                : 'MQTT Disconnected',
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: _mqttService.isConnected
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      // Dark mode toggle
                      IconButton(
                        icon: Icon(_isDark ? LucideIcons.sun : LucideIcons.moon,
                            size: 18),
                        onPressed: _toggleTheme,
                        tooltip: 'Toggle theme',
                      ),
                      const SizedBox(height: 4),
                      // Change Password
                      IconButton(
                        icon: const Icon(LucideIcons.keyRound, size: 18),
                        onPressed: () => ChangePasswordDialog.show(context),
                        tooltip: 'Change Password',
                      ),
                      const SizedBox(height: 4),
                      // Logout
                      IconButton(
                        icon: const Icon(LucideIcons.logOut, size: 18),
                        onPressed: () async {
                          _sessionTimer?.cancel();
                          await _authService.logout();
                          if (context.mounted) context.go('/login');
                        },
                        tooltip: 'Logout',
                      ),
                      const SizedBox(height: 8),
                      // User info with role
                      if (user != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                UserRoles.displayName(user.role),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 9,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                destinations: destinations,
              ),
              const VerticalDivider(width: 1),
              // Main content
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
