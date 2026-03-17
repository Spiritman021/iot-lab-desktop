import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants.dart';
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
  String _selectedTab = 'Calibrate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = ['Calibrate', 'Log', 'Graph', 'Alarm'][_tabController.index];
        });
      }
    });
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
          // Tab bar + Back button
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
              FilledButton.tonal(
                onPressed: _disableTabs ? null : () => context.go('/'),
                child: const Text('Back'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dashboard panel — real-time values (matches DashboardPanel.tsx)
          _DashboardPanel(
            device: _device!,
            mqttService: mqttService,
            selectedTab: _selectedTab,
          ),
          const SizedBox(height: 12),

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

// ─── Dashboard Panel (matches DashboardPanel.tsx) ────────────────────────────

class _DashboardPanel extends StatelessWidget {
  final Device device;
  final MqttService mqttService;
  final String selectedTab;

  const _DashboardPanel({
    required this.device,
    required this.mqttService,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final isEc = device.type == 'ec';
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: mqttService,
      builder: (context, _) {
        final id = device.deviceId;
        final isActive = getDeviceActiveStatus(
          mqttService.deviceStatus[id],
          DateTime.now().millisecondsSinceEpoch,
        );

        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device name + status
                Row(
                  children: [
                    Text(
                      '${device.type.toUpperCase()} Meter: ${device.deviceId}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Info cards row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Primary value (PH or EC)
                      if (isEc) ...[
                        _InfoCard(icon: LucideIcons.zap, label: 'EC',
                            value: mqttService.deviceValues['/$id/PH_VAL'] ?? '00'),
                        _InfoCard(icon: LucideIcons.activity, label: 'Resistivity',
                            value: '-', unit: 'mΩ'),
                        _InfoCard(icon: LucideIcons.circle, label: 'TDS',
                            value: '-', unit: 'ppm'),
                        _InfoCard(icon: LucideIcons.circle, label: 'Salinity',
                            value: '-', unit: 'ppm'),
                      ] else ...[
                        _InfoCard(icon: LucideIcons.ruler, label: 'PH',
                            value: mqttService.deviceValues['/$id/PH_VAL'] ?? '00'),
                      ],
                      // Common cards
                      _InfoCard(icon: LucideIcons.thermometer, label: 'Temperature',
                          value: mqttService.deviceValues['/$id/TEMP_VAL'] ?? '00', unit: '°C'),
                      _InfoCard(icon: LucideIcons.gauge, label: 'Voltage',
                          value: mqttService.deviceValues['/$id/MV_VAL'] ?? '00', unit: 'mV'),
                      _InfoCard(icon: LucideIcons.batteryFull, label: 'Battery',
                          value: mqttService.deviceValues['/$id/BATTERY'] ?? '00', unit: '%'),
                      // Slope & Offset only on Calibrate tab
                      if (selectedTab == 'Calibrate') ...[
                        _InfoCard(icon: LucideIcons.moveDownRight, label: 'Slope',
                            value: mqttService.deviceValues['/$id/SLOPE'] ?? '00', unit: '%'),
                        _InfoCard(icon: LucideIcons.arrowLeftRight, label: 'Offset',
                            value: mqttService.deviceValues['/$id/OFFSET'] ?? '00', unit: '%'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: RichText(
              text: TextSpan(
                text: value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  if (unit != null)
                    TextSpan(
                      text: ' $unit',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
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

// ─── Calibration Tab (matches CalibrationTable.tsx) ──────────────────────────

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

  // Local state mirroring web app's calibrateFor
  int _calibrateIndex = 0;
  bool _calibrateStarted = false;

  // Local mutable copy of config & rows (matching web app's useState(deviceConfig))
  late String _mode;
  late String? _probe;
  late List<_CalRow> _localRows;

  // Timer
  bool _timerActive = false;
  int _timerSeconds = 30;
  Timer? _timer;

  // MQTT listener
  StreamSubscription? _mqttSub;

  @override
  void initState() {
    super.initState();
    _mode = widget.config?.mode ?? '5';
    _probe = widget.config?.probe;
    _localRows = widget.rows
        .map((r) => _CalRow(
              id: r.id,
              val: r.val,
              valAfterCal: r.valAfterCal,
              slope: r.slope,
              temp: r.temp,
              mv: r.mv,
              minMv: r.minMv,
              maxMv: r.maxMv,
              time: r.time,
            ))
        .toList();

    _setupMqttListener();
  }

  void _setupMqttListener() {
    _mqttSub = widget.mqttService.messageStream.listen((msg) {
      final deviceId = widget.device.deviceId;

      // Listen for CAL_LOG trigger (matching web app's useEffect on calibrationTrigger)
      if (msg.topic == '/$deviceId/CAL_LOG' && msg.payload == '1.00') {
        if (_calibrateStarted) {
          _handleCalibrationDataReceived();
        }
      }

      // Listen for RESET
      if (msg.topic == '/$deviceId/RESET' && msg.payload == '1.00') {
        _handleReset();
      }
    });
  }

  void _handleCalibrationDataReceived() {
    final deviceId = widget.device.deviceId;
    final values = widget.mqttService.deviceValues;
    final rowIndex = _calibrateIndex;
    // starts with 1 for mode 5 and 2 for mode 3
    final valueIndex = rowIndex + (_mode == '5' ? 1 : 2);

    if (rowIndex < _localRows.length) {
      setState(() {
        _localRows[rowIndex] = _localRows[rowIndex].copyWith(
          valAfterCal: double.tryParse(values['/$deviceId/POST_VAL_$valueIndex'] ?? '') ?? 0,
          temp: double.tryParse(values['/$deviceId/TEMP_VAL_$valueIndex'] ?? '') ?? 0,
          slope: double.tryParse(values['/$deviceId/SLOPE_$valueIndex'] ?? '') ?? 0,
          mv: double.tryParse(values['/$deviceId/MV_$valueIndex'] ?? '') ?? 0,
          time: DateTime.now(),
        );
      });

      final maxIndex = int.parse(_mode) - 1;

      // If last row, save to DB
      if (rowIndex == maxIndex) {
        _saveCalibrationToDB();
        widget.onDisableTabsChanged(false);
      }

      // Advance index
      if (rowIndex < maxIndex) {
        setState(() {
          _calibrateIndex = rowIndex + 1;
          _calibrateStarted = false;
          _timerActive = false;
          _timer?.cancel();
        });
        _showSnack('Done. Calibrate the next value.', Colors.blue);
      } else {
        setState(() {
          _calibrateIndex = 0;
          _calibrateStarted = false;
          _timerActive = false;
          _timer?.cancel();
        });
        _showSnack('Calibration process complete.', Colors.green);
      }
    }
  }

  void _handleReset() {
    widget.onDisableTabsChanged(false);
    setState(() {
      _calibrateIndex = 0;
      _calibrateStarted = false;
      _timerActive = false;
      _timer?.cancel();
    });
    widget.onRefresh();
  }

  Future<void> _saveCalibrationToDB() async {
    for (final row in _localRows) {
      await _db.updateCalibrationRow(
        row.id,
        CalibrationRowsCompanion(
          valAfterCal: Value(row.valAfterCal),
          slope: Value(row.slope),
          temp: Value(row.temp),
          mv: Value(row.mv),
          time: Value(row.time),
        ),
      );
    }
    widget.onRefresh();
  }

  // ── Button handlers (matching CalibrationTable.tsx) ──

  void _handleStart() {
    if (_localRows.isEmpty) return;

    if (_calibrateIndex == 0) {
      _showWarningDialog();
    }

    final deviceId = widget.device.deviceId;
    // starts with 1 for mode 5 and 2 for mode 3
    final valueIndex = _calibrateIndex + (_mode == '5' ? 1 : 2);

    widget.mqttService.publishToDevice(
      '/$deviceId/CAL_MODE',
      _mode == '5' ? '2' : '1',
    );
    widget.mqttService.publishToDevice(
      '/$deviceId/B_$valueIndex',
      _localRows[_calibrateIndex].val.toString(),
    );
    widget.mqttService.publishToDevice(
      '/$deviceId/CAL',
      '${valueIndex}0',
    );

    widget.onDisableTabsChanged(true);
    setState(() {
      _calibrateStarted = true;
      _timerSeconds = 30;
      _timerActive = true;
    });
    _startTimer();
  }

  void _handleResetButton() {
    final deviceId = widget.device.deviceId;
    final valueIndex = _calibrateIndex + (_mode == '5' ? 1 : 2);

    widget.mqttService.publishToDevice('/$deviceId/RESET', '1');
    widget.mqttService.publishToDevice('/$deviceId/CAL', '${valueIndex}1');
    widget.mqttService.publishToDevice('/$deviceId/RESET', '0');

    widget.onDisableTabsChanged(false);
    setState(() {
      _calibrateIndex = 0;
      _calibrateStarted = false;
      _timerActive = false;
      _timer?.cancel();
    });
    widget.onRefresh();
  }

  void _onTimerComplete() {
    // Matching CalibrationTimer's onComplete
    final deviceId = widget.device.deviceId;
    final valueIndex = _calibrateIndex + (_mode == '5' ? 1 : 2);
    widget.mqttService.publishToDevice('/$deviceId/CAL', '${valueIndex}1');
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
        _onTimerComplete();
      }
    });
  }

  void _showWarningDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please do not close or navigate or switch tabs until calibration is complete'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _onModeChanged(String newMode) {
    final isEc = widget.device.type == 'ec';
    final deviceId = widget.device.deviceId;

    widget.mqttService.publishToDevice(
      '/$deviceId/CAL_MODE',
      newMode == '5' ? '2' : '1',
    );

    // Get default rows for this mode
    CalibrationConfig config;
    if (isEc) {
      config = newMode == '1'
          ? ecConfig1
          : newMode == '2'
              ? ecConfig2
              : ecConfig3;
    } else {
      config = newMode == '3' ? phConfig3 : phConfig5;
    }

    setState(() {
      _mode = newMode;
      _localRows = config.values.asMap().entries.map((e) {
        // Reuse existing row IDs if available
        final existingId = e.key < widget.rows.length ? widget.rows[e.key].id : -1;
        return _CalRow(id: existingId, val: e.value);
      }).toList();
    });
  }

  void _showEditTableDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _EditTableDialog(
        device: widget.device,
        localRows: _localRows,
        mqttService: widget.mqttService,
        mode: _mode,
        onSave: (updatedRows) async {
          // Update rows in DB
          for (final row in updatedRows) {
            if (row.id > 0) {
              await _db.updateCalibrationRow(
                row.id,
                CalibrationRowsCompanion(
                  val: Value(row.val),
                  minMv: Value(row.minMv),
                  maxMv: Value(row.maxMv),
                ),
              );
            }
          }
          // Publish buffer values via MQTT
          final deviceId = widget.device.deviceId;
          for (int i = 0; i < updatedRows.length; i++) {
            widget.mqttService.publishToDevice(
                '/$deviceId/B_${i + 1}', updatedRows[i].val.toString());
            widget.mqttService.publishToDevice(
                '/$deviceId/minMV${i + 1}', updatedRows[i].val.toString());
            widget.mqttService.publishToDevice(
                '/$deviceId/maxMV${i + 1}', updatedRows[i].val.toString());
          }
          widget.onRefresh();
        },
      ),
    );
  }

  Future<void> _editSingleRow(int rowIndex, double currentVal) async {
    final controller = TextEditingController(text: currentVal.toString());
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Buffer Value'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
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

    if (result != null && rowIndex < _localRows.length) {
      setState(() {
        _localRows[rowIndex] = _localRows[rowIndex].copyWith(val: result);
      });
      // Save to DB
      if (_localRows[rowIndex].id > 0) {
        await _db.updateCalibrationRow(
          _localRows[rowIndex].id,
          CalibrationRowsCompanion(val: Value(result)),
        );
      }
      widget.onRefresh();
    }
  }

  void _showSnack(String msg, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: color),
      );
    }
  }

  @override
  void dispose() {
    _mqttSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEc = widget.device.type == 'ec';
    final shouldDisable = _calibrateIndex != 0 || _calibrateStarted;
    final btnDisable = _mode.isEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode / Probe selectors + action buttons
          Row(
            children: [
              // Mode selector
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<String>(
                  initialValue: _mode,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  items: (isEc ? ['1', '2', '3'] : ['3', '5'])
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text('Mode $m'),
                          ))
                      .toList(),
                  onChanged: shouldDisable
                      ? null
                      : (val) {
                          if (val != null) _onModeChanged(val);
                        },
                ),
              ),
              const SizedBox(width: 12),
              // Probe selector (EC only)
              if (isEc)
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    initialValue: _probe ?? '0.1k',
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    items: ['0.1k', '1k', '10k']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: shouldDisable
                        ? null
                        : (val) {
                            if (val != null) setState(() => _probe = val);
                          },
                  ),
                ),
              const Spacer(),
              // Action buttons
              FilledButton(
                onPressed: shouldDisable ? _handleResetButton : null,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: (_calibrateStarted || btnDisable) ? null : _handleStart,
                child: const Text('Start'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: (shouldDisable || btnDisable) ? null : () {},
                child: const Text('Print'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: (shouldDisable || btnDisable) ? null : _showEditTableDialog,
                child: const Text('Edit Table'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Warning banner
          if (shouldDisable)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertCircle, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Warning', style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                        Text(
                          'Please do not close or navigate or switch tabs until calibration is complete',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Timer
          if (_timerActive && _calibrateStarted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Calibrating please wait ${_timerSeconds}s',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Calibration table
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              columns: [
                DataColumn(label: Text(isEc ? 'EC' : 'Ph')),
                DataColumn(label: Text('${isEc ? 'EC' : 'Ph'} After Cal')),
                const DataColumn(label: Text('Slope')),
                const DataColumn(label: Text('Temp')),
                const DataColumn(label: Text('mV')),
                const DataColumn(label: Text('Date & Time')),
              ],
              rows: _localRows.asMap().entries.map((entry) {
                final idx = entry.key;
                final row = entry.value;
                final isHighlighted = _calibrateIndex == idx;

                return DataRow(
                  color: isHighlighted
                      ? WidgetStateProperty.all(
                          Colors.blue.withValues(alpha: 0.08))
                      : null,
                  cells: [
                    // Editable cell (matching EditableCell component)
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(row.val.toString()),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _editSingleRow(idx, row.val),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(LucideIcons.pencil,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(row.valAfterCal?.toString() ?? '-')),
                    DataCell(Text(row.slope?.toString() ?? '-')),
                    DataCell(Text(row.temp?.toString() ?? '-')),
                    DataCell(Text(row.mv?.toString() ?? '-')),
                    DataCell(Text(
                      row.time != null
                          ? DateFormat('yyyy/MM/dd h:mm:ss a').format(row.time!)
                          : '-',
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mutable calibration row model (local state, not DB)
class _CalRow {
  final int id;
  final double val;
  final double? valAfterCal;
  final double? slope;
  final double? temp;
  final double? mv;
  final double? minMv;
  final double? maxMv;
  final DateTime? time;

  _CalRow({
    required this.id,
    required this.val,
    this.valAfterCal,
    this.slope,
    this.temp,
    this.mv,
    this.minMv,
    this.maxMv,
    this.time,
  });

  _CalRow copyWith({
    double? val,
    double? valAfterCal,
    double? slope,
    double? temp,
    double? mv,
    double? minMv,
    double? maxMv,
    DateTime? time,
  }) {
    return _CalRow(
      id: id,
      val: val ?? this.val,
      valAfterCal: valAfterCal ?? this.valAfterCal,
      slope: slope ?? this.slope,
      temp: temp ?? this.temp,
      mv: mv ?? this.mv,
      minMv: minMv ?? this.minMv,
      maxMv: maxMv ?? this.maxMv,
      time: time ?? this.time,
    );
  }
}

// ─── Edit Table Dialog (matches EditTableModal.tsx) ──────────────────────────

class _EditTableDialog extends StatefulWidget {
  final Device device;
  final List<_CalRow> localRows;
  final MqttService mqttService;
  final String mode;
  final Future<void> Function(List<_CalRow>) onSave;

  const _EditTableDialog({
    required this.device,
    required this.localRows,
    required this.mqttService,
    required this.mode,
    required this.onSave,
  });

  @override
  State<_EditTableDialog> createState() => _EditTableDialogState();
}

class _EditTableDialogState extends State<_EditTableDialog> {
  late List<_CalRow> _rows;
  final _tempOffsetController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rows = widget.localRows.map((r) => r.copyWith()).toList();
  }

  @override
  void dispose() {
    _tempOffsetController.dispose();
    super.dispose();
  }

  void _updateRowField(int index, String field, String value) {
    setState(() {
      final v = double.tryParse(value) ?? 0;
      switch (field) {
        case 'val':
          _rows[index] = _rows[index].copyWith(val: v);
          break;
        case 'minMv':
          _rows[index] = _rows[index].copyWith(minMv: v);
          break;
        case 'maxMv':
          _rows[index] = _rows[index].copyWith(maxMv: v);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceId = widget.device.deviceId;
    final values = widget.mqttService.deviceValues;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Table',
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Edit table data here.',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),

              // Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Buffer')),
                    DataColumn(label: Text('Min mV')),
                    DataColumn(label: Text('Max mV')),
                  ],
                  rows: _rows.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final row = entry.value;
                    return DataRow(cells: [
                      DataCell(Text('${idx + 1}')),
                      DataCell(SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: row.val.toString(),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => _updateRowField(idx, 'val', v),
                          decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        ),
                      )),
                      DataCell(SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: (row.minMv ?? 0).toString(),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => _updateRowField(idx, 'minMv', v),
                          decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        ),
                      )),
                      DataCell(SizedBox(
                        width: 100,
                        child: TextFormField(
                          initialValue: (row.maxMv ?? 0).toString(),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) => _updateRowField(idx, 'maxMv', v),
                          decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // A0, A1, V values
              ListenableBuilder(
                listenable: widget.mqttService,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ValueRow(label: 'A0', value: values['/$deviceId/A0'] ?? '-'),
                      _ValueRow(label: 'A1', value: values['/$deviceId/A1'] ?? '-'),
                      _ValueRow(label: 'V', value: values['/$deviceId/VOLTAGE'] ?? '-'),
                      const SizedBox(height: 8),
                      // Temperature Offset
                      Row(
                        children: [
                          const Text('Temperature Offset'),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _tempOffsetController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () {
                              final val = _tempOffsetController.text.trim();
                              if (val.isNotEmpty) {
                                widget.mqttService.publishToDevice(
                                    '/$deviceId/T_SET', val);
                              }
                            },
                            child: const Text('Set'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _saving
                        ? null
                        : () async {
                            setState(() => _saving = true);
                            await widget.onSave(_rows);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Config updated.'),
                                    backgroundColor: Colors.green),
                              );
                            }
                          },
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(LucideIcons.save, size: 16),
                    label: const Text('Save changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _ValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}

// ─── Log tab (unchanged) ────────────────────────────────────────────────────

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
        content:
            const Text('Are you sure you want to delete all logs for this device?'),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.logs.isNotEmpty)
              TextButton.icon(
                icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                label:
                    const Text('Delete All', style: TextStyle(color: Colors.red)),
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

// ─── Graph tab (unchanged) ──────────────────────────────────────────────────

class _GraphTab extends StatelessWidget {
  final List<Log> logs;

  const _GraphTab({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('No log data to graph'));
    }

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
            LineChartBarData(
              spots: sortedLogs.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.val);
              }).toList(),
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
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

// ─── Alarm tab (unchanged) ──────────────────────────────────────────────────

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
