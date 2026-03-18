import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/mqtt/mqtt_service.dart';
import 'audit_logs_screen.dart';
import 'company_details_screen.dart';
import 'manage_devices_screen.dart';
import 'manage_header_footer_screen.dart';
import 'manage_users_screen.dart';

/// Admin Settings screen — requires password re-authentication.
/// After auth, shows tabs: MQTT | Devices | Users | Setup
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _authenticated = false;

  @override
  Widget build(BuildContext context) {
    if (!_authenticated) {
      return _PasswordGate(
        onAuthenticated: () => setState(() => _authenticated = true),
      );
    }
    return const _AdminTabbedBody();
  }
}

// ─── Password Gate ───────────────────────────────────────────────────────────

class _PasswordGate extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const _PasswordGate({required this.onAuthenticated});

  @override
  State<_PasswordGate> createState() => _PasswordGateState();
}

class _PasswordGateState extends State<_PasswordGate> {
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  Future<void> _verify() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _error = 'Password is required');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'No user logged in';
          _loading = false;
        });
        return;
      }

      final isCorrect = BCrypt.checkpw(password, user.passwordHash);
      if (isCorrect) {
        await AuditService.instance.log(
          category: AuditService.catAuth,
          action: 'reauth_admin',
          entityType: 'user',
          entityId: user.id.toString(),
        );
        widget.onAuthenticated();
      } else {
        await AuditService.instance.log(
          category: AuditService.catAuth,
          action: 'reauth_admin',
          entityType: 'user',
          entityId: user.id.toString(),
          status: 'failed',
          details: {'reason': 'Incorrect password'},
        );
        setState(() {
          _error = 'Incorrect password';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Verification failed: ${e.toString()}';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.shieldCheck,
                      size: 32, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Admin Authentication',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your password to access admin settings',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (user != null)
                  Chip(
                    avatar: CircleAvatar(
                      child: Text(user.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                    ),
                    label: Text('${user.name} (${user.role})'),
                  ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  autofocus: true,
                  onSubmitted: (_) => _verify(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(LucideIcons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure ? LucideIcons.eyeOff : LucideIcons.eye),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    errorText: _error,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _verify,
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(LucideIcons.logIn, size: 16),
                    label: const Text('Verify & Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Admin Tabbed Body (MQTT | Devices | Users | Setup) ─────────────────────

class _AdminTabbedBody extends StatefulWidget {
  const _AdminTabbedBody();

  @override
  State<_AdminTabbedBody> createState() => _AdminTabbedBodyState();
}

class _AdminTabbedBodyState extends State<_AdminTabbedBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header + TabBar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.settings, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Admin Settings',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(
                    icon: Icon(LucideIcons.radio, size: 16),
                    text: 'MQTT',
                  ),
                  Tab(
                    icon: Icon(LucideIcons.settings2, size: 16),
                    text: 'Devices',
                  ),
                  Tab(
                    icon: Icon(LucideIcons.users, size: 16),
                    text: 'Users',
                  ),
                  Tab(
                    icon: Icon(LucideIcons.clipboardList, size: 16),
                    text: 'Audit',
                  ),
                  Tab(
                    icon: Icon(LucideIcons.fileText, size: 16),
                    text: 'Setup',
                  ),
                  Tab(
                    icon: Icon(LucideIcons.building2, size: 16),
                    text: 'Company',
                  ),
                ],
              ),
            ],
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
                children: const [
                  _MqttSettingsTab(),
                  ManageDevicesScreen(),
                  ManageUsersScreen(),
                  AuditLogsScreen(),
                  ManageHeaderFooterScreen(),
                  CompanyDetailsScreen(),
                ],
          ),
        ),
      ],
    );
  }
}

// ─── MQTT Settings Tab (extracted from old _AdminSettingsBody) ───────────────

class _MqttSettingsTab extends StatefulWidget {
  const _MqttSettingsTab();

  @override
  State<_MqttSettingsTab> createState() => _MqttSettingsTabState();
}

class _MqttSettingsTabState extends State<_MqttSettingsTab> {
  final _mqttService = MqttService.instance;
  late final TextEditingController _urlController;
  late final TextEditingController _portController;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _mqttService.brokerUrl);
    _portController =
        TextEditingController(text: _mqttService.brokerPort.toString());
  }

  Future<void> _connectMqtt() async {
    final url = _urlController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 1883;

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Broker URL cannot be empty'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _connecting = true);

    // Save settings first
    await _mqttService.saveSettings(url, port);

    // Then connect
    final success = await _mqttService.connect(brokerUrl: url, port: port);

    if (mounted) {
      setState(() => _connecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? 'Connected to $url:$port' : 'Failed to connect'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _disconnectMqtt() {
    _mqttService.disconnect();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Disconnected from MQTT broker'),
            backgroundColor: Colors.orange),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MQTT Configuration Card
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Icon(LucideIcons.radio,
                          size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'MQTT Broker Configuration',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configure the MQTT broker connection for real-time device communication.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Connection Status
                  ListenableBuilder(
                    listenable: _mqttService,
                    builder: (context, _) {
                      final connected = _mqttService.isConnected;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: connected
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: connected
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: connected ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    connected ? 'Connected' : 'Disconnected',
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: connected
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                  Text(
                                    _mqttService.statusMessage,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // URL and Port Fields
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Broker URL
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _urlController,
                          decoration: const InputDecoration(
                            labelText: 'Broker URL / IP',
                            hintText: '127.0.0.1',
                            prefixIcon: Icon(LucideIcons.globe),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Port
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _portController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Port',
                            hintText: '1883',
                            prefixIcon: Icon(LucideIcons.hash),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  ListenableBuilder(
                    listenable: _mqttService,
                    builder: (context, _) {
                      final connected = _mqttService.isConnected;
                      return Row(
                        children: [
                          FilledButton.icon(
                            onPressed: _connecting
                                ? null
                                : connected
                                    ? null
                                    : _connectMqtt,
                            icon: _connecting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Icon(LucideIcons.plug, size: 16),
                            label: Text(
                                _connecting ? 'Connecting...' : 'Connect'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: connected ? _disconnectMqtt : null,
                            icon:
                                const Icon(LucideIcons.plugZap, size: 16),
                            label: const Text('Disconnect'),
                          ),
                          const SizedBox(width: 12),
                          // Reconnect shortcut
                          if (connected)
                            TextButton.icon(
                              onPressed: _connecting
                                  ? null
                                  : () async {
                                      _disconnectMqtt();
                                      await Future.delayed(
                                          const Duration(milliseconds: 500));
                                      _connectMqtt();
                                    },
                              icon: const Icon(LucideIcons.refreshCw,
                                  size: 16),
                              label: const Text('Reconnect'),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
