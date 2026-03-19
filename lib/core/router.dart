import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/files/file_manager_screen.dart';
import '../features/homepage/homepage_screen.dart';
import '../features/layout/app_scaffold.dart';
import '../features/settings/admin_settings_screen.dart';
import '../core/auth/auth_service.dart';

/// App router — matching the web app's AppRoutes.tsx
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authService,
    redirect: (context, state) {
      final isLoggedIn = authService.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // App routes (with sidebar layout)
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomepageScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const HomepageScreen(),
          ),
          GoRoute(
            path: '/dashboard/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return DashboardScreen(deviceId: id);
            },
          ),
          GoRoute(
            path: '/settings/admin',
            builder: (context, state) => AdminSettingsScreen(
              initialTab: switch (state.uri.queryParameters['tab']) {
                'devices' => 1,
                'users' => 2,
                'audit' => 3,
                'company' => 4,
                _ => 0,
              },
            ),
          ),
          GoRoute(
            path: '/files',
            builder: (context, state) => const FileManagerScreen(),
          ),
        ],
      ),
    ],
  );
}
