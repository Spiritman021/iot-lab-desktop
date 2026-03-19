import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/mqtt/local_broker_service.dart';
import '../../core/mqtt/mqtt_service.dart';
import 'audit_logs_screen.dart';
import 'company_details_screen.dart';
import 'manage_devices_screen.dart';
import 'manage_users_screen.dart';

/// Admin Settings screen — requires password re-authentication.
/// After auth, shows tabs: MQTT | Devices | Users | Audit | Company
class AdminSettingsScreen extends StatefulWidget {
  final int initialTab;

  const AdminSettingsScreen({
    super.key,
    this.initialTab = 0,
  });

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
    return _AdminTabbedBody(initialTab: widget.initialTab);
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

// ─── Admin Tabbed Body (MQTT | Devices | Users | Audit | Company) ───────────

class _AdminTabbedBody extends StatefulWidget {
  final int initialTab;

  const _AdminTabbedBody({required this.initialTab});

  @override
  State<_AdminTabbedBody> createState() => _AdminTabbedBodyState();
}

class _AdminTabbedBodyState extends State<_AdminTabbedBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 4),
    );
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
  final _brokerService = LocalBrokerService.instance;
  late final TextEditingController _urlController;
  late final TextEditingController _portController;
  late final TextEditingController _exePathController;
  late final TextEditingController _configPathController;
  bool _connecting = false;
  bool _managingBroker = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _mqttService.brokerUrl);
    _portController =
        TextEditingController(text: _mqttService.brokerPort.toString());
    _exePathController = TextEditingController();
    _configPathController = TextEditingController();
    _initializeBrokerControls();
  }

  Future<void> _initializeBrokerControls() async {
    await _brokerService.init();
    if (!mounted) return;
    _exePathController.text = _brokerService.exePath;
    _configPathController.text = _brokerService.configPath;
    setState(() {});
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

  Future<void> _saveBrokerPaths() async {
    await _brokerService.savePaths(
      exePath: _exePathController.text,
      configPath: _configPathController.text,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Local broker paths saved'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _resetBrokerPaths() async {
    await _brokerService.resetPathsToDefault();
    if (!mounted) return;
    _exePathController.text = _brokerService.exePath;
    _configPathController.text = _brokerService.configPath;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broker paths reset to default'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _startLocalBroker() async {
    setState(() => _managingBroker = true);
    await _saveBrokerPaths();
    final started = await _brokerService.startBroker();
    if (!mounted) return;
    setState(() => _managingBroker = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          started
              ? 'Local broker is available'
              : 'Failed to start local broker',
        ),
        backgroundColor: started ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _restartLocalBroker() async {
    setState(() => _managingBroker = true);
    await _saveBrokerPaths();
    final restarted = await _brokerService.restartBroker();
    if (!mounted) return;
    setState(() => _managingBroker = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          restarted
              ? 'Local broker restarted'
              : 'Failed to restart local broker',
        ),
        backgroundColor: restarted ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _portController.dispose();
    _exePathController.dispose();
    _configPathController.dispose();
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

                  // Local Broker Status
                  ListenableBuilder(
                    listenable: _brokerService,
                    builder: (context, _) {
                      final brokerRunning = _brokerService.isManagedProcessRunning;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: brokerRunning
                              ? Colors.blue.withValues(alpha: 0.1)
                              : theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: brokerRunning
                                ? Colors.blue.withValues(alpha: 0.3)
                                : theme.colorScheme.outline.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              brokerRunning
                                  ? LucideIcons.serverCog
                                  : LucideIcons.serverCrash,
                              size: 18,
                              color: brokerRunning
                                  ? Colors.blue.shade700
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    brokerRunning
                                        ? 'Local broker managed by app'
                                        : 'Local broker not managed',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _brokerService.statusMessage,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (_brokerService.pid != null)
                                    Text(
                                      'PID: ${_brokerService.pid}',
                                      style: theme.textTheme.bodySmall?.copyWith(
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

                  Text(
                    'Local Mosquitto Files',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Edit these paths to point to the Mosquitto executable and config file shipped with your desktop app.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _exePathController,
                    decoration: const InputDecoration(
                      labelText: 'Mosquitto Executable Path',
                      hintText: r'C:\...\mosquitto\mosquitto.exe',
                      prefixIcon: Icon(LucideIcons.folderSearch),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _configPathController,
                    decoration: const InputDecoration(
                      labelText: 'Mosquitto Config Path',
                      hintText: r'C:\...\mosquitto\mosquitto.conf',
                      prefixIcon: Icon(LucideIcons.fileCog),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _saveBrokerPaths,
                        icon: const Icon(LucideIcons.save, size: 16),
                        label: const Text('Save Paths'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _resetBrokerPaths,
                        icon: const Icon(LucideIcons.rotateCcw, size: 16),
                        label: const Text('Use Default Paths'),
                      ),
                      FilledButton.icon(
                        onPressed:
                            _managingBroker ? null : _startLocalBroker,
                        icon: _managingBroker
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(LucideIcons.play, size: 16),
                        label: Text(
                          _managingBroker ? 'Starting...' : 'Start Local Broker',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed:
                            _managingBroker ? null : _restartLocalBroker,
                        icon: const Icon(LucideIcons.refreshCw, size: 16),
                        label: const Text('Restart Broker'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Text(
                        'Broker Terminal',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _brokerService.clearLogs,
                        icon: const Icon(LucideIcons.trash2, size: 16),
                        label: const Text('Clear Logs'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListenableBuilder(
                    listenable: _brokerService,
                    builder: (context, _) {
                      final logs = _brokerService.logs;
                      return Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1720),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF243140),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            logs.isEmpty
                                ? 'No broker logs yet. Startup attempts, stdout, stderr, and process exits will appear here.'
                                : logs.join('\n'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFFE5EEF8),
                              fontFamily: 'monospace',
                              height: 1.4,
                            ),
                          ),
                        ),
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
