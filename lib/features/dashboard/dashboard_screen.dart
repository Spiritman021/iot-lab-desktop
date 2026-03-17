import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/database/app_database.dart';
import '../../core/mqtt/mqtt_service.dart';
import '../layout/app_scaffold.dart';

/// Dashboard screen — matches web app's Dashboard.tsx with tabs:
/// Calibrate, Log, Graph, Alarm
class DashboardScreen extends StatefulWidget {
  final int deviceId;

  const DashboardScreen({super.key, required this.deviceId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final AppDatabase _db = AppDatabase.instance;
  late TabController _tabController;

  Device? _device;
  DeviceConfig? _config;
  List<CalibrationRow> _calibrationRows = [];
  List<Log> _logs = [];
  bool _loading = true;
  bool _disableTabs = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final device = await _db.getDeviceById(widget.deviceId);
      DeviceConfig? config;
      List<CalibrationRow> rows = [];
      List<Log> logs = [];

      if (device != null) {
        config = await _db.getConfigForDevice(device.id);
        if (config != null) {
          rows = await _db.getCalibrationRows(config.id);
        }
        logs = await _db.getLogsForDevice(device.id);
      }

      if (mounted) {
        setState(() {
          _device = device;
          _config = config;
          _calibrationRows = rows;
          _logs = logs;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshLogs() async {
    if (_device == null) return;
    final logs = await _db.getLogsForDevice(_device!.id);
    if (mounted) setState(() => _logs = logs);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_device == null) {
      return const Center(child: Text('Device not found'));
    }

    final mqttService = AppScaffold.of(context).mqttService;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header with tabs and back button
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Calibrate'),
                    Tab(text: 'Log'),
                    Tab(text: 'Graph'),
                    Tab(text: 'Alarm'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Dashboard panel — real-time values
              _DashboardPanel(
                device: _device!,
                mqttService: mqttService,
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: _disableTabs ? null : () => context.go('/'),
                child: const Text('Back'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: _disableTabs
                  ? const NeverScrollableScrollPhysics()
                  : null,
              children: [
                // Calibrate tab
                _CalibrationTab(
                  device: _device!,
                  config: _config,
                  rows: _calibrationRows,
                  mqttService: mqttService,
                  onRefresh: _loadData,
                  onDisableTabsChanged: (val) =>
                      setState(() => _disableTabs = val),
                ),
                // Log tab
                _LogTab(
                  device: _device!,
                  logs: _logs,
                  mqttService: mqttService,
                  onRefresh: _refreshLogs,
                ),
                // Graph tab
                _GraphTab(logs: _logs),
                // Alarm tab
                _AlarmTab(
                  device: _device!,
                  config: _config,
                  mqttService: mqttService,
                  onRefresh: _loadData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Real-time value display panel — matches web app's DashboardPanel
class _DashboardPanel extends StatelessWidget {
  final Device device;
  final MqttService mqttService;

  const _DashboardPanel({required this.device, required this.mqttService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mqttService,
      builder: (context, _) {
        final id = device.deviceId;
        final phVal = mqttService.deviceValues['/$id/PH_VAL'] ?? '--';
        final tempVal = mqttService.deviceValues['/$id/TEMP_VAL'] ?? '--';

        return Row(
          children: [
            _Chip(label: device.type == 'ph' ? 'pH' : 'EC', value: phVal),
            const SizedBox(width: 8),
            _Chip(label: '°C', value: tempVal),
          ],
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;

  const _Chip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$value $label',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }
}

/// Calibration tab — matches web app's CalibrationTable
class _CalibrationTab extends StatefulWidget {
  final Device device;
  final DeviceConfig? config;
  final List<CalibrationRow> rows;
  final MqttService mqttService;
  final VoidCallback onRefresh;
  final ValueChanged<bool> onDisableTabsChanged;

  const _CalibrationTab({
    required this.device,
    required this.config,
    required this.rows,
    required this.mqttService,
    required this.onRefresh,
    required this.onDisableTabsChanged,
  });

  @override
  State<_CalibrationTab> createState() => _CalibrationTabState();
}

class _CalibrationTabState extends State<_CalibrationTab> {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> _editRow(CalibrationRow row) async {
    final controller = TextEditingController(text: row.val.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Calibration Value'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Value'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              Navigator.pop(ctx, val);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await _db.updateCalibrationRow(
        row.id,
        CalibrationRowsCompanion(val: Value(result)),
      );
      widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Buffer Value')),
            DataColumn(label: Text('After Cal')),
            DataColumn(label: Text('Slope')),
            DataColumn(label: Text('Temp (°C)')),
            DataColumn(label: Text('mV')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Actions')),
          ],
          rows: widget.rows.asMap().entries.map((entry) {
            final idx = entry.key;
            final row = entry.value;
            return DataRow(cells: [
              DataCell(Text('${idx + 1}')),
              DataCell(Text(row.val.toStringAsFixed(2))),
              DataCell(Text(row.valAfterCal?.toStringAsFixed(2) ?? '--')),
              DataCell(Text(row.slope?.toStringAsFixed(4) ?? '--')),
              DataCell(Text(row.temp?.toStringAsFixed(2) ?? '--')),
              DataCell(Text(row.mv?.toStringAsFixed(2) ?? '--')),
              DataCell(Text(row.time?.toString().substring(0, 19) ?? '--')),
              DataCell(IconButton(
                icon: const Icon(LucideIcons.pencil, size: 16),
                onPressed: () => _editRow(row),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

/// Log tab — matches web app's LogTable
class _LogTab extends StatefulWidget {
  final Device device;
  final List<Log> logs;
  final MqttService mqttService;
  final VoidCallback onRefresh;

  const _LogTab({
    required this.device,
    required this.logs,
    required this.mqttService,
    required this.onRefresh,
  });

  @override
  State<_LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<_LogTab> {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> _deleteAllLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Logs'),
        content: const Text('Are you sure you want to delete all logs for this device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.deleteLogsForDevice(widget.device.id);
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Logs deleted'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Actions row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.logs.isNotEmpty)
              TextButton.icon(
                icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                label: const Text('Delete All', style: TextStyle(color: Colors.red)),
                onPressed: _deleteAllLogs,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: widget.logs.isEmpty
              ? const Center(child: Text('No logs recorded yet'))
              : SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('Value')),
                        DataColumn(label: Text('Temp (°C)')),
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Batch No')),
                        DataColumn(label: Text('AR No')),
                        DataColumn(label: Text('Time')),
                      ],
                      rows: widget.logs.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final log = entry.value;
                        return DataRow(cells: [
                          DataCell(Text('${idx + 1}')),
                          DataCell(Text(log.val.toStringAsFixed(2))),
                          DataCell(Text(log.temp.toStringAsFixed(2))),
                          DataCell(Text(log.product ?? '--')),
                          DataCell(Text(log.batchNo ?? '--')),
                          DataCell(Text(log.arNo ?? '--')),
                          DataCell(Text(
                              log.createdAt.toString().substring(0, 19))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

/// Graph tab — matches web app's LogsGraph using fl_chart
class _GraphTab extends StatelessWidget {
  final List<Log> logs;

  const _GraphTab({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('No log data to graph'));
    }

    // Reverse to show oldest first (logs are desc by default)
    final sortedLogs = logs.reversed.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Value'),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('Readings'),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < sortedLogs.length && idx % 5 == 0) {
                    return Text('${idx + 1}',
                        style: const TextStyle(fontSize: 10));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            // Value line
            LineChartBarData(
              spots: sortedLogs.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.val);
              }).toList(),
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            // Temperature line
            LineChartBarData(
              spots: sortedLogs.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.temp);
              }).toList(),
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              dashArray: [5, 3],
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final label = spot.barIndex == 0 ? 'Value' : 'Temp';
                  return LineTooltipItem(
                    '$label: ${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: spot.barIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Alarm tab — matches web app's AlarmSetup
class _AlarmTab extends StatefulWidget {
  final Device device;
  final DeviceConfig? config;
  final MqttService mqttService;
  final VoidCallback onRefresh;

  const _AlarmTab({
    required this.device,
    required this.config,
    required this.mqttService,
    required this.onRefresh,
  });

  @override
  State<_AlarmTab> createState() => _AlarmTabState();
}

class _AlarmTabState extends State<_AlarmTab> {
  final AppDatabase _db = AppDatabase.instance;
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minController.text = widget.config?.minPh?.toString() ?? '0';
    _maxController.text = widget.config?.maxPh?.toString() ?? '14';
  }

  Future<void> _saveAlarm() async {
    if (widget.config == null) return;
    final minPh = double.tryParse(_minController.text);
    final maxPh = double.tryParse(_maxController.text);

    if (minPh == null || maxPh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Enter valid numbers'),
            backgroundColor: Colors.red),
      );
      return;
    }

    await _db.updateDeviceConfig(
      widget.config!.id,
      DeviceConfigsCompanion(
        minPh: Value(minPh),
        maxPh: Value(maxPh),
      ),
    );

    widget.onRefresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Alarm saved'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Alarm Setup',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Set pH threshold values for alarm monitoring',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _minController,
              decoration: const InputDecoration(labelText: 'Min pH'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maxController,
              decoration: const InputDecoration(labelText: 'Max pH'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saveAlarm,
              icon: const Icon(LucideIcons.save, size: 16),
              label: const Text('Save Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
