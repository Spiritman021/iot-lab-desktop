import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/constants.dart';
import '../../core/database/app_database.dart';
import '../../core/mqtt/mqtt_service.dart';
import '../../core/reports/report_service.dart';
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
    final userRole = AuthService.instance.currentUser?.role ?? UserRoles.viewer;

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

          // Global alarm banner (matches Alarm.tsx — placed at dashboard level)
          _AlarmBanner(
            device: _device!,
            config: _config,
            mqttService: mqttService,
          ),

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
                  userRole: userRole,
                ),
                // Log tab
                _LogTab(
                  device: _device!,
                  logs: _logs,
                  mqttService: mqttService,
                  onRefresh: _refreshLogs,
                  userRole: userRole,
                ),
                // Graph tab
                _GraphTab(logs: _logs),
                // Alarm tab
                _AlarmTab(
                  device: _device!,
                  config: _config,
                  mqttService: mqttService,
                  onRefresh: _loadData,
                  userRole: userRole,
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
    final isThreePointPh = !isEc && device.mode == '3';
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: mqttService,
      builder: (context, _) {
        final id = device.deviceId;
        final isActive = getDeviceActiveStatus(
          mqttService.deviceStatus[id],
          DateTime.now().millisecondsSinceEpoch,
        );
        final slopeValue = isThreePointPh
            ? mqttService.deviceValues['/$id/A1'] ??
                mqttService.deviceValues['/$id/SLOPE_4'] ??
                mqttService.deviceValues['/$id/SLOPE_3'] ??
                mqttService.deviceValues['/$id/SLOPE'] ??
                '00'
            : mqttService.deviceValues['/$id/SLOPE'] ?? '00';
        final offsetValue = isThreePointPh
            ? mqttService.deviceValues['/$id/A0'] ??
                mqttService.deviceValues['/$id/OFFSET'] ??
                '00'
            : mqttService.deviceValues['/$id/OFFSET'] ?? '00';

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
                            value: slopeValue, unit: '%'),
                        _InfoCard(icon: LucideIcons.arrowLeftRight, label: 'Offset',
                            value: offsetValue, unit: '%'),
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
  final String userRole;

  const _CalibrationTab({
    required this.device,
    required this.config,
    required this.rows,
    required this.mqttService,
    required this.onRefresh,
    required this.onDisableTabsChanged,
    required this.userRole,
  });

  @override
  State<_CalibrationTab> createState() => _CalibrationTabState();
}

class _CalibrationTabState extends State<_CalibrationTab> {
  final AppDatabase _db = AppDatabase.instance;

  // Local state mirroring web app's calibrateFor = { index, started }
  int _calibrateIndex = 0;
  bool _calibrateStarted = false;

  // Mode is read from device (set at device creation/edit level)
  String get _mode => widget.device.mode;
  late String? _probe;
  late List<_CalRow> _localRows;

  // Timer (45 seconds per buffer)
  int _timerSeconds = 45;
  Timer? _timer;

  // MQTT listener
  StreamSubscription? _mqttSub;

  @override
  void initState() {
    super.initState();
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
      // Handle both '1.00' and '1' payloads
      if (msg.topic == '/$deviceId/CAL_LOG') {
        final p = msg.payload.trim();
        if ((p == '1.00' || p == '1') && _calibrateStarted) {
          // Delay slightly to ensure all POST_VAL/TEMP_VAL/SLOPE/MV values
          // have arrived and been stored in deviceValues before we read them.
          // This fixes the race condition where CAL_LOG arrives before
          // the calibration result values.
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && _calibrateStarted) {
              _handleCalibrationDataReceived();
            }
          });
        }
      }

      // Listen for RESET
      if (msg.topic == '/$deviceId/RESET') {
        final p = msg.payload.trim();
        if (p == '1.00' || p == '1') {
          _handleReset();
        }
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
      // Debug: Print what MQTT topics we're reading
      debugPrint('=== CAL DATA for buffer $rowIndex (topic index $valueIndex) ===');
      debugPrint('POST_VAL_$valueIndex = ${values['/$deviceId/POST_VAL_$valueIndex']}');
      debugPrint('TEMP_VAL_$valueIndex = ${values['/$deviceId/TEMP_VAL_$valueIndex']}');
      debugPrint('SLOPE_$valueIndex = ${values['/$deviceId/SLOPE_$valueIndex']}');
      debugPrint('MV_$valueIndex = ${values['/$deviceId/MV_$valueIndex']}');

      // Read calibration result values from MQTT deviceValues
      final valAfterCal = double.tryParse(
              values['/$deviceId/POST_VAL_$valueIndex'] ?? '') ??
          0;
      final temp = double.tryParse(
              values['/$deviceId/TEMP_VAL_$valueIndex'] ?? '') ??
          0;
      // Slope for the FIRST buffer (row 0) is always empty
      // — you need at least 2 points to compute a slope
      final double? slope = rowIndex == 0
          ? null
          : double.tryParse(values['/$deviceId/SLOPE_$valueIndex'] ?? '');
      final mv =
          double.tryParse(values['/$deviceId/MV_$valueIndex'] ?? '') ?? 0;
      final now = DateTime.now();

      setState(() {
        _localRows[rowIndex] = _localRows[rowIndex].copyWith(
          valAfterCal: valAfterCal,
          temp: temp,
          slope: slope,
          mv: mv,
          time: now,
        );
      });

      // Save THIS row to DB immediately (not just on last row)
      _saveRowToDB(rowIndex);

      final maxIndex = int.parse(_mode) - 1;

      if (rowIndex == maxIndex) {
        // Last row — calibration complete
        widget.onDisableTabsChanged(false);
        setState(() {
          _calibrateIndex = 0;
          _calibrateStarted = false;
          _timer?.cancel();
        });
        _showSnack('Calibration process complete.', Colors.green);
      } else {
        // More rows to calibrate — advance index, stop timer, wait for user to press Start
        setState(() {
          _calibrateIndex = rowIndex + 1;
          _calibrateStarted = false;
          _timer?.cancel();
        });
        _showSnack('Done. Calibrate the next value.', Colors.blue);
      }
    }
  }

  void _handleReset() {
    widget.onDisableTabsChanged(false);
    setState(() {
      _calibrateIndex = 0;
      _calibrateStarted = false;
      _timer?.cancel();
    });
    widget.onRefresh();
  }

  /// Save a single calibration row to the local DB
  Future<void> _saveRowToDB(int rowIndex) async {
    final row = _localRows[rowIndex];
    if (row.id > 0) {
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
      await AuditService.instance.log(
        category: AuditService.catCalibration,
        action: 'row_saved',
        entityType: 'calibration_row',
        entityId: row.id.toString(),
        details: {
          'deviceId': widget.device.deviceId,
          'value': row.val,
          'valueAfterCal': row.valAfterCal,
        },
      );
    }
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
    AuditService.instance.log(
      category: AuditService.catCalibration,
      action: 'start',
      entityType: 'device',
      entityId: widget.device.id.toString(),
      details: {
        'deviceId': widget.device.deviceId,
        'mode': _mode,
        'bufferValue': _localRows[_calibrateIndex].val,
      },
    );

    widget.onDisableTabsChanged(true);
    setState(() {
      _calibrateStarted = true;
      _timerSeconds = 45;
    });
    _startTimer();
  }

  void _handleResetButton() {
    final deviceId = widget.device.deviceId;
    final valueIndex = _calibrateIndex + (_mode == '5' ? 1 : 2);

    widget.mqttService.publishToDevice('/$deviceId/RESET', '1');
    widget.mqttService.publishToDevice('/$deviceId/CAL', '${valueIndex}1');
    widget.mqttService.publishToDevice('/$deviceId/RESET', '0');
    AuditService.instance.log(
      category: AuditService.catCalibration,
      action: 'reset',
      entityType: 'device',
      entityId: widget.device.id.toString(),
      details: {'deviceId': widget.device.deviceId, 'mode': _mode},
    );

    widget.onDisableTabsChanged(false);
    setState(() {
      _calibrateIndex = 0;
      _calibrateStarted = false;
      _timer?.cancel();
    });
    widget.onRefresh();
  }

  void _onTimerComplete() {
    // Timer finished — send completion signal to device
    // (matching CalibrationTimer's onComplete → publishToDevice CAL=${valueIndex}1)
    final deviceId = widget.device.deviceId;
    final valueIndex = _calibrateIndex + (_mode == '5' ? 1 : 2);
    widget.mqttService.publishToDevice('/$deviceId/CAL', '${valueIndex}1');

    // Timer UI stays showing "0s" until CAL_LOG arrives
    // Timer is done, calibrateStarted will be cleared when CAL_LOG arrives
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
        content: Text(
            'Please do not close or navigate or switch tabs until calibration is complete'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 4),
      ),
    );
  }

  // Mode is read-only from device — no _onModeChanged needed

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
          await AuditService.instance.log(
            category: AuditService.catCalibration,
            action: 'table_updated',
            entityType: 'device',
            entityId: widget.device.id.toString(),
            details: {
              'deviceId': widget.device.deviceId,
              'rowCount': updatedRows.length,
            },
          );
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
        await AuditService.instance.log(
          category: AuditService.catCalibration,
          action: 'buffer_value_updated',
          entityType: 'calibration_row',
          entityId: _localRows[rowIndex].id.toString(),
          details: {'deviceId': widget.device.deviceId, 'value': result},
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
    // shouldDisable matches web: calibrateFor?.index !== 0 || calibrateFor?.started
    final shouldDisable = _calibrateIndex != 0 || _calibrateStarted;
    final btnDisable = _mode.isEmpty;
    // Role-based access:
    // Admin: full access
    // Lab Tech: can print only, NO start/reset/edit
    // Viewer: view only, nothing clickable
    final canCal = UserRoles.canCalibrate(widget.userRole);
    final isViewer = UserRoles.isViewOnly(widget.userRole);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode / Probe selectors + action buttons
          Row(
            children: [
              // Mode display (read-only, set at device level)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Mode $_mode', style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(width: 12),
              // Probe selector (EC only) — admin only
              if (isEc)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<String>(
                    value: _probe ?? '0.1k',
                    underline: const SizedBox.shrink(),
                    isDense: true,
                    items: ['0.1k', '1k', '10k']
                        .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (shouldDisable || !canCal)
                        ? null
                        : (val) {
                            if (val != null) setState(() => _probe = val);
                          },
                  ),
                ),
              const Spacer(),
              // Reset: admin only
              FilledButton(
                onPressed: (shouldDisable && canCal) ? _handleResetButton : null,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              // Start: admin only
              FilledButton(
                onPressed:
                    (canCal && !_calibrateStarted && !btnDisable) ? _handleStart : null,
                child: const Text('Start'),
              ),
              const SizedBox(width: 8),
              // Print: allowed for admin + lab tech (not viewer)
              FilledButton.tonal(
                onPressed: (shouldDisable || btnDisable || isViewer) ? null : () {
                  ReportService.printCalibrationReport(
                    context: context,
                    deviceId: widget.device.deviceId,
                    deviceType: widget.device.type,
                    mode: widget.device.mode,
                    rows: _localRows.map((r) => CalibrationRow(
                      id: r.id,
                      configId: 0,
                      val: r.val,
                      valAfterCal: r.valAfterCal,
                      slope: r.slope,
                      temp: r.temp,
                      mv: r.mv,
                      minMv: r.minMv,
                      maxMv: r.maxMv,
                      time: r.time,
                    )).toList(),
                    probe: _probe,
                  );
                },
                child: const Text('Print'),
              ),
              const SizedBox(width: 8),
              // Edit Table: admin only
              FilledButton.tonal(
                onPressed:
                    (canCal && !shouldDisable && !btnDisable) ? _showEditTableDialog : null,
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
                  const Icon(LucideIcons.alertCircle,
                      size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Warning',
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        Text(
                          'Please do not close or navigate or switch tabs until calibration is complete',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Timer — shown while calibration is started (matching web: calibrateFor?.started)
          if (_calibrateStarted)
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
                theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
              ),
              columns: [
                DataColumn(label: Text(isEc ? 'EC' : 'Ph')),
                DataColumn(
                    label: Text('${isEc ? 'EC' : 'Ph'} After Cal')),
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
                    // Editable cell
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
                    // Slope for first buffer (row 0) is always '--'
                    DataCell(Text(idx == 0 ? '-' : (row.slope?.toString() ?? '-'))),
                    DataCell(Text(row.temp?.toString() ?? '-')),
                    DataCell(Text(row.mv?.toString() ?? '-')),
                    DataCell(Text(
                      row.time != null
                          ? DateFormat('yyyy/MM/dd h:mm:ss a')
                              .format(row.time!)
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

// ─── Log tab (matches LogTable.tsx + LogModeComp.tsx + ProductDetails.tsx) ───

class _LogTab extends StatefulWidget {
  final Device device;
  final List<Log> logs;
  final MqttService mqttService;
  final VoidCallback onRefresh;
  final String userRole;

  const _LogTab({
    required this.device,
    required this.logs,
    required this.mqttService,
    required this.onRefresh,
    required this.userRole,
  });

  @override
  State<_LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<_LogTab> {
  final AppDatabase _db = AppDatabase.instance;

  // Product details (matching ProductDetails.tsx)
  final _productController = TextEditingController();
  final _batchNoController = TextEditingController();
  final _arNoController = TextEditingController();

  // Log mode (matching LogModeComp.tsx)
  String _logMode = '0'; // '0'=off, '1'=stable, '2'=button, '3'=interval
  bool _disabled = false;

  // Interval timer
  final _hrsController = TextEditingController(text: '0');
  final _minsController = TextEditingController(text: '0');
  final _secsController = TextEditingController(text: '0');
  bool _intervalStarted = false;

  // MQTT listener for LOG_DATA and RESET
  StreamSubscription? _mqttSub;

  @override
  void initState() {
    super.initState();
    _setupMqttListener();
  }

  void _setupMqttListener() {
    final deviceId = widget.device.deviceId;

    _mqttSub = widget.mqttService.messageStream.listen((msg) {
      // Listen for LOG_DATA — create log locally (replaces backend logic)
      if (msg.topic == '/$deviceId/LOG_DATA' && msg.payload.isNotEmpty) {
        _handleLogData(msg.payload);
      }

      // Listen for RESET
      if (msg.topic == '/$deviceId/RESET' && msg.payload == '1.00') {
        if (mounted) {
          setState(() {
            _logMode = '0';
            _disabled = false;
            _intervalStarted = false;
            _hrsController.text = '0';
            _minsController.text = '0';
            _secsController.text = '0';
          });
        }
      }
    });
  }

  Future<void> _handleLogData(String payload) async {
    // Parse "val/temp" format (matching backend's LOG_DATA handler)
    final parts = payload.split('/');
    if (parts.length < 2) return;

    final val = double.tryParse(parts[0]);
    final temp = double.tryParse(parts[1]);
    if (val == null || temp == null) return;

    // Create log in local DB (replaces backend's Log.create)
    await _db.insertLog(LogsCompanion.insert(
      deviceId: widget.device.id,
      val: double.parse(val.toStringAsFixed(2)),
      temp: double.parse(temp.toStringAsFixed(2)),
      product: Value(_productController.text.trim().isEmpty
          ? null
          : _productController.text.trim()),
      batchNo: Value(_batchNoController.text.trim().isEmpty
          ? null
          : _batchNoController.text.trim()),
      arNo: Value(_arNoController.text.trim().isEmpty
          ? null
          : _arNoController.text.trim()),
    ));
    await AuditService.instance.log(
      category: AuditService.catDevice,
      action: 'log_created',
      entityType: 'device_log',
      entityId: widget.device.id.toString(),
      details: {
        'deviceId': widget.device.deviceId,
        'value': double.parse(val.toStringAsFixed(2)),
        'temp': double.parse(temp.toStringAsFixed(2)),
      },
    );

    widget.onRefresh();
  }

  // ── Log Mode handlers (matching LogModeComp.tsx) ──

  void _handleModeSwitch(bool enabled, String modeValue) {
    final deviceId = widget.device.deviceId;

    setState(() {
      _disabled = enabled;
      _logMode = enabled ? modeValue : '0';
      _intervalStarted = false;
      _hrsController.text = '0';
      _minsController.text = '0';
      _secsController.text = '0';
    });

    widget.mqttService.publishToDevice('/$deviceId/LOG_MS', '0');
    widget.mqttService.publishToDevice(
        '/$deviceId/LOG_MODE', enabled ? modeValue : '0');
  }

  void _handleManualLog() {
    final deviceId = widget.device.deviceId;
    final val = widget.mqttService.deviceValues['/$deviceId/PH_VAL'] ?? '0';
    final temp = widget.mqttService.deviceValues['/$deviceId/TEMP_VAL'] ?? '0';

    // Publish LOG_DATA to trigger log creation (matching web app's Log button)
    widget.mqttService.publishToDevice('/$deviceId/LOG_DATA', '$val/$temp');
  }

  void _startStopInterval() {
    final deviceId = widget.device.deviceId;

    if (!_intervalStarted) {
      // Start interval
      final hrs = int.tryParse(_hrsController.text) ?? 0;
      final mins = int.tryParse(_minsController.text) ?? 0;
      final secs = int.tryParse(_secsController.text) ?? 0;
      final totalSecs = hrs * 3600 + mins * 60 + secs;

      widget.mqttService.publishToDevice(
          '/$deviceId/LOG_MS', (totalSecs * 1000).toString());
      widget.mqttService.publishToDevice('/$deviceId/LOG_MODE', '3');
    } else {
      // Stop interval
      widget.mqttService.publishToDevice('/$deviceId/LOG_MS', '0');
    }

    setState(() => _intervalStarted = !_intervalStarted);
  }

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text(
            'Are you sure you want to delete all logs for this device?'),
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
      await AuditService.instance.log(
        category: AuditService.catDevice,
        action: 'logs_cleared',
        entityType: 'device',
        entityId: widget.device.id.toString(),
        details: {'deviceId': widget.device.deviceId},
      );
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Logs cleared'), backgroundColor: Colors.green),
        );
      }
    }
  }

  void _clearProductDetails() {
    _productController.clear();
    _batchNoController.clear();
    _arNoController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Details cleared'), backgroundColor: Colors.green),
    );
  }

  void _submitProductDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Details saved'), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _mqttSub?.cancel();
    _productController.dispose();
    _batchNoController.dispose();
    _arNoController.dispose();
    _hrsController.dispose();
    _minsController.dispose();
    _secsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEc = widget.device.type == 'ec';
    final canDoLog = UserRoles.canLog(widget.userRole);
    final hasInterval = (int.tryParse(_hrsController.text) ?? 0) > 0 ||
        (int.tryParse(_minsController.text) ?? 0) > 0 ||
        (int.tryParse(_secsController.text) ?? 0) > 0;

    // Reverse logs for display (newest first, matching web app)
    final reversedLogs = widget.logs.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Product Details (matches ProductDetails.tsx) ──
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _productController,
                  enabled: !_disabled && canDoLog,
                  decoration: const InputDecoration(
                    hintText: 'Product Name',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _batchNoController,
                  enabled: !_disabled && canDoLog,
                  decoration: const InputDecoration(
                    hintText: 'Batch No',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _arNoController,
                  enabled: !_disabled && canDoLog,
                  decoration: const InputDecoration(
                    hintText: 'AR No',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: (_disabled || !canDoLog) ? null : _submitProductDetails,
                child: const Text('Submit'),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                enabled: !_disabled && canDoLog,
                onSelected: (val) {
                  if (val == 'Pdf') {
                    ReportService.printLogsReport(
                      context: context,
                      deviceId: widget.device.deviceId,
                      deviceType: widget.device.type,
                      logs: widget.logs,
                      product: _productController.text,
                      batchNo: _batchNoController.text,
                      arNo: _arNoController.text,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Export $val - coming soon')),
                    );
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'Pdf', child: Text('Export PDF')),
                  const PopupMenuItem(value: 'All', child: Text('Export All')),
                ],
                child: FilledButton.tonal(
                  onPressed: (_disabled || !canDoLog) ? null : () {},
                  child: const Text('Export'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: (_disabled || !canDoLog) ? null : _clearProductDetails,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear Details'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Log Mode Controls (matches LogModeComp.tsx) ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Manual Log button
              FilledButton(
                onPressed: canDoLog ? _handleManualLog : null,
                child: const Text('Log'),
              ),
              const SizedBox(width: 16),

              // Log on Stable
              _LogModeSwitch(
                label: 'Log on Stable',
                isActive: _logMode == '1',
                enabled: canDoLog,
                onChanged: (val) => _handleModeSwitch(val, '1'),
              ),
              const SizedBox(width: 16),

              // Log on Button
              _LogModeSwitch(
                label: 'Log on Button',
                isActive: _logMode == '2',
                enabled: canDoLog,
                onChanged: (val) => _handleModeSwitch(val, '2'),
              ),
              const SizedBox(width: 16),

              // Log at Interval
              _LogModeSwitch(
                label: 'Log at Interval',
                isActive: _logMode == '3',
                enabled: canDoLog,
                onChanged: (val) => _handleModeSwitch(val, '3'),
              ),
              const SizedBox(width: 12),

              // Interval inputs (h/m/s)
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _hrsController,
                  enabled: _logMode == '3' && !_intervalStarted && canDoLog,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'h',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _minsController,
                  enabled: _logMode == '3' && !_intervalStarted && canDoLog,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'm',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _secsController,
                  enabled: _logMode == '3' && !_intervalStarted && canDoLog,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 's',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Start/Stop button
              IconButton.filled(
                onPressed:
                    (_logMode != '3' || !hasInterval || !canDoLog) ? null : _startStopInterval,
                icon: Icon(
                  _intervalStarted ? LucideIcons.square : LucideIcons.play,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),

              // Interval status
              if (_intervalStarted)
                Text(
                  'Logging every '
                  '${(int.tryParse(_hrsController.text) ?? 0) > 0 ? '${_hrsController.text}h ' : ''}'
                  '${(int.tryParse(_minsController.text) ?? 0) > 0 ? '${_minsController.text}m ' : ''}'
                  '${(int.tryParse(_secsController.text) ?? 0) > 0 ? '${_secsController.text}s' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(width: 16),

              // Clear Logs
              FilledButton(
                onPressed: (_logMode != '0' || !canDoLog) ? null : _clearLogs,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear Logs'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Log Table (matches LogTable.tsx) ──
        Expanded(
          child: reversedLogs.isEmpty
              ? const Center(child: Text('No logs recorded yet'))
              : SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text('Date Time')),
                        DataColumn(label: Text(isEc ? 'EC' : 'Ph')),
                        const DataColumn(label: Text('Temp')),
                        const DataColumn(label: Text('Product')),
                        const DataColumn(label: Text('Batch No.')),
                        const DataColumn(label: Text('AR No.')),
                      ],
                      rows: reversedLogs.map((log) {
                        return DataRow(cells: [
                          DataCell(Text(
                            DateFormat('yyyy/MM/dd h:mm:ss a')
                                .format(log.createdAt),
                          )),
                          DataCell(Text(log.val.toStringAsFixed(2))),
                          DataCell(Text(log.temp.toStringAsFixed(2))),
                          DataCell(Text(log.product ?? '')),
                          DataCell(Text(log.batchNo ?? '')),
                          DataCell(Text(log.arNo ?? '')),
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

/// Log mode toggle switch (matches the Switch component in LogModeComp.tsx)
class _LogModeSwitch extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _LogModeSwitch({
    required this.label,
    required this.isActive,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 4),
        Switch(
          value: isActive,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}

// ─── Graph tab (matches LogsGraph.tsx) ──────────────────────────────────────

class _GraphTab extends StatelessWidget {
  final List<Log> logs;

  const _GraphTab({required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('No log data to graph'));
    }

    final theme = Theme.of(context);

    // Keep original order (oldest first) for chronological plotting
    final chartLogs = logs.reversed.toList();

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Column(
            children: [
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(
                    color: theme.colorScheme.primary,
                    label: 'Ph / EC',
                  ),
                  const SizedBox(width: 24),
                  const _LegendItem(
                    color: Colors.orange,
                    label: 'Temperature',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Chart
              Expanded(
                child: LineChart(
                  LineChartData(
                    // Horizontal grid lines only (matching CartesianGrid vertical={false})
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                    ),
                    titlesData: FlTitlesData(
                      // Y-axis (left)
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      // X-axis (bottom) — time labels matching web app's toLocaleTimeString()
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: chartLogs.length > 10
                              ? (chartLogs.length / 8).ceilToDouble()
                              : 1,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < chartLogs.length) {
                              final t = chartLogs[idx].createdAt;
                              final hour = t.hour > 12
                                  ? t.hour - 12
                                  : t.hour == 0
                                      ? 12
                                      : t.hour;
                              final amPm = t.hour >= 12 ? 'PM' : 'AM';
                              final timeStr =
                                  '$hour:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')} $amPm';
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    timeStr,
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(
                            color: theme.colorScheme.outlineVariant),
                        bottom: BorderSide(
                            color: theme.colorScheme.outlineVariant),
                      ),
                    ),
                    lineBarsData: [
                      // Ph/EC line (matching dataKey="ph", stroke="var(--chart-2)")
                      LineChartBarData(
                        spots: chartLogs.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.val);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: theme.colorScheme.primary,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.05),
                        ),
                      ),
                      // Temperature line (matching dataKey="temp", stroke="var(--chart-1)")
                      LineChartBarData(
                        spots: chartLogs.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.temp);
                        }).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: Colors.orange,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.orange.withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final label =
                                spot.barIndex == 0 ? 'Ph/EC' : 'Temp';
                            return LineTooltipItem(
                              '$label: ${spot.y.toStringAsFixed(2)}',
                              TextStyle(
                                color: spot.barIndex == 0
                                    ? theme.colorScheme.primary
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ─── Alarm Banner (matches Alarm.tsx — dashboard-level alert) ────────────────

class _AlarmBanner extends StatefulWidget {
  final Device device;
  final DeviceConfig? config;
  final MqttService mqttService;

  const _AlarmBanner({
    required this.device,
    required this.config,
    required this.mqttService,
  });

  @override
  State<_AlarmBanner> createState() => _AlarmBannerState();
}

class _AlarmBannerState extends State<_AlarmBanner> {
  String? _alarmTriggered; // 'min' | 'max' | null
  bool _muted = false;

  @override
  Widget build(BuildContext context) {
    final minPh = widget.config?.minPh ?? 0;
    final maxPh = widget.config?.maxPh ?? 0;
    final deviceId = widget.device.deviceId;

    return ListenableBuilder(
      listenable: widget.mqttService,
      builder: (context, _) {
        final value = double.tryParse(
                widget.mqttService.deviceValues['/$deviceId/PH_VAL'] ?? '0') ??
            0;
        final isActive =
            widget.mqttService.deviceValues['/$deviceId/STATUS'] == '1';

        // Alarm logic (matching Alarm.tsx useEffect)
        String? triggered;
        if (minPh >= maxPh || !isActive) {
          triggered = null;
        } else {
          if (value < minPh) {
            triggered = 'min';
          } else if (value > maxPh) {
            triggered = 'max';
          }
        }

        // Reset mute when alarm goes away
        if (triggered == null && _alarmTriggered != null) {
          _muted = false;
        }
        _alarmTriggered = triggered;

        if (triggered == null) return const SizedBox.shrink();
        if (_muted) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.alertCircle, size: 18, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Warning alarm triggered',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'PH value is ${triggered == "min" ? "less" : "greater"} '
                      'than the ${triggered == "min" ? "minimum" : "maximum"} set value',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  setState(() => _muted = true);
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Mute Alarm'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Alarm tab (matches AlarmSetup.tsx) ─────────────────────────────────────

class _AlarmTab extends StatefulWidget {
  final Device device;
  final DeviceConfig? config;
  final MqttService mqttService;
  final VoidCallback onRefresh;
  final String userRole;

  const _AlarmTab({
    required this.device,
    required this.config,
    required this.mqttService,
    required this.onRefresh,
    required this.userRole,
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
    _maxController.text = widget.config?.maxPh?.toString() ?? '0';
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
    await AuditService.instance.log(
      category: AuditService.catSettings,
      action: 'alarm_saved',
      entityType: 'device_config',
      entityId: widget.config!.id.toString(),
      details: {
        'deviceId': widget.device.deviceId,
        'minPh': minPh,
        'maxPh': maxPh,
      },
    );

    widget.onRefresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Alarm saved'), backgroundColor: Colors.green),
      );
    }
  }

  void _resetAlarm() {
    setState(() {
      _minController.text = '0';
      _maxController.text = '0';
    });
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Centered at 60% width (matching className="mx-auto mt-8 w-full lg:w-3/5")
    final canDoAlarm = UserRoles.canAlarm(widget.userRole);
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Min PH
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Min PH',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            )),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _minController,
                      enabled: canDoAlarm,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Max PH
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Max PH',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            )),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _maxController,
                      enabled: canDoAlarm,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Save + Reset buttons (matching web app's flex gap-5)
              FilledButton(
                onPressed: canDoAlarm ? _saveAlarm : null,
                child: const Text('Save'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: canDoAlarm ? _resetAlarm : null,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
