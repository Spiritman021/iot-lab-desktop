import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/database/app_database.dart';

/// File Manager screen — view, filter, sort, search, open, delete, print reports.
class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final AppDatabase _db = AppDatabase.instance;
  final _dateFormat = DateFormat('dd-MM-yyyy hh:mm a');

  List<ReportFile> _allFiles = [];
  List<ReportFile> _filteredFiles = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterType = 'all'; // 'all', 'calibration', 'log', 'graph'
  String _sortBy = 'date_desc'; // 'date_desc', 'date_asc', 'name_asc', 'name_desc', 'size_desc'

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _loading = true);
    _allFiles = await _db.getAllReportFiles();
    _applyFilters();
    setState(() => _loading = false);
  }

  void _applyFilters() {
    var files = List<ReportFile>.from(_allFiles);

    // Type filter
    if (_filterType != 'all') {
      files = files.where((f) => f.reportType == _filterType).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      files = files
          .where((f) =>
              f.fileName.toLowerCase().contains(q) ||
              f.deviceId.toLowerCase().contains(q) ||
              f.generatedBy.toLowerCase().contains(q))
          .toList();
    }

    // Sort
    switch (_sortBy) {
      case 'date_asc':
        files.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'name_asc':
        files.sort((a, b) => a.fileName.compareTo(b.fileName));
        break;
      case 'name_desc':
        files.sort((a, b) => b.fileName.compareTo(a.fileName));
        break;
      case 'size_desc':
        files.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      default: // date_desc
        files.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    _filteredFiles = files;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'calibration':
        return LucideIcons.flaskConical;
      case 'log':
        return LucideIcons.fileText;
      case 'graph':
        return LucideIcons.lineChart;
      default:
        return LucideIcons.file;
    }
  }

  Color _typeColor(String type, BuildContext context) {
    switch (type) {
      case 'calibration':
        return Colors.blue.shade600;
      case 'log':
        return Colors.green.shade600;
      case 'graph':
        return Colors.orange.shade600;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Future<void> _openFile(ReportFile file) async {
    final f = File(file.filePath);
    if (!f.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('File not found on disk'),
              backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (file.format == 'pdf') {
      final bytes = await f.readAsBytes();
      await AuditService.instance.log(
        category: AuditService.catFile,
        action: 'open',
        entityType: 'report',
        entityId: file.id.toString(),
        details: {'fileName': file.fileName},
      );
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(file.fileName)),
              body: PdfPreview(
                build: (_) => bytes,
                canChangeOrientation: false,
                canDebug: false,
                pdfFileName: file.fileName,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _printFile(ReportFile file) async {
    final f = File(file.filePath);
    if (!f.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('File not found on disk'),
              backgroundColor: Colors.red),
        );
      }
      return;
    }

    final bytes = await f.readAsBytes();
    await AuditService.instance.log(
      category: AuditService.catFile,
      action: 'print',
      entityType: 'report',
      entityId: file.id.toString(),
      details: {'fileName': file.fileName},
    );
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  Future<void> _shareFile(ReportFile file) async {
    final f = File(file.filePath);
    if (!f.existsSync()) return;
    final bytes = await f.readAsBytes();
    await AuditService.instance.log(
      category: AuditService.catFile,
      action: 'export',
      entityType: 'report',
      entityId: file.id.toString(),
      details: {'fileName': file.fileName},
    );
    await Printing.sharePdf(bytes: bytes, filename: file.fileName);
  }

  Future<void> _deleteFile(ReportFile file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Delete "${file.fileName}"?\nThis cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      // Delete from disk
      final f = File(file.filePath);
      if (f.existsSync()) f.deleteSync();
      // Delete from DB
      await _db.deleteReportFile(file.id);
      await AuditService.instance.log(
        category: AuditService.catFile,
        action: 'delete',
        entityType: 'report',
        entityId: file.id.toString(),
        details: {'fileName': file.fileName},
      );
      _loadFiles();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('File deleted'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userRole = AuthService.instance.currentUser?.role ?? 'viewer';
    final canDelete = UserRoles.canAccessAdmin(userRole);
    final canPrint = !UserRoles.isViewOnly(userRole);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(LucideIcons.folderOpen,
                  size: 24, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'File Manager',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              // Stats
              Chip(
                label: Text('${_filteredFiles.length} files'),
                avatar: const Icon(LucideIcons.file, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search + Filter + Sort
          Row(
            children: [
              // Search
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search files...',
                    prefixIcon: Icon(LucideIcons.search, size: 18),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    _searchQuery = v;
                    _applyFilters();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Type filter
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _filterType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Types')),
                    DropdownMenuItem(
                        value: 'calibration', child: Text('Calibration')),
                    DropdownMenuItem(value: 'log', child: Text('Log')),
                    DropdownMenuItem(value: 'graph', child: Text('Graph')),
                  ],
                  onChanged: (v) {
                    _filterType = v ?? 'all';
                    _applyFilters();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Sort
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _sortBy,
                  decoration: const InputDecoration(
                    labelText: 'Sort By',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'date_desc', child: Text('Newest First')),
                    DropdownMenuItem(
                        value: 'date_asc', child: Text('Oldest First')),
                    DropdownMenuItem(
                        value: 'name_asc', child: Text('Name A-Z')),
                    DropdownMenuItem(
                        value: 'name_desc', child: Text('Name Z-A')),
                    DropdownMenuItem(
                        value: 'size_desc', child: Text('Largest First')),
                  ],
                  onChanged: (v) {
                    _sortBy = v ?? 'date_desc';
                    _applyFilters();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Refresh
              IconButton(
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                tooltip: 'Refresh',
                onPressed: _loadFiles,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // File list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.fileX,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.3)),
                            const SizedBox(height: 12),
                            Text(
                              'No files found',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Generate reports from the Dashboard to see them here.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 16,
                              columns: const [
                                DataColumn(label: Text('File')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Device')),
                                DataColumn(label: Text('Size')),
                                DataColumn(label: Text('Generated By')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _filteredFiles.map((file) {
                                final color = _typeColor(file.reportType, context);
                                return DataRow(cells: [
                                  // File name
                                  DataCell(
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 280),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_typeIcon(file.reportType),
                                              size: 16, color: color),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              file.fileName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () => _openFile(file),
                                  ),
                                  // Type chip
                                  DataCell(
                                    Chip(
                                      label: Text(
                                        file.reportType[0].toUpperCase() +
                                            file.reportType.substring(1),
                                        style: TextStyle(
                                            fontSize: 10, color: color),
                                      ),
                                      backgroundColor:
                                          color.withValues(alpha: 0.1),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  // Device
                                  DataCell(Text(file.deviceId)),
                                  // Size
                                  DataCell(Text(_formatSize(file.fileSize))),
                                  // Generated by
                                  DataCell(Text(file.generatedBy)),
                                  // Date
                                  DataCell(
                                      Text(_dateFormat.format(file.createdAt))),
                                  // Actions
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Open
                                        IconButton(
                                          icon: Icon(LucideIcons.eye,
                                              size: 16,
                                              color:
                                                  theme.colorScheme.primary),
                                          tooltip: 'Open',
                                          onPressed: () => _openFile(file),
                                        ),
                                        // Print
                                        if (canPrint)
                                          IconButton(
                                            icon: Icon(LucideIcons.printer,
                                                size: 16,
                                                color: Colors.blue.shade600),
                                            tooltip: 'Print',
                                            onPressed: () => _printFile(file),
                                          ),
                                        // Share/Export
                                        if (canPrint)
                                          IconButton(
                                            icon: Icon(LucideIcons.share2,
                                                size: 16,
                                                color:
                                                    Colors.green.shade600),
                                            tooltip: 'Export / Share',
                                            onPressed: () => _shareFile(file),
                                          ),
                                        // Delete
                                        if (canDelete)
                                          IconButton(
                                            icon: Icon(LucideIcons.trash2,
                                                size: 16,
                                                color: Colors.red.shade600),
                                            tooltip: 'Delete',
                                            onPressed: () =>
                                                _deleteFile(file),
                                          ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
