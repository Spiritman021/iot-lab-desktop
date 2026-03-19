import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages a bundled local Mosquitto broker for the Windows desktop app.
class LocalBrokerService extends ChangeNotifier {
  LocalBrokerService._();

  static final LocalBrokerService instance = LocalBrokerService._();

  static const _exePathKey = 'mosquitto_exe_path';
  static const _configPathKey = 'mosquitto_config_path';

  bool _initialized = false;
  bool _starting = false;
  bool _managedProcessRunning = false;
  String _statusMessage = 'Local broker not initialized';
  String _exePath = '';
  String _configPath = '';
  int? _pid;
  Process? _process;
  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<String>? _stderrSubscription;
  StreamSubscription<int>? _exitSubscription;
  final List<String> _logs = [];
  final DateFormat _timestampFormat = DateFormat('HH:mm:ss');

  bool get isStarting => _starting;
  bool get isManagedProcessRunning => _managedProcessRunning;
  bool get isWindowsSupported => Platform.isWindows;
  String get statusMessage => _statusMessage;
  String get exePath => _exePath;
  String get configPath => _configPath;
  int? get pid => _pid;
  List<String> get logs => List.unmodifiable(_logs);
  String get defaultExePath => _buildDefaultExePath();
  String get defaultConfigPath => _buildDefaultConfigPath();

  Future<void> init() async {
    if (_initialized) return;

    _exePath = defaultExePath;
    _configPath = defaultConfigPath;
    _statusMessage = Platform.isWindows
        ? 'Ready to manage local Mosquitto broker'
        : 'Local broker control is supported on Windows desktop only';

    final prefs = await SharedPreferences.getInstance();
    _exePath = prefs.getString(_exePathKey) ?? _exePath;
    _configPath = prefs.getString(_configPathKey) ?? _configPath;

    _initialized = true;
    _addLog('Local broker service initialized.');
    notifyListeners();
  }

  Future<void> savePaths({
    required String exePath,
    required String configPath,
  }) async {
    await init();

    _exePath = exePath.trim().isEmpty ? defaultExePath : exePath.trim();
    _configPath =
        configPath.trim().isEmpty ? defaultConfigPath : configPath.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_exePathKey, _exePath);
    await prefs.setString(_configPathKey, _configPath);

    _addLog('Broker paths updated.');
    notifyListeners();
  }

  Future<void> resetPathsToDefault() async {
    await savePaths(
      exePath: defaultExePath,
      configPath: defaultConfigPath,
    );
    _addLog('Broker paths reset to defaults.');
  }

  Future<bool> ensureStarted() async {
    await init();
    return startBroker();
  }

  Future<bool> startBroker() async {
    await init();

    if (!Platform.isWindows) {
      _statusMessage = 'Local broker control is supported on Windows desktop only';
      _addLog(_statusMessage, isError: true);
      notifyListeners();
      return false;
    }

    if (_starting) {
      _addLog('Start skipped because broker is already starting.');
      return false;
    }

    if (_managedProcessRunning && _process != null) {
      _addLog('Start skipped because managed Mosquitto is already running.');
      return true;
    }

    if (!File(_exePath).existsSync()) {
      _statusMessage = 'Mosquitto executable not found';
      _addLog('Executable not found: $_exePath', isError: true);
      notifyListeners();
      return false;
    }

    if (!File(_configPath).existsSync()) {
      _statusMessage = 'Mosquitto config not found';
      _addLog('Config not found: $_configPath', isError: true);
      notifyListeners();
      return false;
    }

    if (await _isPortOpen('127.0.0.1', 1883)) {
      _statusMessage = 'Broker already available on 127.0.0.1:1883';
      _addLog('Port 1883 is already open. Using existing broker.');
      notifyListeners();
      return true;
    }

    _starting = true;
    _statusMessage = 'Starting local Mosquitto broker...';
    _addLog('Starting broker: "$_exePath" -c "$_configPath"');
    notifyListeners();

    try {
      final process = await Process.start(
        _exePath,
        ['-c', _configPath],
        workingDirectory: File(_exePath).parent.path,
        runInShell: false,
      );

      _process = process;
      _pid = process.pid;
      _managedProcessRunning = true;
      _attachProcessStreams(process);
      _addLog('Mosquitto process started with PID $_pid.');

      final ready = await _waitForPort('127.0.0.1', 1883);
      _statusMessage = ready
          ? 'Local broker running on 127.0.0.1:1883'
          : 'Broker started but port 1883 did not become ready';
      if (!ready) {
        _addLog(
          'Broker process started, but port 1883 did not open within timeout.',
          isError: true,
        );
      }
      notifyListeners();
      return ready;
    } catch (e) {
      _statusMessage = 'Failed to start local broker';
      _managedProcessRunning = false;
      _process = null;
      _pid = null;
      _addLog('Start failed: $e', isError: true);
      notifyListeners();
      return false;
    } finally {
      _starting = false;
      notifyListeners();
    }
  }

  Future<bool> restartBroker() async {
    await init();
    _addLog('Broker restart requested.');
    await stopBroker();
    return startBroker();
  }

  Future<void> stopBroker() async {
    await init();

    if (_process == null) {
      _managedProcessRunning = false;
      _pid = null;
      _addLog('Stop skipped because no managed broker process is running.');
      notifyListeners();
      return;
    }

    final pid = _pid;
    _addLog('Stopping managed broker process${pid != null ? ' PID $pid' : ''}.');

    try {
      _process!.kill();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _addLog('Stop failed: $e', isError: true);
    }
  }

  void clearLogs() {
    _logs.clear();
    _addLog('Broker terminal log cleared.');
    notifyListeners();
  }

  void _attachProcessStreams(Process process) {
    _stdoutSubscription?.cancel();
    _stderrSubscription?.cancel();
    _exitSubscription?.cancel();

    _stdoutSubscription = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      _addLog('[stdout] $line');
      notifyListeners();
    });

    _stderrSubscription = process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      _addLog('[stderr] $line', isError: true);
      notifyListeners();
    });

    _exitSubscription = process.exitCode.asStream().listen((code) {
      _addLog('Mosquitto process exited with code $code.');
      _managedProcessRunning = false;
      _process = null;
      _pid = null;
      _statusMessage = code == 0
          ? 'Local broker stopped'
          : 'Local broker exited with code $code';
      notifyListeners();
    });
  }

  Future<bool> _isPortOpen(String host, int port) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(milliseconds: 700),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _waitForPort(String host, int port) async {
    final deadline = DateTime.now().add(const Duration(seconds: 6));

    while (DateTime.now().isBefore(deadline)) {
      if (await _isPortOpen(host, port)) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }

    return false;
  }

  void _addLog(String message, {bool isError = false}) {
    final prefix = isError ? 'ERROR' : 'INFO';
    _logs.add('[${_timestampFormat.format(DateTime.now())}] $prefix  $message');
    if (_logs.length > 300) {
      _logs.removeRange(0, _logs.length - 300);
    }
  }

  String _buildDefaultExePath() {
    if (!Platform.isWindows) return '';
    final appDir = File(Platform.resolvedExecutable).parent.path;
    return '$appDir\\mosquitto\\mosquitto.exe';
  }

  String _buildDefaultConfigPath() {
    if (!Platform.isWindows) return '';
    final appDir = File(Platform.resolvedExecutable).parent.path;
    return '$appDir\\mosquitto\\mosquitto.conf';
  }
}
