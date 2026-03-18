import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/auth_service.dart';
import '../../core/mqtt/mqtt_service.dart';

/// App scaffold with sidebar — replaces web app's PageLayout + AppSidebar
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

  @override
  void initState() {
    super.initState();
    _authService = AuthService.instance;
    _mqttService = MqttService.instance;

    // Initialize auth and MQTT
    _authService.init().then((_) {
      if (_authService.isAuthenticated) {
        _mqttService.loadSettings().then((_) => _mqttService.connect());
      }
    });

    _loadThemePreference();
  }

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
        context.go('/settings/admin');
        break;
    }
  }

  @override
  void dispose() {
    // Do NOT dispose _mqttService — it's a singleton shared across the app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    if (location.startsWith('/settings')) {
      currentIndex = 1;
    }
    if (currentIndex != _selectedIndex) {
      _selectedIndex = currentIndex;
    }

    final user = _authService.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
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
                  // Logout
                  IconButton(
                    icon: const Icon(LucideIcons.logOut, size: 18),
                    onPressed: () async {
                      await _authService.logout();
                      if (context.mounted) context.go('/login');
                    },
                    tooltip: 'Logout',
                  ),
                  const SizedBox(height: 8),
                  // User info
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
                        ],
                      ),
                    ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(LucideIcons.home),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.shieldCheck),
                label: Text('Admin'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          // Main content
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
