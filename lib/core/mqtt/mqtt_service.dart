import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'mqtt_topics.dart';

/// Manages the MQTT connection, subscriptions, and message streaming.
/// Replaces the backend's mqttSocket.service.ts — connects directly to broker.
class MqttService extends ChangeNotifier {
  MqttServerClient? _client;
  bool _isConnected = false;
  String _brokerUrl = '127.0.0.1';
  int _brokerPort = 1883;

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

  /// Connect to the MQTT broker
  Future<bool> connect({String? brokerUrl, int? port}) async {
    if (brokerUrl != null) _brokerUrl = brokerUrl;
    if (port != null) _brokerPort = port;

    _client = MqttServerClient(_brokerUrl, 'iot_lab_flutter_${DateTime.now().millisecondsSinceEpoch}');
    _client!.port = _brokerPort;
    _client!.keepAlivePeriod = 60;
    _client!.autoReconnect = true;
    _client!.logging(on: false);

    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onAutoReconnected = _onAutoReconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('iot_lab_flutter_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
      return _isConnected;
    } catch (e) {
      debugPrint('MQTT connection error: $e');
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  void _onConnected() {
    _isConnected = true;
    debugPrint('MQTT Connected to $_brokerUrl:$_brokerPort');
    notifyListeners();
    _subscribeToTopics();
    _listenToMessages();
  }

  void _onDisconnected() {
    _isConnected = false;
    debugPrint('MQTT Disconnected');
    notifyListeners();
  }

  void _onAutoReconnected() {
    _isConnected = true;
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

        // Update device status (last seen timestamp)
        if (deviceId.isNotEmpty) {
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

  /// Disconnect from broker
  void disconnect() {
    _client?.disconnect();
    _isConnected = false;
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
