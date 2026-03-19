import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/auth/auth_service.dart';

/// Login screen — if no admin exists, redirects to /register for first-time setup.
/// After admin exists, the register link is hidden — users are created inside the app.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService.instance;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final exists = await _authService.adminExists();
    if (!exists && mounted) {
      // No admin yet — redirect to first-time setup
      context.go('/register');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/');
    } on PasswordExpiredException {
      await _authService.logout();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Password expired. Please contact an admin to reset your password.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background1.png',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.72),
                  Colors.white.withValues(alpha: 0.44),
                  Colors.white.withValues(alpha: 0.18),
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 900;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 20 : 48,
                    vertical: isCompact ? 24 : 36,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (isCompact ? 48 : 72),
                    ),
                    child: Row(
                      children: [
                        if (!isCompact)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 24, 48, 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 18),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.66),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.78),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 28,
                                          offset: const Offset(0, 16),
                                        ),
                                      ],
                                    ),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 560),
                                      child: Image.asset(
                                        'assets/crescent.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    'Smart laboratory monitoring for reliable calibration, logging, and reporting.',
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF193E32),
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 520),
                                    child: Text(
                                      'Secure access for regulated lab operations with audit-ready records and device workflows.',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: const Color(0xFF345B4D),
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(
                          flex: isCompact ? 0 : 0,
                          child: Align(
                            alignment: isCompact
                                ? Alignment.center
                                : Alignment.centerRight,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 430),
                              child: Card(
                                elevation: 0,
                                color: Colors.white.withValues(alpha: 0.82),
                                shadowColor: Colors.black.withValues(alpha: 0.18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF2F6A4E),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/tlc_logo.png',
                                                  width: 26,
                                                  height: 26,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Crescent Lab',
                                                    style: theme
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          const Color(0xFF1F3C32),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Login to your account',
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 28),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            hintText: 'Enter your email',
                                            filled: true,
                                            fillColor: Colors.white
                                                .withValues(alpha: 0.72),
                                            prefixIcon: const Icon(
                                                LucideIcons.mail, size: 18),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (val) {
                                            if (val == null ||
                                                val.trim().isEmpty) {
                                              return 'Email is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            hintText: 'Enter your password',
                                            filled: true,
                                            fillColor: Colors.white
                                                .withValues(alpha: 0.72),
                                            prefixIcon: const Icon(
                                                LucideIcons.lock, size: 18),
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscurePassword
                                                  ? LucideIcons.eyeOff
                                                  : LucideIcons.eye),
                                              onPressed: () => setState(() =>
                                                  _obscurePassword =
                                                      !_obscurePassword),
                                            ),
                                          ),
                                          obscureText: _obscurePassword,
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return 'Password is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2F6A4E),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          onPressed:
                                              _loading ? null : _handleLogin,
                                          child: _loading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text('Login'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
