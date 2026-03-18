import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/auth/auth_service.dart';
import '../../core/auth/password_validator.dart';

/// Reusable Change Password Dialog.
/// Can be used standalone or forced on expired password.
class ChangePasswordDialog extends StatefulWidget {
  final bool isForced; // true = password expired, cannot dismiss

  const ChangePasswordDialog({super.key, this.isForced = false});

  /// Show as dialog. Returns true if password was changed.
  static Future<bool?> show(BuildContext context, {bool isForced = false}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isForced,
      builder: (_) => ChangePasswordDialog(isForced: isForced),
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _loading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) throw Exception('Not logged in');

      await AuthService.instance.changePassword(
        userId: user.id,
        currentPassword: _currentPwController.text,
        newPassword: _newPwController.text,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final requirements = PasswordValidator.getRequirements(
      _newPwController.text,
    );

    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.lock, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(widget.isForced ? 'Password Expired' : 'Change Password'),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isForced)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.alertTriangle,
                            color: Colors.orange.shade700, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your password has expired. Please set a new password to continue.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Current password
                TextFormField(
                  controller: _currentPwController,
                  obscureText: _obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrent
                          ? LucideIcons.eyeOff
                          : LucideIcons.eye, size: 18),
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // New password
                TextFormField(
                  controller: _newPwController,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew
                          ? LucideIcons.eyeOff
                          : LucideIcons.eye, size: 18),
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

                // Password requirements checklist
                ...requirements.map((req) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        children: [
                          Icon(
                            req.met
                                ? LucideIcons.checkCircle2
                                : LucideIcons.circle,
                            size: 14,
                            color: req.met ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            req.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: req.met ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 16),

                // Confirm password
                TextFormField(
                  controller: _confirmPwController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(LucideIcons.shieldCheck, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? LucideIcons.eyeOff
                          : LucideIcons.eye, size: 18),
                      onPressed: () => setState(
                          () => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v != _newPwController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.alertCircle,
                            color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (!widget.isForced)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        FilledButton(
          onPressed: _loading ? null : _handleSubmit,
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Change Password'),
        ),
      ],
    );
  }
}
