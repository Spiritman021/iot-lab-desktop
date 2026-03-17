import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/auth/auth_service.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IoTLabApp());
}

class IoTLabApp extends StatefulWidget {
  const IoTLabApp({super.key});

  @override
  State<IoTLabApp> createState() => _IoTLabAppState();
}

class _IoTLabAppState extends State<IoTLabApp> {
  final AuthService _authService = AuthService.instance;
  bool _isDark = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _authService.init();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final router = createRouter(_authService);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'IOT Lab',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
