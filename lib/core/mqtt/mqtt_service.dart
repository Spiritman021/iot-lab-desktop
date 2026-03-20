import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mqtt_topics.dart';

/// Manages the MQTT connection, subscriptions, and message streaming.
/// Replaces the backend's mqttSocket.service.ts — connects directly to broker.
class MqttService extends ChangeNotifier {
  MqttService._();

  static MqttService? _instance;

  static MqttService get instance {
    _instance ??= MqttService._();
    return _instance!;
  }

  MqttServerClient? _client;
  bool _isConnected = false;
  String _brokerUrl = '127.0.0.1';
  int _brokerPort = 1883;
  String _statusMessage = 'Not connected';

  /// Topic → latest value map (replaces DeviceDataContext.deviceValues)
  final Map<String, String> deviceValues = {};

  /// DeviceId → last message timestamp (replaces DeviceDataContext.deviceStatus)
  final Map<String, int> deviceStatus = {};

  /// Stream controller for MQTT messages
  final StreamController<MqttMessage> _messageController =
      StreamController<MqttMessage>.broadcast();

  Stream<MqttMessage> get messageStream => _messageController.stream;

  bool get isConnected => _isConnected;
  String get brokerUrl => _brokerUrl;
  int get brokerPort => _brokerPort;
  String get statusMessage => _statusMessage;

  /// Load saved MQTT settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _brokerUrl = prefs.getString('mqtt_broker_url') ?? '127.0.0.1';
    _brokerPort = prefs.getInt('mqtt_broker_port') ?? 1883;
    notifyListeners();
  }

  /// Save MQTT settings to SharedPreferences
  Future<void> saveSettings(String url, int port) async {
    _brokerUrl = url;
    _brokerPort = port;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqtt_broker_url', url);
    await prefs.setInt('mqtt_broker_port', port);
    notifyListeners();
  }

  /// Connect to the MQTT broker
  Future<bool> connect({String? brokerUrl, int? port}) async {
    // Disconnect existing connection if any
    if (_client != null) {
      _client!.autoReconnect = false;
      _client!.disconnect();
      _client = null;
    }

    if (brokerUrl != null) _brokerUrl = brokerUrl;
    if (port != null) _brokerPort = port;

    _statusMessage = 'Connecting to $_brokerUrl:$_brokerPort...';
    notifyListeners();

    final clientId = 'iot_lab_flutter_${DateTime.now().millisecondsSinceEpoch}';
    _client = MqttServerClient(_brokerUrl, clientId);
    _client!.port = _brokerPort;
    _client!.keepAlivePeriod = 60;
    _client!.autoReconnect = true;
    _client!.connectTimeoutPeriod = 5000;
    _client!.logging(on: false);

    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onAutoReconnected = _onAutoReconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
      return _isConnected;
    } catch (e) {
      debugPrint('MQTT connection error: $e');
      _isConnected = false;
      _statusMessage = 'Connection failed: ${e.toString().split(':').last.trim()}';
      notifyListeners();
      return false;
    }
  }

  void _onConnected() {
    _isConnected = true;
    _statusMessage = 'Connected to $_brokerUrl:$_brokerPort';
    debugPrint('MQTT Connected to $_brokerUrl:$_brokerPort');
    notifyListeners();
    _subscribeToTopics();
    _listenToMessages();
  }

  void _onDisconnected() {
    _isConnected = false;
    _statusMessage = 'Disconnected';
    debugPrint('MQTT Disconnected');
    notifyListeners();
  }

  void _onAutoReconnected() {
    _isConnected = true;
    _statusMessage = 'Reconnected to $_brokerUrl:$_brokerPort';
    debugPrint('MQTT Auto-reconnected');
    notifyListeners();
  }

  void _subscribeToTopics() {
    for (final topic in MqttTopics.subscriptions) {
      _client!.subscribe(topic, MqttQos.atLeastOnce);
    }
  }

  void _listenToMessages() {
    _client!.updates?.listen((c) {
      final messages = c;
      for (final message in messages) {
        final topic = message.topic;
        final payload = MqttPublishPayload.bytesToStringAsString(
            (message.payload as MqttPublishMessage).payload.message);

        // Parse device ID from topic (e.g., "/EPT001/PH_VAL" → "EPT001")
        final splitTopic = topic.split('/');
        final deviceId = splitTopic.length > 1 ? splitTopic[1] : '';

        // Only true device heartbeat/telemetry topics should mark a device online.
        if (deviceId.isNotEmpty && _isPresenceTopic(topic)) {
          deviceStatus[deviceId] = DateTime.now().millisecondsSinceEpoch;
        }

        // Store value in map (matching web frontend's DeviceDataContext logic)
        if (topic.endsWith('/LOG_DATA')) {
          deviceValues[topic] =
              DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          // Format numeric values to 2 decimal places (matching backend logic)
          final numVal = double.tryParse(payload);
          deviceValues[topic] =
              numVal != null ? numVal.toStringAsFixed(2) : payload;
        }

        // Clear CAL_LOG after 50ms (matching web frontend behavior)
        if (topic.endsWith('/CAL_LOG')) {
          Future.delayed(const Duration(milliseconds: 50), () {
            deviceValues[topic] = '';
            notifyListeners();
          });
        }

        // Handle RESET (matching backend logic)
        if (topic.endsWith('/RESET') && payload == '1') {
          // Reset is handled by the UI layer
        }

        _messageController.add(MqttMessage(
          topic: topic,
          payload: payload,
          deviceId: deviceId,
        ));

        notifyListeners();
      }
    });
  }

  /// Publish a message to MQTT (replaces client-server-device socket event)
  void publishToDevice(String topic, String payload) {
    if (_client == null || !_isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  bool _isPresenceTopic(String topic) {
    const presenceSuffixes = {
      '/STATUS',
      '/PH_VAL',
      '/TEMP_VAL',
      '/MV_VAL',
      '/BATTERY',
      '/SLOPE',
      '/OFFSET',
      '/A0',
      '/A1',
      '/VOLTAGE',
    };

    return presenceSuffixes.any(topic.endsWith);
  }

  /// Disconnect from broker
  void disconnect() {
    if (_client != null) {
      _client!.autoReconnect = false;
      _client!.disconnect();
      _client = null;
    }
    _isConnected = false;
    _statusMessage = 'Disconnected';
    notifyListeners();
  }

  @override
  void dispose() {
    _messageController.close();
    disconnect();
    super.dispose();
  }
}

/// Simple MQTT message data class
class MqttMessage {
  final String topic;
  final String payload;
  final String deviceId;

  MqttMessage({
    required this.topic,
    required this.payload,
    required this.deviceId,
  });
}
