import 'package:drift/drift.dart';

/// Users table - replaces MongoDB User model
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().withLength(min: 1, max: 200).unique()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text().withDefault(const Constant('user'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sessionDuration => integer().withDefault(const Constant(30))(); // minutes
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Devices table - replaces MongoDB Device model
class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text().unique()(); // e.g. "EPT001"
  TextColumn get type => text()(); // "ph" or "ec"
  TextColumn get mode => text().withDefault(const Constant('5'))(); // "3" or "5" for PH, "1"/"2"/"3" for EC
  BoolColumn get calibrate => boolean().withDefault(const Constant(false))();
  BoolColumn get log => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Device configs - replaces MongoDB DeviceConfig model
class DeviceConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deviceId =>
      integer().references(Devices, #id)();
  TextColumn get mode => text()();
  TextColumn get probe => text().nullable()();
  RealColumn get minPh => real().nullable()();
  RealColumn get maxPh => real().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Calibration rows - replaces DeviceConfig.rows array
class CalibrationRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get configId =>
      integer().references(DeviceConfigs, #id)();
  RealColumn get val => real()();
  RealColumn get valAfterCal => real().nullable()();
  RealColumn get slope => real().nullable()();
  RealColumn get temp => real().nullable()();
  RealColumn get mv => real().nullable()();
  RealColumn get minMv => real().nullable()();
  RealColumn get maxMv => real().nullable()();
  DateTimeColumn get time => dateTime().nullable()();
}

/// Sensor logs - replaces MongoDB Log model
class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deviceId =>
      integer().references(Devices, #id)();
  RealColumn get val => real()();
  RealColumn get temp => real()();
  TextColumn get product => text().nullable()();
  TextColumn get batchNo => text().nullable()();
  TextColumn get arNo => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Header and footer templates
class HeaderFooters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get selected =>
      boolean().withDefault(const Constant(false))();
  // Header fields
  TextColumn get hTextName => text().nullable()();
  TextColumn get hTextPosition => text().nullable()();
  TextColumn get hTextSize => text().nullable()();
  TextColumn get hTextFont => text().nullable()();
  TextColumn get hImagePath => text().nullable()();
  RealColumn get hWidth => real().nullable()();
  RealColumn get hHeight => real().nullable()();
  TextColumn get hImagePos => text().nullable()();
  BoolColumn get hCompanyName =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hCalibrate =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hReportGen =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get hDeviceId =>
      boolean().withDefault(const Constant(false))();
  // Footer fields
  TextColumn get fTextName => text().nullable()();
  TextColumn get fTextPosition => text().nullable()();
  TextColumn get fTextSize => text().nullable()();
  TextColumn get fTextFont => text().nullable()();
  TextColumn get fImagePath => text().nullable()();
  RealColumn get fWidth => real().nullable()();
  RealColumn get fHeight => real().nullable()();
  TextColumn get fImagePos => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Company details — singleton configuration for reports
class CompanyDetails extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get companyName => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get website => text().withDefault(const Constant(''))();
  TextColumn get gstNo => text().withDefault(const Constant(''))();
  TextColumn get logoPath => text().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
