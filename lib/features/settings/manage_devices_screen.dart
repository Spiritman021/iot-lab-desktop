import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/audit/audit_service.dart';
import '../../core/constants.dart';
import '../../core/database/app_database.dart';
import '../../core/mqtt/mqtt_service.dart';

/// Manage Devices screen — matches web app's ManageDevices.tsx
class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  State<ManageDevicesScreen> createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  final AppDatabase _db = AppDatabase.instance;
  List<Device> _devices = [];
  int _totalCount = 0;
  int _page = 1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _loading = true);
    try {
      final devices = await _db.getDevices(page: _page, limit: paginationLimit);
      final count = await _db.getDeviceCount();
      if (mounted) {
        setState(() {
          _devices = devices;
          _totalCount = count;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _totalPages => (_totalCount / paginationLimit).ceil().clamp(1, 999);

  void _showCreateDeviceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _CreateDeviceDialog(onCreated: _loadDevices),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header  
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manage Devices',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                onPressed: _showCreateDeviceDialog,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Create'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('#')),
                                DataColumn(label: Text('Device ID')),
                                DataColumn(label: Text('Device Type')),
                                DataColumn(label: Text('Mode')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _devices.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final device = entry.value;
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${(_page - 1) * paginationLimit + idx + 1}')),
                                  DataCell(Text(device.deviceId)),
                                  DataCell(Text(device.type.toUpperCase())),
                                  DataCell(Text('Mode ${device.mode}')),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(LucideIcons.pencil,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        tooltip: 'Edit',
                                        onPressed: () =>
                                            _showEditDeviceDialog(device),
                                      ),
                                      IconButton(
                                        icon: Icon(LucideIcons.trash2,
                                            size: 16,
                                            color: Colors.red.shade600),
                                        tooltip: 'Delete',
                                        onPressed: () =>
                                            _confirmDeleteDevice(device),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      // Pagination
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Page: $_page of $_totalPages',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Rows: ${(_page - 1) * paginationLimit + 1} - ${((_page - 1) * paginationLimit + _devices.length).clamp(0, _totalCount)} of $_totalCount',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronsLeft,
                                      size: 16),
                                  onPressed: _page > 1
                                      ? () {
                                          setState(() => _page = 1);
                                          _loadDevices();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronLeft,
                                      size: 16),
                                  onPressed: _page > 1
                                      ? () {
                                          setState(() => _page--);
                                          _loadDevices();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(() => _page++);
                                          _loadDevices();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronsRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(() => _page = _totalPages);
                                          _loadDevices();
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditDeviceDialog(Device device) {
    showDialog(
      context: context,
      builder: (ctx) => _EditDeviceDialog(
        device: device,
        onUpdated: _loadDevices,
      ),
    );
  }

  Future<void> _confirmDeleteDevice(Device device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Device'),
        content: Text(
            'Are you sure you want to delete "${device.deviceId}"? This will also delete all calibration data and logs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Delete config and calibration rows first
        final config = await _db.getConfigForDevice(device.id);
        if (config != null) {
          await _db.deleteCalibrationRowsForConfig(config.id);
        }
        // Delete logs
        await _db.deleteLogsForDevice(device.id);
        // Delete device (cascades to config via foreign key)
        await _db.deleteDevice(device.id);
        await AuditService.instance.log(
          category: AuditService.catDevice,
          action: 'delete',
          entityType: 'device',
          entityId: device.id.toString(),
          details: {'deviceId': device.deviceId, 'type': device.type},
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Device deleted'),
                backgroundColor: Colors.green),
          );
          _loadDevices();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}

/// Edit Device dialog — allows changing the calibration mode
class _EditDeviceDialog extends StatefulWidget {
  final Device device;
  final VoidCallback onUpdated;

  const _EditDeviceDialog({required this.device, required this.onUpdated});

  @override
  State<_EditDeviceDialog> createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<_EditDeviceDialog> {
  final AppDatabase _db = AppDatabase.instance;
  late String _selectedMode;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.device.mode;
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);

    try {
      // Update device mode
      await _db.updateDevice(
        widget.device.id,
        DevicesCompanion(mode: Value(_selectedMode)),
      );

      // Update config + calibration rows if mode changed
      if (_selectedMode != widget.device.mode) {
        final config = await _db.getConfigForDevice(widget.device.id);
        if (config != null) {
          // Delete old calibration rows
          await _db.deleteCalibrationRowsForConfig(config.id);
          // Update config mode
          await _db.updateDeviceConfig(
            config.id,
            DeviceConfigsCompanion(mode: Value(_selectedMode)),
          );
          // Insert new default calibration rows
          final CalibrationConfig defaultConfig;
          if (widget.device.type == 'ec') {
            defaultConfig = _selectedMode == '1'
                ? ecConfig1
                : _selectedMode == '2'
                    ? ecConfig2
                    : ecConfig3;
          } else {
            defaultConfig =
                _selectedMode == '3' ? phConfig3 : phConfig5;
          }
          for (final val in defaultConfig.values) {
            await _db.insertCalibrationRow(CalibrationRowsCompanion.insert(
              configId: config.id,
              val: val,
            ));
          }
        }
      }
      await AuditService.instance.log(
        category: AuditService.catDevice,
        action: 'update',
        entityType: 'device',
        entityId: widget.device.id.toString(),
        details: {
          'deviceId': widget.device.deviceId,
          'oldMode': widget.device.mode,
          'newMode': _selectedMode,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Device updated'),
              backgroundColor: Colors.green),
        );
        widget.onUpdated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPh = widget.device.type == 'ph';

    return AlertDialog(
      title: Text('Edit Device: ${widget.device.deviceId}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Read-only device info
          Text('Device Type: ${widget.device.type.toUpperCase()}',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 16),

          // Calibration Mode selector
          DropdownButtonFormField<String>(
            initialValue: _selectedMode,
            decoration: const InputDecoration(labelText: 'Calibration Mode'),
            items: (isPh ? ['3', '5'] : ['1', '2', '3'])
                .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text('Mode $m'),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedMode = val);
            },
          ),

          const SizedBox(height: 8),
          if (_selectedMode != widget.device.mode)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertTriangle,
                      size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Changing mode will reset calibration data',
                      style: TextStyle(
                          fontSize: 12, color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _handleSave,
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(LucideIcons.save, size: 16),
          label: const Text('Save'),
        ),
      ],
    );
  }
}


/// Create Device dialog — matches web app's CreateDeviceModal
/// Listens to /METER/ID MQTT topic to auto-discover available devices,
/// also allows manual text input with uppercase conversion and uniqueness check.
class _CreateDeviceDialog extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateDeviceDialog({required this.onCreated});

  @override
  State<_CreateDeviceDialog> createState() => _CreateDeviceDialogState();
}

class _CreateDeviceDialogState extends State<_CreateDeviceDialog> {
  final AppDatabase _db = AppDatabase.instance;
  final MqttService _mqttService = MqttService.instance;
  final _deviceIdController = TextEditingController();
  String _selectedType = 'ph';
  String _selectedMode = '5'; // PH: '3' or '5'
  bool _loading = false;

  /// Discovered device IDs from MQTT /METER/ID topic
  final Set<String> _discoveredIds = {};
  StreamSubscription? _mqttSubscription;

  @override
  void initState() {
    super.initState();

    // Check if there's already a value from /METER/ID
    final existingId = _mqttService.deviceValues['/METER/ID'];
    if (existingId != null && existingId.isNotEmpty) {
      _discoveredIds.add(existingId);
    }

    // Listen for new /METER/ID messages
    _mqttSubscription = _mqttService.messageStream.listen((msg) {
      if (msg.topic == '/METER/ID' && msg.payload.isNotEmpty) {
        final id = msg.payload.trim().toUpperCase();
        if (id.isNotEmpty && !_discoveredIds.contains(id)) {
          if (mounted) {
            setState(() => _discoveredIds.add(id));
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _mqttSubscription?.cancel();
    _deviceIdController.dispose();
    super.dispose();
  }

  void _selectDiscoveredId(String id) {
    _deviceIdController.text = id;
    // Auto-detect type from ID prefix (matching web app logic)
    if (id.startsWith('EPT')) {
      setState(() => _selectedType = 'ph');
    } else {
      setState(() => _selectedType = 'ec');
    }
  }

  Future<void> _handleSave() async {
    final deviceId = _deviceIdController.text.trim().toUpperCase();
    if (deviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Device ID is required'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);

    // Check uniqueness (matching the React frontend fix)
    final existing = await _db.getDeviceByDeviceId(deviceId);
    if (existing != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Device ID "$deviceId" already exists'),
              backgroundColor: Colors.red),
        );
        setState(() => _loading = false);
      }
      return;
    }

    try {
      // Create device with mode
      final devicePk = await _db.insertDevice(DevicesCompanion.insert(
        deviceId: deviceId,
        type: _selectedType,
        mode: Value(_selectedMode),
      ));

      // Create default config using the selected mode
      final CalibrationConfig defaultConfig;
      if (_selectedType == 'ec') {
        defaultConfig = _selectedMode == '1'
            ? ecConfig1
            : _selectedMode == '2'
                ? ecConfig2
                : ecConfig3;
      } else {
        defaultConfig = _selectedMode == '3' ? phConfig3 : phConfig5;
      }

      final configId =
          await _db.insertDeviceConfig(DeviceConfigsCompanion.insert(
        deviceId: devicePk,
        mode: defaultConfig.mode,
        probe: Value(defaultConfig.probe),
      ));

      // Insert default calibration rows
      for (final val in defaultConfig.values) {
        await _db.insertCalibrationRow(CalibrationRowsCompanion.insert(
          configId: configId,
          val: val,
        ));
      }
      await AuditService.instance.log(
        category: AuditService.catDevice,
        action: 'create',
        entityType: 'device',
        entityId: devicePk.toString(),
        details: {
          'deviceId': deviceId,
          'type': _selectedType,
          'mode': _selectedMode,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Device created'),
              backgroundColor: Colors.green),
        );
        widget.onCreated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Create new Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('You can create new device here.',
              style: TextStyle(fontSize: 13)),
          const SizedBox(height: 16),

          // Discovered Devices from MQTT
          if (_discoveredIds.isNotEmpty) ...[
            Text(
              'Discovered Devices (from MQTT)',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _discoveredIds.map((id) {
                final isSelected = _deviceIdController.text == id;
                return ActionChip(
                  avatar: Icon(
                    isSelected ? LucideIcons.checkCircle : LucideIcons.radio,
                    size: 16,
                    color: isSelected ? Colors.green : null,
                  ),
                  label: Text(id),
                  backgroundColor: isSelected
                      ? Colors.green.withValues(alpha: 0.15)
                      : null,
                  side: isSelected
                      ? const BorderSide(color: Colors.green)
                      : null,
                  onPressed: () => _selectDiscoveredId(id),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('or enter manually',
                      style: theme.textTheme.bodySmall),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
          ] else if (_mqttService.isConnected) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Listening for devices on MQTT...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Device ID — text input with auto-uppercase
          TextField(
            controller: _deviceIdController,
            decoration: const InputDecoration(
              labelText: 'Device ID',
              hintText: 'Enter device ID',
            ),
            textCapitalization: TextCapitalization.characters,
            onChanged: (val) {
              // Auto-detect type from ID prefix
              if (val.toUpperCase().startsWith('EPT')) {
                setState(() => _selectedType = 'ph');
              } else if (val.isNotEmpty) {
                setState(() => _selectedType = 'ec');
              }
            },
          ),
          const SizedBox(height: 16),
          // Device Type
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Device Type'),
            items: const [
              DropdownMenuItem(value: 'ph', child: Text('PH')),
              DropdownMenuItem(value: 'ec', child: Text('EC')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedType = val;
                  // Reset mode to defaults when type changes
                  _selectedMode = val == 'ph' ? '5' : '3';
                });
              }
            },
          ),
          const SizedBox(height: 16),
          // Calibration Mode — shown for both PH and EC
          DropdownButtonFormField<String>(
            key: ValueKey('mode_$_selectedType'),
            initialValue: _selectedMode,
            decoration: const InputDecoration(labelText: 'Calibration Mode'),
            items: (_selectedType == 'ph' ? ['3', '5'] : ['1', '2', '3'])
                .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text('Mode $m'),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedMode = val);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _handleSave,
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child:
                      CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(LucideIcons.save, size: 16),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
