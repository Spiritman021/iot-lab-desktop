import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/database/app_database.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final AppDatabase _db = AppDatabase.instance;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy hh:mm a');

  List<AuditLog> _logs = [];
  bool _loading = true;
  String _search = '';
  String _category = 'all';
  String _status = 'all';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);
    _logs = await _db.getAuditLogs(
      category: _category,
      status: _status,
      search: _search,
    );
    if (mounted) setState(() => _loading = false);
  }

  String _prettyDetails(String details) {
    if (details.isEmpty) return '--';
    try {
      final decoded = jsonDecode(details);
      if (decoded is Map<String, dynamic>) {
        return decoded.entries.map((e) => '${e.key}: ${e.value}').join('\n');
      }
    } catch (_) {
      return details;
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clipboardList,
                  color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Audit Logs',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: _loadLogs,
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tamper-evident, time-stamped log of authentication, files, calibration, reports, and settings activity.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search logs...',
                    prefixIcon: Icon(LucideIcons.search, size: 18),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    _search = value;
                    _loadLogs();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'auth', child: Text('Auth')),
                    DropdownMenuItem(value: 'user', child: Text('Users')),
                    DropdownMenuItem(value: 'device', child: Text('Devices')),
                    DropdownMenuItem(
                        value: 'calibration', child: Text('Calibration')),
                    DropdownMenuItem(value: 'report', child: Text('Reports')),
                    DropdownMenuItem(value: 'file', child: Text('Files')),
                    DropdownMenuItem(value: 'settings', child: Text('Settings')),
                  ],
                  onChanged: (value) {
                    _category = value ?? 'all';
                    _loadLogs();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'success', child: Text('Success')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                  ],
                  onChanged: (value) {
                    _status = value ?? 'all';
                    _loadLogs();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 16,
                        columns: const [
                          DataColumn(label: Text('Timestamp')),
                          DataColumn(label: Text('User ID')),
                          DataColumn(label: Text('User')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Action')),
                          DataColumn(label: Text('Entity')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Details')),
                        ],
                        rows: _logs.map((log) {
                          return DataRow(cells: [
                            DataCell(Text(_dateFormat.format(log.createdAt))),
                            DataCell(Text(log.userId?.toString() ?? '--')),
                            DataCell(Text(log.userName)),
                            DataCell(Text(log.category)),
                            DataCell(Text(log.action)),
                            DataCell(Text(
                                '${log.entityType}${log.entityId.isEmpty ? '' : ' #${log.entityId}'}')),
                            DataCell(Text(log.status)),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 360),
                                child: Text(_prettyDetails(log.details)),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
