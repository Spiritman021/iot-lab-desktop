import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  Devices,
  DeviceConfigs,
  CalibrationRows,
  Logs,
  HeaderFooters,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // Add mode column to devices table (default '5')
            await customStatement(
                "ALTER TABLE devices ADD COLUMN mode TEXT NOT NULL DEFAULT '5'");
          }
        },
      );

  // ── User Operations ──

  Future<List<User>> getAllUsers() => select(users).get();

  Future<List<User>> getUsers({int page = 1, int limit = 25}) {
    return (select(users)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit, offset: (page - 1) * limit))
        .get();
  }

  Future<int> getUserCount() async {
    final count = countAll();
    final query = selectOnly(users)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<User?> getUserById(int id) {
    return (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<User?> getUserByEmail(String email) {
    return (select(users)..where((t) => t.email.equals(email)))
        .getSingleOrNull();
  }

  Future<User?> getSuperuser() {
    return (select(users)..where((t) => t.role.equals('superuser')))
        .getSingleOrNull();
  }

  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updateUser(int id, UsersCompanion user) {
    return (update(users)..where((t) => t.id.equals(id)))
        .write(user)
        .then((rows) => rows > 0);
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((t) => t.id.equals(id))).go();
  }

  // ── Device Operations ──

  Future<List<Device>> getAllDevices() => select(devices).get();

  Future<List<Device>> getDevices({int page = 1, int limit = 25}) {
    return (select(devices)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit, offset: (page - 1) * limit))
        .get();
  }

  Future<int> getDeviceCount() async {
    final count = countAll();
    final query = selectOnly(devices)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<Device?> getDeviceByDeviceId(String deviceId) {
    return (select(devices)..where((t) => t.deviceId.equals(deviceId)))
        .getSingleOrNull();
  }

  Future<Device?> getDeviceById(int id) {
    return (select(devices)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertDevice(DevicesCompanion device) {
    return into(devices).insert(device);
  }

  Future<bool> updateDevice(int id, DevicesCompanion device) {
    return (update(devices)..where((t) => t.id.equals(id)))
        .write(device)
        .then((rows) => rows > 0);
  }

  Future<int> deleteDevice(int id) {
    return (delete(devices)..where((t) => t.id.equals(id))).go();
  }

  // ── Device Config Operations ──

  Future<DeviceConfig?> getConfigForDevice(int deviceId) {
    return (select(deviceConfigs)
          ..where((t) => t.deviceId.equals(deviceId)))
        .getSingleOrNull();
  }

  Future<int> insertDeviceConfig(DeviceConfigsCompanion config) {
    return into(deviceConfigs).insert(config);
  }

  Future<bool> updateDeviceConfig(int id, DeviceConfigsCompanion config) {
    return (update(deviceConfigs)..where((t) => t.id.equals(id)))
        .write(config)
        .then((rows) => rows > 0);
  }

  // ── Calibration Row Operations ──

  Future<List<CalibrationRow>> getCalibrationRows(int configId) {
    return (select(calibrationRows)
          ..where((t) => t.configId.equals(configId)))
        .get();
  }

  Future<int> insertCalibrationRow(CalibrationRowsCompanion row) {
    return into(calibrationRows).insert(row);
  }

  Future<bool> updateCalibrationRow(int id, CalibrationRowsCompanion row) {
    return (update(calibrationRows)..where((t) => t.id.equals(id)))
        .write(row)
        .then((rows) => rows > 0);
  }

  Future<int> deleteCalibrationRowsForConfig(int configId) {
    return (delete(calibrationRows)
          ..where((t) => t.configId.equals(configId)))
        .go();
  }

  // ── Log Operations ──

  Future<List<Log>> getLogsForDevice(int deviceId) {
    return (select(logs)
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<int> insertLog(LogsCompanion log) {
    return into(logs).insert(log);
  }

  Future<int> deleteLogsForDevice(int deviceId) {
    return (delete(logs)..where((t) => t.deviceId.equals(deviceId))).go();
  }

  // ── Header & Footer Operations ──

  Future<List<HeaderFooter>> getAllHeaderFooters() =>
      select(headerFooters).get();

  Future<List<HeaderFooter>> getHeaderFooters({int page = 1, int limit = 25}) {
    return (select(headerFooters)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit, offset: (page - 1) * limit))
        .get();
  }

  Future<int> getHeaderFooterCount() async {
    final count = countAll();
    final query = selectOnly(headerFooters)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<HeaderFooter?> getHeaderFooterById(int id) {
    return (select(headerFooters)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<HeaderFooter?> getSelectedHeaderFooter() {
    return (select(headerFooters)..where((t) => t.selected.equals(true)))
        .getSingleOrNull();
  }

  Future<int> insertHeaderFooter(HeaderFootersCompanion hf) {
    return into(headerFooters).insert(hf);
  }

  Future<bool> updateHeaderFooter(int id, HeaderFootersCompanion hf) {
    return (update(headerFooters)..where((t) => t.id.equals(id)))
        .write(hf)
        .then((rows) => rows > 0);
  }

  Future<void> selectHeaderFooter(int id) async {
    // Deselect all
    await (update(headerFooters))
        .write(const HeaderFootersCompanion(selected: Value(false)));
    // Select the one
    await (update(headerFooters)..where((t) => t.id.equals(id)))
        .write(const HeaderFootersCompanion(selected: Value(true)));
  }

  Future<int> deleteHeaderFooter(int id) {
    return (delete(headerFooters)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'iot_lab.db'));
    return NativeDatabase.createInBackground(file);
  });
}
