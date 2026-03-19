import 'package:flutter/material.dart';

import 'core/auth/auth_service.dart';
import 'core/mqtt/local_broker_service.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'core/theme_mode_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalBrokerService.instance.ensureStarted();
  runApp(const IoTLabApp());
}

class IoTLabApp extends StatefulWidget {
  const IoTLabApp({super.key});

  @override
  State<IoTLabApp> createState() => _IoTLabAppState();
}

class _IoTLabAppState extends State<IoTLabApp> {
  final AuthService _authService = AuthService.instance;
  final ThemeModeController _themeModeController = ThemeModeController.instance;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _authService.init();
    await _themeModeController.init();
    setState(() {
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

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Crescent Lab',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
