import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/auth/auth_service.dart';
import '../../core/constants.dart';
import '../../core/database/app_database.dart';

/// Manage Users screen — shows all users with create/edit/delete actions.
/// Role options are Admin, Lab Tech, Viewer.
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final AppDatabase _db = AppDatabase.instance;
  List<User> _users = [];
  int _totalCount = 0;
  int _page = 1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final users = await _db.getUsers(page: _page, limit: paginationLimit);
      final count = await _db.getUserCount();
      if (mounted) {
        setState(() {
          _users = users;
          _totalCount = count;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _totalPages => (_totalCount / paginationLimit).ceil().clamp(1, 999);

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _CreateUserDialog(onCreated: _loadUsers),
    );
  }

  Future<void> _deleteUser(User user) async {
    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null) return;

    // Prevent deleting yourself
    if (user.id == currentUser.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot delete your own account'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Only admin can delete
    if (!AuthService.canMutate(user.role, currentUser.role)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to delete users'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.name}"?'),
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
      await _db.deleteUser(user.id);
      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User deleted'), backgroundColor: Colors.green),
        );
      }
    }
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (ctx) =>
          _EditUserDialog(user: user, onUpdated: _loadUsers),
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
                'Manage Users',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              FilledButton.icon(
                onPressed: _showCreateUserDialog,
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
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Role')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _users.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final user = entry.value;
                                return DataRow(cells: [
                                  DataCell(Text(
                                      '${(_page - 1) * paginationLimit + idx + 1}')),
                                  DataCell(Text(user.name)),
                                  DataCell(Text(user.email)),
                                  DataCell(Text(
                                      UserRoles.displayName(user.role))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(LucideIcons.pencil,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          tooltip: 'Edit',
                                          onPressed: () => _editUser(user),
                                        ),
                                        IconButton(
                                          icon: Icon(LucideIcons.trash2,
                                              size: 16,
                                              color: Colors.red.shade600),
                                          tooltip: 'Delete',
                                          onPressed: () => _deleteUser(user),
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
                      // Pagination
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Page: $_page of $_totalPages',
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              'Rows: ${(_page - 1) * paginationLimit + 1} - ${((_page - 1) * paginationLimit + _users.length).clamp(0, _totalCount)} of $_totalCount',
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
                                          _loadUsers();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronLeft,
                                      size: 16),
                                  onPressed: _page > 1
                                      ? () {
                                          setState(() => _page--);
                                          _loadUsers();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(() => _page++);
                                          _loadUsers();
                                        }
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.chevronsRight,
                                      size: 16),
                                  onPressed: _page < _totalPages
                                      ? () {
                                          setState(() => _page = _totalPages);
                                          _loadUsers();
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

/// Create User dialog — role dropdown with Admin / Lab Tech / Viewer
class _CreateUserDialog extends StatefulWidget {
  final VoidCallback onCreated;

  const _CreateUserDialog({required this.onCreated});

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = UserRoles.labtech;
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final authService = AuthService.instance;
      await authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User created'), backgroundColor: Colors.green),
        );
        widget.onCreated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red),
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: (v) => v == null || v.length < 6
                  ? 'Min 6 characters'
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: UserRoles.all
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(UserRoles.displayName(r)),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedRole = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _loading ? null : _handleSave,
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(LucideIcons.save, size: 16),
          label: const Text('Save'),
        ),
      ],
    );
  }
}

/// Edit User dialog — allows changing name, email, role
class _EditUserDialog extends StatefulWidget {
  final User user;
  final VoidCallback onUpdated;

  const _EditUserDialog({required this.user, required this.onUpdated});

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  final _db = AppDatabase.instance;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _selectedRole;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role;
  }

  Future<void> _handleSave() async {
    setState(() => _loading = true);
    try {
      await _db.updateUser(
        widget.user.id,
        UsersCompanion(
          name: Value(_nameController.text.trim()),
          email: Value(_emailController.text.trim()),
          role: Value(_selectedRole),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User updated'), backgroundColor: Colors.green),
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedRole,
            decoration: const InputDecoration(labelText: 'Role'),
            items: UserRoles.all
                .map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(UserRoles.displayName(r)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedRole = v);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _loading ? null : _handleSave,
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(LucideIcons.save, size: 16),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
