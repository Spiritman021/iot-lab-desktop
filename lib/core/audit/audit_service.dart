import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'audit_context.dart';

class AuditService {
  AuditService._();

  static final AuditService instance = AuditService._();
  final AppDatabase _db = AppDatabase.instance;

  static const String catAuth = 'auth';
  static const String catUser = 'user';
  static const String catDevice = 'device';
  static const String catCalibration = 'calibration';
  static const String catReport = 'report';
  static const String catFile = 'file';
  static const String catSettings = 'settings';

  Future<void> log({
    required String category,
    required String action,
    String entityType = '',
    String entityId = '',
    String status = 'success',
    Map<String, Object?> details = const {},
  }) async {
    final actor = AuditContext.currentActor;
    final payload = jsonEncode(details);
    final previous = await _db.getLastAuditLog();
    final chainSource = [
      previous?.integrityHash ?? 'root',
      category,
      action,
      actor?.userId.toString() ?? '',
      actor?.userName ?? 'system',
      entityType,
      entityId,
      status,
      payload,
      DateTime.now().toUtc().toIso8601String(),
    ].join('|');

    final integrityHash = sha256.convert(utf8.encode(chainSource)).toString();

    await _db.insertAuditLog(
      AuditLogsCompanion.insert(
        category: category,
        action: action,
        userId: actor == null ? const Value.absent() : Value(actor.userId),
        userName: Value(actor?.userName ?? 'system'),
        entityType: Value(entityType),
        entityId: Value(entityId),
        status: Value(status),
        details: Value(payload),
        integrityHash: Value(integrityHash),
      ),
    );
  }
}
