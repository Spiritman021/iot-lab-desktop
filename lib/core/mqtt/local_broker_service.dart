import 'dart:io';

/// Starts a bundled Mosquitto broker from the desktop app folder when present.
class LocalBrokerService {
  LocalBrokerService._();

  static final LocalBrokerService instance = LocalBrokerService._();

  Future<void> ensureStarted() async {
    if (!Platform.isWindows) return;

    final appDir = File(Platform.resolvedExecutable).parent.path;
    final mosquittoDir = '$appDir\\mosquitto';
    final mosquittoExe = '$mosquittoDir\\mosquitto.exe';
    final configPath = '$mosquittoDir\\mosquitto.conf';

    if (!File(mosquittoExe).existsSync() || !File(configPath).existsSync()) {
      return;
    }

    if (await _isPortOpen('127.0.0.1', 1883)) {
      return;
    }

    try {
      await Process.start(
        mosquittoExe,
        ['-c', configPath],
        workingDirectory: mosquittoDir,
        mode: ProcessStartMode.detached,
      );
    } catch (_) {
      return;
    }

    await _waitForPort('127.0.0.1', 1883);
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

  Future<void> _waitForPort(String host, int port) async {
    final deadline = DateTime.now().add(const Duration(seconds: 6));

    while (DateTime.now().isBefore(deadline)) {
      if (await _isPortOpen(host, port)) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }
}
