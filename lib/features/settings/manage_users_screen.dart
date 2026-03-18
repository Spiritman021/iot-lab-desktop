import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/auth/password_validator.dart';
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
      await AuditService.instance.log(
        category: AuditService.catUser,
        action: 'delete',
        entityType: 'user',
        entityId: user.id.toString(),
        details: {'email': user.email, 'name': user.name},
      );
      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User deleted'), backgroundColor: Colors.green),
        );
      }
    }
  }
  Future<void> _toggleUserStatus(User user) async {
    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null) return;

    // Prevent self-deactivation
    if (user.id == currentUser.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot deactivate your own account'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newStatus = !user.isActive;
    final action = newStatus ? 'activate' : 'deactivate';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} User'),
        content: Text(
            'Are you sure you want to $action "${user.name}"?${!newStatus ? '\nThey will no longer be able to log in.' : ''}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: newStatus ? Colors.green : Colors.orange,
              ),
              child: Text(action[0].toUpperCase() + action.substring(1))),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.updateUser(
        user.id,
        UsersCompanion(
          isActive: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await AuditService.instance.log(
        category: AuditService.catUser,
        action: newStatus ? 'activate' : 'deactivate',
        entityType: 'user',
        entityId: user.id.toString(),
        details: {'email': user.email, 'name': user.name},
      );
      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${newStatus ? 'activated' : 'deactivated'}'),
            backgroundColor: newStatus ? Colors.green : Colors.orange,
          ),
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

  void _resetUserPassword(User user) {
    showDialog(
      context: context,
      builder: (ctx) =>
          _ResetPasswordDialog(user: user, onUpdated: _loadUsers),
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
                                DataColumn(label: Text('Status')),
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
                                    Chip(
                                      label: Text(
                                        user.isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: user.isActive
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                        ),
                                      ),
                                      backgroundColor: user.isActive
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.1),
                                      side: BorderSide.none,
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
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
                                          icon: Icon(LucideIcons.keyRound,
                                              size: 16,
                                              color: Colors.blue.shade600),
                                          tooltip: 'Reset Password',
                                          onPressed: () =>
                                              _resetUserPassword(user),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              user.isActive
                                                  ? LucideIcons.userX
                                                  : LucideIcons.userCheck,
                                              size: 16,
                                              color: user.isActive
                                                  ? Colors.orange.shade600
                                                  : Colors.green.shade600),
                                          tooltip: user.isActive
                                              ? 'Deactivate'
                                              : 'Activate',
                                          onPressed: () =>
                                              _toggleUserStatus(user),
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
  int _selectedDuration = 30;
  int _selectedExpiryDays = 90;
  bool _loading = false;
  bool _obscurePassword = true;

  static const List<int> _durationOptions = [1, 2, 5, 10, 15, 20, 30, 45, 60];
  static const List<int> _expiryOptions = [0, 30, 60, 90, 120, 180, 365];

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
        sessionDuration: _selectedDuration,
        passwordExpiryDays: _selectedExpiryDays,
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
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                return PasswordValidator.validate(v);
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 4),
            // Password requirements
            ...PasswordValidator.getRequirements(_passwordController.text)
                .map((req) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        children: [
                          Icon(
                            req.met
                                ? LucideIcons.checkCircle2
                                : LucideIcons.circle,
                            size: 12,
                            color: req.met ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(req.label,
                              style: TextStyle(
                                fontSize: 10,
                                color: req.met ? Colors.green : Colors.grey,
                              )),
                        ],
                      ),
                    )),
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
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _selectedDuration,
              decoration: const InputDecoration(labelText: 'Session Timeout'),
              items: _durationOptions
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text('$d min${d > 1 ? 's' : ''}'),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedDuration = v);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _selectedExpiryDays,
              decoration: const InputDecoration(labelText: 'Password Expiry'),
              items: _expiryOptions
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d == 0 ? 'Never' : '$d days'),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedExpiryDays = v);
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
  late int _selectedDuration;
  late int _selectedExpiryDays;
  bool _loading = false;

  static const List<int> _durationOptions = [1, 2, 5, 10, 15, 20, 30, 45, 60];
  static const List<int> _expiryOptions = [0, 30, 60, 90, 120, 180, 365];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedRole = widget.user.role;
    _selectedDuration = widget.user.sessionDuration;
    _selectedExpiryDays = widget.user.passwordExpiryDays;
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
          sessionDuration: Value(_selectedDuration),
          passwordExpiryDays: Value(_selectedExpiryDays),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await AuditService.instance.log(
        category: AuditService.catUser,
        action: 'update',
        entityType: 'user',
        entityId: widget.user.id.toString(),
        details: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _selectedRole,
        },
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
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _selectedDuration,
            decoration: const InputDecoration(labelText: 'Session Timeout'),
            items: _durationOptions
                .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text('$d min${d > 1 ? 's' : ''}'),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedDuration = v);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _selectedExpiryDays,
            decoration: const InputDecoration(labelText: 'Password Expiry'),
            items: _expiryOptions
                .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(d == 0 ? 'Never' : '$d days'),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedExpiryDays = v);
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

class _ResetPasswordDialog extends StatefulWidget {
  final User user;
  final VoidCallback onUpdated;

  const _ResetPasswordDialog({
    required this.user,
    required this.onUpdated,
  });

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthService.instance.adminResetPassword(
        targetUserId: widget.user.id,
        newPassword: _newPasswordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset for ${widget.user.name}'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUpdated();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final requirements =
        PasswordValidator.getRequirements(_newPasswordController.text);

    return AlertDialog(
      title: Text('Reset Password: ${widget.user.name}'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Only admins can reset passwords. The user will need this new password for the next login.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureNew ? LucideIcons.eyeOff : LucideIcons.eye),
                    onPressed: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  return PasswordValidator.validate(v);
                },
              ),
              const SizedBox(height: 8),
              ...requirements.map((req) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      children: [
                        Icon(
                          req.met
                              ? LucideIcons.checkCircle2
                              : LucideIcons.circle,
                          size: 12,
                          color: req.met ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          req.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: req.met ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? LucideIcons.eyeOff
                        : LucideIcons.eye),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _handleReset,
          icon: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(LucideIcons.keyRound, size: 16),
          label: const Text('Reset Password'),
        ),
      ],
    );
  }
}
