import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants.dart';
import '../../core/database/app_database.dart';

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
                              ],
                              rows: _devices.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final device = entry.value;
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${(_page - 1) * paginationLimit + idx + 1}')),
                                  DataCell(Text(device.deviceId)),
                                  DataCell(Text(device.type.toUpperCase())),
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
}

/// Create Device dialog — matches web app's CreateDeviceModal
/// Device ID is uppercase text input with uniqueness check (matching the fix we made earlier)
class _CreateDeviceDialog extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateDeviceDialog({required this.onCreated});

  @override
  State<_CreateDeviceDialog> createState() => _CreateDeviceDialogState();
}

class _CreateDeviceDialogState extends State<_CreateDeviceDialog> {
  final AppDatabase _db = AppDatabase.instance;
  final _deviceIdController = TextEditingController();
  String _selectedType = 'ph';
  bool _loading = false;

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
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
      // Create device
      final devicePk = await _db.insertDevice(DevicesCompanion.insert(
        deviceId: deviceId,
        type: _selectedType,
      ));

      // Create default config (matching web app's logic)
      final defaultConfig =
          _selectedType == 'ec' ? ecConfig3 : phConfig5;

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
    return AlertDialog(
      title: const Text('Create new Device'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('You can create new device here.',
              style: TextStyle(fontSize: 13)),
          const SizedBox(height: 16),
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
              } else {
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
              if (val != null) setState(() => _selectedType = val);
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
