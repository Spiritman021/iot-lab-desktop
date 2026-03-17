import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants.dart';
import '../../core/database/app_database.dart';

/// Manage Header & Footer screen — matches web app's ManageHeaderAndFooter.tsx
class ManageHeaderFooterScreen extends StatefulWidget {
  const ManageHeaderFooterScreen({super.key});

  @override
  State<ManageHeaderFooterScreen> createState() =>
      _ManageHeaderFooterScreenState();
}

class _ManageHeaderFooterScreenState extends State<ManageHeaderFooterScreen> {
  final AppDatabase _db = AppDatabase.instance;
  List<HeaderFooter> _items = [];
  int _totalCount = 0;
  int _page = 1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      final items =
          await _db.getHeaderFooters(page: _page, limit: paginationLimit);
      final count = await _db.getHeaderFooterCount();
      if (mounted) {
        setState(() {
          _items = items;
          _totalCount = count;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _totalPages => (_totalCount / paginationLimit).ceil().clamp(1, 999);

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _CreateHeaderFooterDialog(onCreated: _loadItems),
    );
  }

  Future<void> _selectItem(HeaderFooter item) async {
    await _db.selectHeaderFooter(item.id);
    _loadItems();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('"${item.name}" selected as active template'),
            backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _deleteItem(HeaderFooter item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
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
      await _db.deleteHeaderFooter(item.id);
      _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Template deleted'),
              backgroundColor: Colors.green),
        );
      }
    }
  }

  void _editItem(HeaderFooter item) {
    showDialog(
      context: context,
      builder: (ctx) =>
          _EditHeaderFooterDialog(item: item, onUpdated: _loadItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page Setup',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Create'),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _items.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final item = entry.value;
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${(_page - 1) * paginationLimit + idx + 1}')),
                                  DataCell(Text(item.name)),
                                  DataCell(
                                    item.selected
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text('Active',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12)),
                                          )
                                        : const Text('--'),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                          LucideIcons.moreVertical,
                                          size: 16),
                                      itemBuilder: (ctx) => [
                                        if (!item.selected)
                                          const PopupMenuItem(
                                            value: 'select',
                                            child: Row(
                                              children: [
                                                Icon(LucideIcons.check,
                                                    size: 14),
                                                SizedBox(width: 8),
                                                Text('Select'),
                                              ],
                                            ),
                                          ),
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(LucideIcons.pencil,
                                                  size: 14),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(LucideIcons.trash2,
                                                  size: 14,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (val) {
                                        if (val == 'select') {
                                          _selectItem(item);
                                        }
                                        if (val == 'edit') _editItem(item);
                                        if (val == 'delete') _deleteItem(item);
                                      },
                                    ),
                                  ),
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
                            Text('Page: $_page of $_totalPages',
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              'Rows: ${(_page - 1) * paginationLimit + 1} - ${((_page - 1) * paginationLimit + _items.length).clamp(0, _totalCount)} of $_totalCount',
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
                                          _loadItems();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronLeft,
                                      size: 16),
                                  onPressed: _page > 1
                                      ? () {
                                          setState(() => _page--);
                                          _loadItems();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(() => _page++);
                                          _loadItems();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronsRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(
                                              () => _page = _totalPages);
                                          _loadItems();
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

/// Create Header & Footer dialog
class _CreateHeaderFooterDialog extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateHeaderFooterDialog({required this.onCreated});

  @override
  State<_CreateHeaderFooterDialog> createState() =>
      _CreateHeaderFooterDialogState();
}

class _CreateHeaderFooterDialogState
    extends State<_CreateHeaderFooterDialog> {
  final _db = AppDatabase.instance;
  final _nameController = TextEditingController();
  // Header fields
  final _hTextNameController = TextEditingController();
  final _hTextPosController = TextEditingController(text: 'center');
  final _hTextSizeController = TextEditingController(text: '14');
  final _hTextFontController = TextEditingController(text: 'Arial');
  bool _hCompanyName = false;
  bool _hCalibrate = false;
  bool _hReportGen = false;
  bool _hDeviceId = false;
  // Footer fields
  final _fTextNameController = TextEditingController();
  final _fTextPosController = TextEditingController(text: 'center');
  final _fTextSizeController = TextEditingController(text: '12');
  final _fTextFontController = TextEditingController(text: 'Arial');
  bool _loading = false;

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Template name is required'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _db.insertHeaderFooter(HeaderFootersCompanion.insert(
        name: _nameController.text.trim(),
        hTextName: Value(_hTextNameController.text),
        hTextPosition: Value(_hTextPosController.text),
        hTextSize: Value(_hTextSizeController.text),
        hTextFont: Value(_hTextFontController.text),
        hCompanyName: Value(_hCompanyName),
        hCalibrate: Value(_hCalibrate),
        hReportGen: Value(_hReportGen),
        hDeviceId: Value(_hDeviceId),
        fTextName: Value(_fTextNameController.text),
        fTextPosition: Value(_fTextPosController.text),
        fTextSize: Value(_fTextSizeController.text),
        fTextFont: Value(_fTextFontController.text),
      ));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Template created'),
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
  void dispose() {
    _nameController.dispose();
    _hTextNameController.dispose();
    _hTextPosController.dispose();
    _hTextSizeController.dispose();
    _hTextFontController.dispose();
    _fTextNameController.dispose();
    _fTextPosController.dispose();
    _fTextSizeController.dispose();
    _fTextFontController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Template'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Template Name'),
              ),
              const SizedBox(height: 20),
              // Header section
              Text('Header',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _hTextNameController,
                decoration: const InputDecoration(labelText: 'Header Text'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hTextPosController,
                      decoration: const InputDecoration(labelText: 'Position'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _hTextSizeController,
                      decoration: const InputDecoration(labelText: 'Font Size'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _hTextFontController,
                      decoration: const InputDecoration(labelText: 'Font'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  _Toggle(
                      label: 'Company Name',
                      value: _hCompanyName,
                      onChanged: (v) =>
                          setState(() => _hCompanyName = v)),
                  _Toggle(
                      label: 'Calibrate',
                      value: _hCalibrate,
                      onChanged: (v) =>
                          setState(() => _hCalibrate = v)),
                  _Toggle(
                      label: 'Report Gen',
                      value: _hReportGen,
                      onChanged: (v) =>
                          setState(() => _hReportGen = v)),
                  _Toggle(
                      label: 'Device ID',
                      value: _hDeviceId,
                      onChanged: (v) =>
                          setState(() => _hDeviceId = v)),
                ],
              ),
              const SizedBox(height: 20),
              // Footer section
              Text('Footer',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _fTextNameController,
                decoration: const InputDecoration(labelText: 'Footer Text'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fTextPosController,
                      decoration: const InputDecoration(labelText: 'Position'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _fTextSizeController,
                      decoration: const InputDecoration(labelText: 'Font Size'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _fTextFontController,
                      decoration: const InputDecoration(labelText: 'Font'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: _loading ? null : _handleSave,
          child: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Save'),
        ),
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

/// Edit Header & Footer dialog
class _EditHeaderFooterDialog extends StatefulWidget {
  final HeaderFooter item;
  final VoidCallback onUpdated;

  const _EditHeaderFooterDialog(
      {required this.item, required this.onUpdated});

  @override
  State<_EditHeaderFooterDialog> createState() =>
      _EditHeaderFooterDialogState();
}

class _EditHeaderFooterDialogState
    extends State<_EditHeaderFooterDialog> {
  final _db = AppDatabase.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _hTextNameController;
  late final TextEditingController _fTextNameController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _hTextNameController =
        TextEditingController(text: widget.item.hTextName ?? '');
    _fTextNameController =
        TextEditingController(text: widget.item.fTextName ?? '');
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      await _db.updateHeaderFooter(
        widget.item.id,
        HeaderFootersCompanion(
          name: Value(_nameController.text.trim()),
          hTextName: Value(_hTextNameController.text),
          fTextName: Value(_fTextNameController.text),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Template updated'),
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
  void dispose() {
    _nameController.dispose();
    _hTextNameController.dispose();
    _fTextNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Template'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Template Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _hTextNameController,
            decoration: const InputDecoration(labelText: 'Header Text'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fTextNameController,
            decoration: const InputDecoration(labelText: 'Footer Text'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: _loading ? null : _handleSave,
          child: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Save'),
        ),
      ],
    );
  }
}
