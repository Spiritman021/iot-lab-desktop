// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sessionDurationMeta = const VerificationMeta(
    'sessionDuration',
  );
  @override
  late final GeneratedColumn<int> sessionDuration = GeneratedColumn<int>(
    'session_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _passwordChangedAtMeta = const VerificationMeta(
    'passwordChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> passwordChangedAt =
      GeneratedColumn<DateTime>(
        'password_changed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _passwordExpiryDaysMeta =
      const VerificationMeta('passwordExpiryDays');
  @override
  late final GeneratedColumn<int> passwordExpiryDays = GeneratedColumn<int>(
    'password_expiry_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    passwordHash,
    role,
    isActive,
    sessionDuration,
    passwordChangedAt,
    passwordExpiryDays,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('session_duration')) {
      context.handle(
        _sessionDurationMeta,
        sessionDuration.isAcceptableOrUnknown(
          data['session_duration']!,
          _sessionDurationMeta,
        ),
      );
    }
    if (data.containsKey('password_changed_at')) {
      context.handle(
        _passwordChangedAtMeta,
        passwordChangedAt.isAcceptableOrUnknown(
          data['password_changed_at']!,
          _passwordChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('password_expiry_days')) {
      context.handle(
        _passwordExpiryDaysMeta,
        passwordExpiryDays.isAcceptableOrUnknown(
          data['password_expiry_days']!,
          _passwordExpiryDaysMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sessionDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_duration'],
      )!,
      passwordChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}password_changed_at'],
      )!,
      passwordExpiryDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}password_expiry_days'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final String role;
  final bool isActive;
  final int sessionDuration;
  final DateTime passwordChangedAt;
  final int passwordExpiryDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    required this.isActive,
    required this.sessionDuration,
    required this.passwordChangedAt,
    required this.passwordExpiryDays,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<bool>(isActive);
    map['session_duration'] = Variable<int>(sessionDuration);
    map['password_changed_at'] = Variable<DateTime>(passwordChangedAt);
    map['password_expiry_days'] = Variable<int>(passwordExpiryDays);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      role: Value(role),
      isActive: Value(isActive),
      sessionDuration: Value(sessionDuration),
      passwordChangedAt: Value(passwordChangedAt),
      passwordExpiryDays: Value(passwordExpiryDays),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sessionDuration: serializer.fromJson<int>(json['sessionDuration']),
      passwordChangedAt: serializer.fromJson<DateTime>(
        json['passwordChangedAt'],
      ),
      passwordExpiryDays: serializer.fromJson<int>(json['passwordExpiryDays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<bool>(isActive),
      'sessionDuration': serializer.toJson<int>(sessionDuration),
      'passwordChangedAt': serializer.toJson<DateTime>(passwordChangedAt),
      'passwordExpiryDays': serializer.toJson<int>(passwordExpiryDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? role,
    bool? isActive,
    int? sessionDuration,
    DateTime? passwordChangedAt,
    int? passwordExpiryDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    sessionDuration: sessionDuration ?? this.sessionDuration,
    passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
    passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sessionDuration: data.sessionDuration.present
          ? data.sessionDuration.value
          : this.sessionDuration,
      passwordChangedAt: data.passwordChangedAt.present
          ? data.passwordChangedAt.value
          : this.passwordChangedAt,
      passwordExpiryDays: data.passwordExpiryDays.present
          ? data.passwordExpiryDays.value
          : this.passwordExpiryDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('sessionDuration: $sessionDuration, ')
          ..write('passwordChangedAt: $passwordChangedAt, ')
          ..write('passwordExpiryDays: $passwordExpiryDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    passwordHash,
    role,
    isActive,
    sessionDuration,
    passwordChangedAt,
    passwordExpiryDays,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.sessionDuration == this.sessionDuration &&
          other.passwordChangedAt == this.passwordChangedAt &&
          other.passwordExpiryDays == this.passwordExpiryDays &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<bool> isActive;
  final Value<int> sessionDuration;
  final Value<DateTime> passwordChangedAt;
  final Value<int> passwordExpiryDays;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sessionDuration = const Value.absent(),
    this.passwordChangedAt = const Value.absent(),
    this.passwordExpiryDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String passwordHash,
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sessionDuration = const Value.absent(),
    this.passwordChangedAt = const Value.absent(),
    this.passwordExpiryDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       email = Value(email),
       passwordHash = Value(passwordHash);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<bool>? isActive,
    Expression<int>? sessionDuration,
    Expression<DateTime>? passwordChangedAt,
    Expression<int>? passwordExpiryDays,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (sessionDuration != null) 'session_duration': sessionDuration,
      if (passwordChangedAt != null) 'password_changed_at': passwordChangedAt,
      if (passwordExpiryDays != null)
        'password_expiry_days': passwordExpiryDays,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<String>? role,
    Value<bool>? isActive,
    Value<int>? sessionDuration,
    Value<DateTime>? passwordChangedAt,
    Value<int>? passwordExpiryDays,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sessionDuration.present) {
      map['session_duration'] = Variable<int>(sessionDuration.value);
    }
    if (passwordChangedAt.present) {
      map['password_changed_at'] = Variable<DateTime>(passwordChangedAt.value);
    }
    if (passwordExpiryDays.present) {
      map['password_expiry_days'] = Variable<int>(passwordExpiryDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('sessionDuration: $sessionDuration, ')
          ..write('passwordChangedAt: $passwordChangedAt, ')
          ..write('passwordExpiryDays: $passwordExpiryDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('5'),
  );
  static const VerificationMeta _calibrateMeta = const VerificationMeta(
    'calibrate',
  );
  @override
  late final GeneratedColumn<bool> calibrate = GeneratedColumn<bool>(
    'calibrate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calibrate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _logMeta = const VerificationMeta('log');
  @override
  late final GeneratedColumn<bool> log = GeneratedColumn<bool>(
    'log',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("log" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    type,
    mode,
    calibrate,
    log,
    status,
    lastUpdated,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Device> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('calibrate')) {
      context.handle(
        _calibrateMeta,
        calibrate.isAcceptableOrUnknown(data['calibrate']!, _calibrateMeta),
      );
    }
    if (data.containsKey('log')) {
      context.handle(
        _logMeta,
        log.isAcceptableOrUnknown(data['log']!, _logMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      calibrate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calibrate'],
      )!,
      log: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}log'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String deviceId;
  final String type;
  final String mode;
  final bool calibrate;
  final bool log;
  final String? status;
  final DateTime? lastUpdated;
  final DateTime createdAt;
  const Device({
    required this.id,
    required this.deviceId,
    required this.type,
    required this.mode,
    required this.calibrate,
    required this.log,
    this.status,
    this.lastUpdated,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['type'] = Variable<String>(type);
    map['mode'] = Variable<String>(mode);
    map['calibrate'] = Variable<bool>(calibrate);
    map['log'] = Variable<bool>(log);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      type: Value(type),
      mode: Value(mode),
      calibrate: Value(calibrate),
      log: Value(log),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      createdAt: Value(createdAt),
    );
  }

  factory Device.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      type: serializer.fromJson<String>(json['type']),
      mode: serializer.fromJson<String>(json['mode']),
      calibrate: serializer.fromJson<bool>(json['calibrate']),
      log: serializer.fromJson<bool>(json['log']),
      status: serializer.fromJson<String?>(json['status']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'type': serializer.toJson<String>(type),
      'mode': serializer.toJson<String>(mode),
      'calibrate': serializer.toJson<bool>(calibrate),
      'log': serializer.toJson<bool>(log),
      'status': serializer.toJson<String?>(status),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Device copyWith({
    int? id,
    String? deviceId,
    String? type,
    String? mode,
    bool? calibrate,
    bool? log,
    Value<String?> status = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
    DateTime? createdAt,
  }) => Device(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    type: type ?? this.type,
    mode: mode ?? this.mode,
    calibrate: calibrate ?? this.calibrate,
    log: log ?? this.log,
    status: status.present ? status.value : this.status,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
    createdAt: createdAt ?? this.createdAt,
  );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      mode: data.mode.present ? data.mode.value : this.mode,
      calibrate: data.calibrate.present ? data.calibrate.value : this.calibrate,
      log: data.log.present ? data.log.value : this.log,
      status: data.status.present ? data.status.value : this.status,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('calibrate: $calibrate, ')
          ..write('log: $log, ')
          ..write('status: $status, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    type,
    mode,
    calibrate,
    log,
    status,
    lastUpdated,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.mode == this.mode &&
          other.calibrate == this.calibrate &&
          other.log == this.log &&
          other.status == this.status &&
          other.lastUpdated == this.lastUpdated &&
          other.createdAt == this.createdAt);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> type;
  final Value<String> mode;
  final Value<bool> calibrate;
  final Value<bool> log;
  final Value<String?> status;
  final Value<DateTime?> lastUpdated;
  final Value<DateTime> createdAt;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.mode = const Value.absent(),
    this.calibrate = const Value.absent(),
    this.log = const Value.absent(),
    this.status = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String type,
    this.mode = const Value.absent(),
    this.calibrate = const Value.absent(),
    this.log = const Value.absent(),
    this.status = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : deviceId = Value(deviceId),
       type = Value(type);
  static Insertable<Device> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<String>? mode,
    Expression<bool>? calibrate,
    Expression<bool>? log,
    Expression<String>? status,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (mode != null) 'mode': mode,
      if (calibrate != null) 'calibrate': calibrate,
      if (log != null) 'log': log,
      if (status != null) 'status': status,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? type,
    Value<String>? mode,
    Value<bool>? calibrate,
    Value<bool>? log,
    Value<String?>? status,
    Value<DateTime?>? lastUpdated,
    Value<DateTime>? createdAt,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      calibrate: calibrate ?? this.calibrate,
      log: log ?? this.log,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (calibrate.present) {
      map['calibrate'] = Variable<bool>(calibrate.value);
    }
    if (log.present) {
      map['log'] = Variable<bool>(log.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('calibrate: $calibrate, ')
          ..write('log: $log, ')
          ..write('status: $status, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DeviceConfigsTable extends DeviceConfigs
    with TableInfo<$DeviceConfigsTable, DeviceConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id)',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _probeMeta = const VerificationMeta('probe');
  @override
  late final GeneratedColumn<String> probe = GeneratedColumn<String>(
    'probe',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minPhMeta = const VerificationMeta('minPh');
  @override
  late final GeneratedColumn<double> minPh = GeneratedColumn<double>(
    'min_ph',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxPhMeta = const VerificationMeta('maxPh');
  @override
  late final GeneratedColumn<double> maxPh = GeneratedColumn<double>(
    'max_ph',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    mode,
    probe,
    minPh,
    maxPh,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('probe')) {
      context.handle(
        _probeMeta,
        probe.isAcceptableOrUnknown(data['probe']!, _probeMeta),
      );
    }
    if (data.containsKey('min_ph')) {
      context.handle(
        _minPhMeta,
        minPh.isAcceptableOrUnknown(data['min_ph']!, _minPhMeta),
      );
    }
    if (data.containsKey('max_ph')) {
      context.handle(
        _maxPhMeta,
        maxPh.isAcceptableOrUnknown(data['max_ph']!, _maxPhMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      probe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}probe'],
      ),
      minPh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_ph'],
      ),
      maxPh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_ph'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DeviceConfigsTable createAlias(String alias) {
    return $DeviceConfigsTable(attachedDatabase, alias);
  }
}

class DeviceConfig extends DataClass implements Insertable<DeviceConfig> {
  final int id;
  final int deviceId;
  final String mode;
  final String? probe;
  final double? minPh;
  final double? maxPh;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DeviceConfig({
    required this.id,
    required this.deviceId,
    required this.mode,
    this.probe,
    this.minPh,
    this.maxPh,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<int>(deviceId);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || probe != null) {
      map['probe'] = Variable<String>(probe);
    }
    if (!nullToAbsent || minPh != null) {
      map['min_ph'] = Variable<double>(minPh);
    }
    if (!nullToAbsent || maxPh != null) {
      map['max_ph'] = Variable<double>(maxPh);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeviceConfigsCompanion toCompanion(bool nullToAbsent) {
    return DeviceConfigsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      mode: Value(mode),
      probe: probe == null && nullToAbsent
          ? const Value.absent()
          : Value(probe),
      minPh: minPh == null && nullToAbsent
          ? const Value.absent()
          : Value(minPh),
      maxPh: maxPh == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPh),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceConfig(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      mode: serializer.fromJson<String>(json['mode']),
      probe: serializer.fromJson<String?>(json['probe']),
      minPh: serializer.fromJson<double?>(json['minPh']),
      maxPh: serializer.fromJson<double?>(json['maxPh']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<int>(deviceId),
      'mode': serializer.toJson<String>(mode),
      'probe': serializer.toJson<String?>(probe),
      'minPh': serializer.toJson<double?>(minPh),
      'maxPh': serializer.toJson<double?>(maxPh),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeviceConfig copyWith({
    int? id,
    int? deviceId,
    String? mode,
    Value<String?> probe = const Value.absent(),
    Value<double?> minPh = const Value.absent(),
    Value<double?> maxPh = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DeviceConfig(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    mode: mode ?? this.mode,
    probe: probe.present ? probe.value : this.probe,
    minPh: minPh.present ? minPh.value : this.minPh,
    maxPh: maxPh.present ? maxPh.value : this.maxPh,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeviceConfig copyWithCompanion(DeviceConfigsCompanion data) {
    return DeviceConfig(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      mode: data.mode.present ? data.mode.value : this.mode,
      probe: data.probe.present ? data.probe.value : this.probe,
      minPh: data.minPh.present ? data.minPh.value : this.minPh,
      maxPh: data.maxPh.present ? data.maxPh.value : this.maxPh,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceConfig(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('mode: $mode, ')
          ..write('probe: $probe, ')
          ..write('minPh: $minPh, ')
          ..write('maxPh: $maxPh, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    mode,
    probe,
    minPh,
    maxPh,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceConfig &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.mode == this.mode &&
          other.probe == this.probe &&
          other.minPh == this.minPh &&
          other.maxPh == this.maxPh &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeviceConfigsCompanion extends UpdateCompanion<DeviceConfig> {
  final Value<int> id;
  final Value<int> deviceId;
  final Value<String> mode;
  final Value<String?> probe;
  final Value<double?> minPh;
  final Value<double?> maxPh;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DeviceConfigsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.mode = const Value.absent(),
    this.probe = const Value.absent(),
    this.minPh = const Value.absent(),
    this.maxPh = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DeviceConfigsCompanion.insert({
    this.id = const Value.absent(),
    required int deviceId,
    required String mode,
    this.probe = const Value.absent(),
    this.minPh = const Value.absent(),
    this.maxPh = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : deviceId = Value(deviceId),
       mode = Value(mode);
  static Insertable<DeviceConfig> custom({
    Expression<int>? id,
    Expression<int>? deviceId,
    Expression<String>? mode,
    Expression<String>? probe,
    Expression<double>? minPh,
    Expression<double>? maxPh,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (mode != null) 'mode': mode,
      if (probe != null) 'probe': probe,
      if (minPh != null) 'min_ph': minPh,
      if (maxPh != null) 'max_ph': maxPh,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DeviceConfigsCompanion copyWith({
    Value<int>? id,
    Value<int>? deviceId,
    Value<String>? mode,
    Value<String?>? probe,
    Value<double?>? minPh,
    Value<double?>? maxPh,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DeviceConfigsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      mode: mode ?? this.mode,
      probe: probe ?? this.probe,
      minPh: minPh ?? this.minPh,
      maxPh: maxPh ?? this.maxPh,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (probe.present) {
      map['probe'] = Variable<String>(probe.value);
    }
    if (minPh.present) {
      map['min_ph'] = Variable<double>(minPh.value);
    }
    if (maxPh.present) {
      map['max_ph'] = Variable<double>(maxPh.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceConfigsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('mode: $mode, ')
          ..write('probe: $probe, ')
          ..write('minPh: $minPh, ')
          ..write('maxPh: $maxPh, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CalibrationRowsTable extends CalibrationRows
    with TableInfo<$CalibrationRowsTable, CalibrationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _configIdMeta = const VerificationMeta(
    'configId',
  );
  @override
  late final GeneratedColumn<int> configId = GeneratedColumn<int>(
    'config_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES device_configs (id)',
    ),
  );
  static const VerificationMeta _valMeta = const VerificationMeta('val');
  @override
  late final GeneratedColumn<double> val = GeneratedColumn<double>(
    'val',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valAfterCalMeta = const VerificationMeta(
    'valAfterCal',
  );
  @override
  late final GeneratedColumn<double> valAfterCal = GeneratedColumn<double>(
    'val_after_cal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slopeMeta = const VerificationMeta('slope');
  @override
  late final GeneratedColumn<double> slope = GeneratedColumn<double>(
    'slope',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempMeta = const VerificationMeta('temp');
  @override
  late final GeneratedColumn<double> temp = GeneratedColumn<double>(
    'temp',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mvMeta = const VerificationMeta('mv');
  @override
  late final GeneratedColumn<double> mv = GeneratedColumn<double>(
    'mv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minMvMeta = const VerificationMeta('minMv');
  @override
  late final GeneratedColumn<double> minMv = GeneratedColumn<double>(
    'min_mv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxMvMeta = const VerificationMeta('maxMv');
  @override
  late final GeneratedColumn<double> maxMv = GeneratedColumn<double>(
    'max_mv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    configId,
    val,
    valAfterCal,
    slope,
    temp,
    mv,
    minMv,
    maxMv,
    time,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibration_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalibrationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('config_id')) {
      context.handle(
        _configIdMeta,
        configId.isAcceptableOrUnknown(data['config_id']!, _configIdMeta),
      );
    } else if (isInserting) {
      context.missing(_configIdMeta);
    }
    if (data.containsKey('val')) {
      context.handle(
        _valMeta,
        val.isAcceptableOrUnknown(data['val']!, _valMeta),
      );
    } else if (isInserting) {
      context.missing(_valMeta);
    }
    if (data.containsKey('val_after_cal')) {
      context.handle(
        _valAfterCalMeta,
        valAfterCal.isAcceptableOrUnknown(
          data['val_after_cal']!,
          _valAfterCalMeta,
        ),
      );
    }
    if (data.containsKey('slope')) {
      context.handle(
        _slopeMeta,
        slope.isAcceptableOrUnknown(data['slope']!, _slopeMeta),
      );
    }
    if (data.containsKey('temp')) {
      context.handle(
        _tempMeta,
        temp.isAcceptableOrUnknown(data['temp']!, _tempMeta),
      );
    }
    if (data.containsKey('mv')) {
      context.handle(_mvMeta, mv.isAcceptableOrUnknown(data['mv']!, _mvMeta));
    }
    if (data.containsKey('min_mv')) {
      context.handle(
        _minMvMeta,
        minMv.isAcceptableOrUnknown(data['min_mv']!, _minMvMeta),
      );
    }
    if (data.containsKey('max_mv')) {
      context.handle(
        _maxMvMeta,
        maxMv.isAcceptableOrUnknown(data['max_mv']!, _maxMvMeta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalibrationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      configId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}config_id'],
      )!,
      val: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}val'],
      )!,
      valAfterCal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}val_after_cal'],
      ),
      slope: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}slope'],
      ),
      temp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp'],
      ),
      mv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mv'],
      ),
      minMv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_mv'],
      ),
      maxMv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_mv'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      ),
    );
  }

  @override
  $CalibrationRowsTable createAlias(String alias) {
    return $CalibrationRowsTable(attachedDatabase, alias);
  }
}

class CalibrationRow extends DataClass implements Insertable<CalibrationRow> {
  final int id;
  final int configId;
  final double val;
  final double? valAfterCal;
  final double? slope;
  final double? temp;
  final double? mv;
  final double? minMv;
  final double? maxMv;
  final DateTime? time;
  const CalibrationRow({
    required this.id,
    required this.configId,
    required this.val,
    this.valAfterCal,
    this.slope,
    this.temp,
    this.mv,
    this.minMv,
    this.maxMv,
    this.time,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['config_id'] = Variable<int>(configId);
    map['val'] = Variable<double>(val);
    if (!nullToAbsent || valAfterCal != null) {
      map['val_after_cal'] = Variable<double>(valAfterCal);
    }
    if (!nullToAbsent || slope != null) {
      map['slope'] = Variable<double>(slope);
    }
    if (!nullToAbsent || temp != null) {
      map['temp'] = Variable<double>(temp);
    }
    if (!nullToAbsent || mv != null) {
      map['mv'] = Variable<double>(mv);
    }
    if (!nullToAbsent || minMv != null) {
      map['min_mv'] = Variable<double>(minMv);
    }
    if (!nullToAbsent || maxMv != null) {
      map['max_mv'] = Variable<double>(maxMv);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<DateTime>(time);
    }
    return map;
  }

  CalibrationRowsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationRowsCompanion(
      id: Value(id),
      configId: Value(configId),
      val: Value(val),
      valAfterCal: valAfterCal == null && nullToAbsent
          ? const Value.absent()
          : Value(valAfterCal),
      slope: slope == null && nullToAbsent
          ? const Value.absent()
          : Value(slope),
      temp: temp == null && nullToAbsent ? const Value.absent() : Value(temp),
      mv: mv == null && nullToAbsent ? const Value.absent() : Value(mv),
      minMv: minMv == null && nullToAbsent
          ? const Value.absent()
          : Value(minMv),
      maxMv: maxMv == null && nullToAbsent
          ? const Value.absent()
          : Value(maxMv),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory CalibrationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationRow(
      id: serializer.fromJson<int>(json['id']),
      configId: serializer.fromJson<int>(json['configId']),
      val: serializer.fromJson<double>(json['val']),
      valAfterCal: serializer.fromJson<double?>(json['valAfterCal']),
      slope: serializer.fromJson<double?>(json['slope']),
      temp: serializer.fromJson<double?>(json['temp']),
      mv: serializer.fromJson<double?>(json['mv']),
      minMv: serializer.fromJson<double?>(json['minMv']),
      maxMv: serializer.fromJson<double?>(json['maxMv']),
      time: serializer.fromJson<DateTime?>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'configId': serializer.toJson<int>(configId),
      'val': serializer.toJson<double>(val),
      'valAfterCal': serializer.toJson<double?>(valAfterCal),
      'slope': serializer.toJson<double?>(slope),
      'temp': serializer.toJson<double?>(temp),
      'mv': serializer.toJson<double?>(mv),
      'minMv': serializer.toJson<double?>(minMv),
      'maxMv': serializer.toJson<double?>(maxMv),
      'time': serializer.toJson<DateTime?>(time),
    };
  }

  CalibrationRow copyWith({
    int? id,
    int? configId,
    double? val,
    Value<double?> valAfterCal = const Value.absent(),
    Value<double?> slope = const Value.absent(),
    Value<double?> temp = const Value.absent(),
    Value<double?> mv = const Value.absent(),
    Value<double?> minMv = const Value.absent(),
    Value<double?> maxMv = const Value.absent(),
    Value<DateTime?> time = const Value.absent(),
  }) => CalibrationRow(
    id: id ?? this.id,
    configId: configId ?? this.configId,
    val: val ?? this.val,
    valAfterCal: valAfterCal.present ? valAfterCal.value : this.valAfterCal,
    slope: slope.present ? slope.value : this.slope,
    temp: temp.present ? temp.value : this.temp,
    mv: mv.present ? mv.value : this.mv,
    minMv: minMv.present ? minMv.value : this.minMv,
    maxMv: maxMv.present ? maxMv.value : this.maxMv,
    time: time.present ? time.value : this.time,
  );
  CalibrationRow copyWithCompanion(CalibrationRowsCompanion data) {
    return CalibrationRow(
      id: data.id.present ? data.id.value : this.id,
      configId: data.configId.present ? data.configId.value : this.configId,
      val: data.val.present ? data.val.value : this.val,
      valAfterCal: data.valAfterCal.present
          ? data.valAfterCal.value
          : this.valAfterCal,
      slope: data.slope.present ? data.slope.value : this.slope,
      temp: data.temp.present ? data.temp.value : this.temp,
      mv: data.mv.present ? data.mv.value : this.mv,
      minMv: data.minMv.present ? data.minMv.value : this.minMv,
      maxMv: data.maxMv.present ? data.maxMv.value : this.maxMv,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationRow(')
          ..write('id: $id, ')
          ..write('configId: $configId, ')
          ..write('val: $val, ')
          ..write('valAfterCal: $valAfterCal, ')
          ..write('slope: $slope, ')
          ..write('temp: $temp, ')
          ..write('mv: $mv, ')
          ..write('minMv: $minMv, ')
          ..write('maxMv: $maxMv, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    configId,
    val,
    valAfterCal,
    slope,
    temp,
    mv,
    minMv,
    maxMv,
    time,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationRow &&
          other.id == this.id &&
          other.configId == this.configId &&
          other.val == this.val &&
          other.valAfterCal == this.valAfterCal &&
          other.slope == this.slope &&
          other.temp == this.temp &&
          other.mv == this.mv &&
          other.minMv == this.minMv &&
          other.maxMv == this.maxMv &&
          other.time == this.time);
}

class CalibrationRowsCompanion extends UpdateCompanion<CalibrationRow> {
  final Value<int> id;
  final Value<int> configId;
  final Value<double> val;
  final Value<double?> valAfterCal;
  final Value<double?> slope;
  final Value<double?> temp;
  final Value<double?> mv;
  final Value<double?> minMv;
  final Value<double?> maxMv;
  final Value<DateTime?> time;
  const CalibrationRowsCompanion({
    this.id = const Value.absent(),
    this.configId = const Value.absent(),
    this.val = const Value.absent(),
    this.valAfterCal = const Value.absent(),
    this.slope = const Value.absent(),
    this.temp = const Value.absent(),
    this.mv = const Value.absent(),
    this.minMv = const Value.absent(),
    this.maxMv = const Value.absent(),
    this.time = const Value.absent(),
  });
  CalibrationRowsCompanion.insert({
    this.id = const Value.absent(),
    required int configId,
    required double val,
    this.valAfterCal = const Value.absent(),
    this.slope = const Value.absent(),
    this.temp = const Value.absent(),
    this.mv = const Value.absent(),
    this.minMv = const Value.absent(),
    this.maxMv = const Value.absent(),
    this.time = const Value.absent(),
  }) : configId = Value(configId),
       val = Value(val);
  static Insertable<CalibrationRow> custom({
    Expression<int>? id,
    Expression<int>? configId,
    Expression<double>? val,
    Expression<double>? valAfterCal,
    Expression<double>? slope,
    Expression<double>? temp,
    Expression<double>? mv,
    Expression<double>? minMv,
    Expression<double>? maxMv,
    Expression<DateTime>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (configId != null) 'config_id': configId,
      if (val != null) 'val': val,
      if (valAfterCal != null) 'val_after_cal': valAfterCal,
      if (slope != null) 'slope': slope,
      if (temp != null) 'temp': temp,
      if (mv != null) 'mv': mv,
      if (minMv != null) 'min_mv': minMv,
      if (maxMv != null) 'max_mv': maxMv,
      if (time != null) 'time': time,
    });
  }

  CalibrationRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? configId,
    Value<double>? val,
    Value<double?>? valAfterCal,
    Value<double?>? slope,
    Value<double?>? temp,
    Value<double?>? mv,
    Value<double?>? minMv,
    Value<double?>? maxMv,
    Value<DateTime?>? time,
  }) {
    return CalibrationRowsCompanion(
      id: id ?? this.id,
      configId: configId ?? this.configId,
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (configId.present) {
      map['config_id'] = Variable<int>(configId.value);
    }
    if (val.present) {
      map['val'] = Variable<double>(val.value);
    }
    if (valAfterCal.present) {
      map['val_after_cal'] = Variable<double>(valAfterCal.value);
    }
    if (slope.present) {
      map['slope'] = Variable<double>(slope.value);
    }
    if (temp.present) {
      map['temp'] = Variable<double>(temp.value);
    }
    if (mv.present) {
      map['mv'] = Variable<double>(mv.value);
    }
    if (minMv.present) {
      map['min_mv'] = Variable<double>(minMv.value);
    }
    if (maxMv.present) {
      map['max_mv'] = Variable<double>(maxMv.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationRowsCompanion(')
          ..write('id: $id, ')
          ..write('configId: $configId, ')
          ..write('val: $val, ')
          ..write('valAfterCal: $valAfterCal, ')
          ..write('slope: $slope, ')
          ..write('temp: $temp, ')
          ..write('mv: $mv, ')
          ..write('minMv: $minMv, ')
          ..write('maxMv: $maxMv, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class $LogsTable extends Logs with TableInfo<$LogsTable, Log> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id)',
    ),
  );
  static const VerificationMeta _valMeta = const VerificationMeta('val');
  @override
  late final GeneratedColumn<double> val = GeneratedColumn<double>(
    'val',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tempMeta = const VerificationMeta('temp');
  @override
  late final GeneratedColumn<double> temp = GeneratedColumn<double>(
    'temp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productMeta = const VerificationMeta(
    'product',
  );
  @override
  late final GeneratedColumn<String> product = GeneratedColumn<String>(
    'product',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchNoMeta = const VerificationMeta(
    'batchNo',
  );
  @override
  late final GeneratedColumn<String> batchNo = GeneratedColumn<String>(
    'batch_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arNoMeta = const VerificationMeta('arNo');
  @override
  late final GeneratedColumn<String> arNo = GeneratedColumn<String>(
    'ar_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    val,
    temp,
    product,
    batchNo,
    arNo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Log> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('val')) {
      context.handle(
        _valMeta,
        val.isAcceptableOrUnknown(data['val']!, _valMeta),
      );
    } else if (isInserting) {
      context.missing(_valMeta);
    }
    if (data.containsKey('temp')) {
      context.handle(
        _tempMeta,
        temp.isAcceptableOrUnknown(data['temp']!, _tempMeta),
      );
    } else if (isInserting) {
      context.missing(_tempMeta);
    }
    if (data.containsKey('product')) {
      context.handle(
        _productMeta,
        product.isAcceptableOrUnknown(data['product']!, _productMeta),
      );
    }
    if (data.containsKey('batch_no')) {
      context.handle(
        _batchNoMeta,
        batchNo.isAcceptableOrUnknown(data['batch_no']!, _batchNoMeta),
      );
    }
    if (data.containsKey('ar_no')) {
      context.handle(
        _arNoMeta,
        arNo.isAcceptableOrUnknown(data['ar_no']!, _arNoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Log map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Log(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}device_id'],
      )!,
      val: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}val'],
      )!,
      temp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp'],
      )!,
      product: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product'],
      ),
      batchNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_no'],
      ),
      arNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ar_no'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }
}

class Log extends DataClass implements Insertable<Log> {
  final int id;
  final int deviceId;
  final double val;
  final double temp;
  final String? product;
  final String? batchNo;
  final String? arNo;
  final DateTime createdAt;
  const Log({
    required this.id,
    required this.deviceId,
    required this.val,
    required this.temp,
    this.product,
    this.batchNo,
    this.arNo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<int>(deviceId);
    map['val'] = Variable<double>(val);
    map['temp'] = Variable<double>(temp);
    if (!nullToAbsent || product != null) {
      map['product'] = Variable<String>(product);
    }
    if (!nullToAbsent || batchNo != null) {
      map['batch_no'] = Variable<String>(batchNo);
    }
    if (!nullToAbsent || arNo != null) {
      map['ar_no'] = Variable<String>(arNo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LogsCompanion toCompanion(bool nullToAbsent) {
    return LogsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      val: Value(val),
      temp: Value(temp),
      product: product == null && nullToAbsent
          ? const Value.absent()
          : Value(product),
      batchNo: batchNo == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNo),
      arNo: arNo == null && nullToAbsent ? const Value.absent() : Value(arNo),
      createdAt: Value(createdAt),
    );
  }

  factory Log.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Log(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      val: serializer.fromJson<double>(json['val']),
      temp: serializer.fromJson<double>(json['temp']),
      product: serializer.fromJson<String?>(json['product']),
      batchNo: serializer.fromJson<String?>(json['batchNo']),
      arNo: serializer.fromJson<String?>(json['arNo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<int>(deviceId),
      'val': serializer.toJson<double>(val),
      'temp': serializer.toJson<double>(temp),
      'product': serializer.toJson<String?>(product),
      'batchNo': serializer.toJson<String?>(batchNo),
      'arNo': serializer.toJson<String?>(arNo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Log copyWith({
    int? id,
    int? deviceId,
    double? val,
    double? temp,
    Value<String?> product = const Value.absent(),
    Value<String?> batchNo = const Value.absent(),
    Value<String?> arNo = const Value.absent(),
    DateTime? createdAt,
  }) => Log(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    val: val ?? this.val,
    temp: temp ?? this.temp,
    product: product.present ? product.value : this.product,
    batchNo: batchNo.present ? batchNo.value : this.batchNo,
    arNo: arNo.present ? arNo.value : this.arNo,
    createdAt: createdAt ?? this.createdAt,
  );
  Log copyWithCompanion(LogsCompanion data) {
    return Log(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      val: data.val.present ? data.val.value : this.val,
      temp: data.temp.present ? data.temp.value : this.temp,
      product: data.product.present ? data.product.value : this.product,
      batchNo: data.batchNo.present ? data.batchNo.value : this.batchNo,
      arNo: data.arNo.present ? data.arNo.value : this.arNo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('val: $val, ')
          ..write('temp: $temp, ')
          ..write('product: $product, ')
          ..write('batchNo: $batchNo, ')
          ..write('arNo: $arNo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, val, temp, product, batchNo, arNo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.val == this.val &&
          other.temp == this.temp &&
          other.product == this.product &&
          other.batchNo == this.batchNo &&
          other.arNo == this.arNo &&
          other.createdAt == this.createdAt);
}

class LogsCompanion extends UpdateCompanion<Log> {
  final Value<int> id;
  final Value<int> deviceId;
  final Value<double> val;
  final Value<double> temp;
  final Value<String?> product;
  final Value<String?> batchNo;
  final Value<String?> arNo;
  final Value<DateTime> createdAt;
  const LogsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.val = const Value.absent(),
    this.temp = const Value.absent(),
    this.product = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.arNo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LogsCompanion.insert({
    this.id = const Value.absent(),
    required int deviceId,
    required double val,
    required double temp,
    this.product = const Value.absent(),
    this.batchNo = const Value.absent(),
    this.arNo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : deviceId = Value(deviceId),
       val = Value(val),
       temp = Value(temp);
  static Insertable<Log> custom({
    Expression<int>? id,
    Expression<int>? deviceId,
    Expression<double>? val,
    Expression<double>? temp,
    Expression<String>? product,
    Expression<String>? batchNo,
    Expression<String>? arNo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (val != null) 'val': val,
      if (temp != null) 'temp': temp,
      if (product != null) 'product': product,
      if (batchNo != null) 'batch_no': batchNo,
      if (arNo != null) 'ar_no': arNo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LogsCompanion copyWith({
    Value<int>? id,
    Value<int>? deviceId,
    Value<double>? val,
    Value<double>? temp,
    Value<String?>? product,
    Value<String?>? batchNo,
    Value<String?>? arNo,
    Value<DateTime>? createdAt,
  }) {
    return LogsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      val: val ?? this.val,
      temp: temp ?? this.temp,
      product: product ?? this.product,
      batchNo: batchNo ?? this.batchNo,
      arNo: arNo ?? this.arNo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (val.present) {
      map['val'] = Variable<double>(val.value);
    }
    if (temp.present) {
      map['temp'] = Variable<double>(temp.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value);
    }
    if (batchNo.present) {
      map['batch_no'] = Variable<String>(batchNo.value);
    }
    if (arNo.present) {
      map['ar_no'] = Variable<String>(arNo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('val: $val, ')
          ..write('temp: $temp, ')
          ..write('product: $product, ')
          ..write('batchNo: $batchNo, ')
          ..write('arNo: $arNo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HeaderFootersTable extends HeaderFooters
    with TableInfo<$HeaderFootersTable, HeaderFooter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeaderFootersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedMeta = const VerificationMeta(
    'selected',
  );
  @override
  late final GeneratedColumn<bool> selected = GeneratedColumn<bool>(
    'selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("selected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hTextNameMeta = const VerificationMeta(
    'hTextName',
  );
  @override
  late final GeneratedColumn<String> hTextName = GeneratedColumn<String>(
    'h_text_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hTextPositionMeta = const VerificationMeta(
    'hTextPosition',
  );
  @override
  late final GeneratedColumn<String> hTextPosition = GeneratedColumn<String>(
    'h_text_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hTextSizeMeta = const VerificationMeta(
    'hTextSize',
  );
  @override
  late final GeneratedColumn<String> hTextSize = GeneratedColumn<String>(
    'h_text_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hTextFontMeta = const VerificationMeta(
    'hTextFont',
  );
  @override
  late final GeneratedColumn<String> hTextFont = GeneratedColumn<String>(
    'h_text_font',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hImagePathMeta = const VerificationMeta(
    'hImagePath',
  );
  @override
  late final GeneratedColumn<String> hImagePath = GeneratedColumn<String>(
    'h_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hWidthMeta = const VerificationMeta('hWidth');
  @override
  late final GeneratedColumn<double> hWidth = GeneratedColumn<double>(
    'h_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hHeightMeta = const VerificationMeta(
    'hHeight',
  );
  @override
  late final GeneratedColumn<double> hHeight = GeneratedColumn<double>(
    'h_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hImagePosMeta = const VerificationMeta(
    'hImagePos',
  );
  @override
  late final GeneratedColumn<String> hImagePos = GeneratedColumn<String>(
    'h_image_pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hCompanyNameMeta = const VerificationMeta(
    'hCompanyName',
  );
  @override
  late final GeneratedColumn<bool> hCompanyName = GeneratedColumn<bool>(
    'h_company_name',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("h_company_name" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hCalibrateMeta = const VerificationMeta(
    'hCalibrate',
  );
  @override
  late final GeneratedColumn<bool> hCalibrate = GeneratedColumn<bool>(
    'h_calibrate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("h_calibrate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hReportGenMeta = const VerificationMeta(
    'hReportGen',
  );
  @override
  late final GeneratedColumn<bool> hReportGen = GeneratedColumn<bool>(
    'h_report_gen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("h_report_gen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hDeviceIdMeta = const VerificationMeta(
    'hDeviceId',
  );
  @override
  late final GeneratedColumn<bool> hDeviceId = GeneratedColumn<bool>(
    'h_device_id',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("h_device_id" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fTextNameMeta = const VerificationMeta(
    'fTextName',
  );
  @override
  late final GeneratedColumn<String> fTextName = GeneratedColumn<String>(
    'f_text_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fTextPositionMeta = const VerificationMeta(
    'fTextPosition',
  );
  @override
  late final GeneratedColumn<String> fTextPosition = GeneratedColumn<String>(
    'f_text_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fTextSizeMeta = const VerificationMeta(
    'fTextSize',
  );
  @override
  late final GeneratedColumn<String> fTextSize = GeneratedColumn<String>(
    'f_text_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fTextFontMeta = const VerificationMeta(
    'fTextFont',
  );
  @override
  late final GeneratedColumn<String> fTextFont = GeneratedColumn<String>(
    'f_text_font',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fImagePathMeta = const VerificationMeta(
    'fImagePath',
  );
  @override
  late final GeneratedColumn<String> fImagePath = GeneratedColumn<String>(
    'f_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fWidthMeta = const VerificationMeta('fWidth');
  @override
  late final GeneratedColumn<double> fWidth = GeneratedColumn<double>(
    'f_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fHeightMeta = const VerificationMeta(
    'fHeight',
  );
  @override
  late final GeneratedColumn<double> fHeight = GeneratedColumn<double>(
    'f_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fImagePosMeta = const VerificationMeta(
    'fImagePos',
  );
  @override
  late final GeneratedColumn<String> fImagePos = GeneratedColumn<String>(
    'f_image_pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    selected,
    hTextName,
    hTextPosition,
    hTextSize,
    hTextFont,
    hImagePath,
    hWidth,
    hHeight,
    hImagePos,
    hCompanyName,
    hCalibrate,
    hReportGen,
    hDeviceId,
    fTextName,
    fTextPosition,
    fTextSize,
    fTextFont,
    fImagePath,
    fWidth,
    fHeight,
    fImagePos,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'header_footers';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeaderFooter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('selected')) {
      context.handle(
        _selectedMeta,
        selected.isAcceptableOrUnknown(data['selected']!, _selectedMeta),
      );
    }
    if (data.containsKey('h_text_name')) {
      context.handle(
        _hTextNameMeta,
        hTextName.isAcceptableOrUnknown(data['h_text_name']!, _hTextNameMeta),
      );
    }
    if (data.containsKey('h_text_position')) {
      context.handle(
        _hTextPositionMeta,
        hTextPosition.isAcceptableOrUnknown(
          data['h_text_position']!,
          _hTextPositionMeta,
        ),
      );
    }
    if (data.containsKey('h_text_size')) {
      context.handle(
        _hTextSizeMeta,
        hTextSize.isAcceptableOrUnknown(data['h_text_size']!, _hTextSizeMeta),
      );
    }
    if (data.containsKey('h_text_font')) {
      context.handle(
        _hTextFontMeta,
        hTextFont.isAcceptableOrUnknown(data['h_text_font']!, _hTextFontMeta),
      );
    }
    if (data.containsKey('h_image_path')) {
      context.handle(
        _hImagePathMeta,
        hImagePath.isAcceptableOrUnknown(
          data['h_image_path']!,
          _hImagePathMeta,
        ),
      );
    }
    if (data.containsKey('h_width')) {
      context.handle(
        _hWidthMeta,
        hWidth.isAcceptableOrUnknown(data['h_width']!, _hWidthMeta),
      );
    }
    if (data.containsKey('h_height')) {
      context.handle(
        _hHeightMeta,
        hHeight.isAcceptableOrUnknown(data['h_height']!, _hHeightMeta),
      );
    }
    if (data.containsKey('h_image_pos')) {
      context.handle(
        _hImagePosMeta,
        hImagePos.isAcceptableOrUnknown(data['h_image_pos']!, _hImagePosMeta),
      );
    }
    if (data.containsKey('h_company_name')) {
      context.handle(
        _hCompanyNameMeta,
        hCompanyName.isAcceptableOrUnknown(
          data['h_company_name']!,
          _hCompanyNameMeta,
        ),
      );
    }
    if (data.containsKey('h_calibrate')) {
      context.handle(
        _hCalibrateMeta,
        hCalibrate.isAcceptableOrUnknown(data['h_calibrate']!, _hCalibrateMeta),
      );
    }
    if (data.containsKey('h_report_gen')) {
      context.handle(
        _hReportGenMeta,
        hReportGen.isAcceptableOrUnknown(
          data['h_report_gen']!,
          _hReportGenMeta,
        ),
      );
    }
    if (data.containsKey('h_device_id')) {
      context.handle(
        _hDeviceIdMeta,
        hDeviceId.isAcceptableOrUnknown(data['h_device_id']!, _hDeviceIdMeta),
      );
    }
    if (data.containsKey('f_text_name')) {
      context.handle(
        _fTextNameMeta,
        fTextName.isAcceptableOrUnknown(data['f_text_name']!, _fTextNameMeta),
      );
    }
    if (data.containsKey('f_text_position')) {
      context.handle(
        _fTextPositionMeta,
        fTextPosition.isAcceptableOrUnknown(
          data['f_text_position']!,
          _fTextPositionMeta,
        ),
      );
    }
    if (data.containsKey('f_text_size')) {
      context.handle(
        _fTextSizeMeta,
        fTextSize.isAcceptableOrUnknown(data['f_text_size']!, _fTextSizeMeta),
      );
    }
    if (data.containsKey('f_text_font')) {
      context.handle(
        _fTextFontMeta,
        fTextFont.isAcceptableOrUnknown(data['f_text_font']!, _fTextFontMeta),
      );
    }
    if (data.containsKey('f_image_path')) {
      context.handle(
        _fImagePathMeta,
        fImagePath.isAcceptableOrUnknown(
          data['f_image_path']!,
          _fImagePathMeta,
        ),
      );
    }
    if (data.containsKey('f_width')) {
      context.handle(
        _fWidthMeta,
        fWidth.isAcceptableOrUnknown(data['f_width']!, _fWidthMeta),
      );
    }
    if (data.containsKey('f_height')) {
      context.handle(
        _fHeightMeta,
        fHeight.isAcceptableOrUnknown(data['f_height']!, _fHeightMeta),
      );
    }
    if (data.containsKey('f_image_pos')) {
      context.handle(
        _fImagePosMeta,
        fImagePos.isAcceptableOrUnknown(data['f_image_pos']!, _fImagePosMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeaderFooter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeaderFooter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      selected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}selected'],
      )!,
      hTextName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_text_name'],
      ),
      hTextPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_text_position'],
      ),
      hTextSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_text_size'],
      ),
      hTextFont: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_text_font'],
      ),
      hImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_image_path'],
      ),
      hWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}h_width'],
      ),
      hHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}h_height'],
      ),
      hImagePos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}h_image_pos'],
      ),
      hCompanyName: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}h_company_name'],
      )!,
      hCalibrate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}h_calibrate'],
      )!,
      hReportGen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}h_report_gen'],
      )!,
      hDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}h_device_id'],
      )!,
      fTextName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_text_name'],
      ),
      fTextPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_text_position'],
      ),
      fTextSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_text_size'],
      ),
      fTextFont: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_text_font'],
      ),
      fImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_image_path'],
      ),
      fWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}f_width'],
      ),
      fHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}f_height'],
      ),
      fImagePos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}f_image_pos'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HeaderFootersTable createAlias(String alias) {
    return $HeaderFootersTable(attachedDatabase, alias);
  }
}

class HeaderFooter extends DataClass implements Insertable<HeaderFooter> {
  final int id;
  final String name;
  final bool selected;
  final String? hTextName;
  final String? hTextPosition;
  final String? hTextSize;
  final String? hTextFont;
  final String? hImagePath;
  final double? hWidth;
  final double? hHeight;
  final String? hImagePos;
  final bool hCompanyName;
  final bool hCalibrate;
  final bool hReportGen;
  final bool hDeviceId;
  final String? fTextName;
  final String? fTextPosition;
  final String? fTextSize;
  final String? fTextFont;
  final String? fImagePath;
  final double? fWidth;
  final double? fHeight;
  final String? fImagePos;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HeaderFooter({
    required this.id,
    required this.name,
    required this.selected,
    this.hTextName,
    this.hTextPosition,
    this.hTextSize,
    this.hTextFont,
    this.hImagePath,
    this.hWidth,
    this.hHeight,
    this.hImagePos,
    required this.hCompanyName,
    required this.hCalibrate,
    required this.hReportGen,
    required this.hDeviceId,
    this.fTextName,
    this.fTextPosition,
    this.fTextSize,
    this.fTextFont,
    this.fImagePath,
    this.fWidth,
    this.fHeight,
    this.fImagePos,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['selected'] = Variable<bool>(selected);
    if (!nullToAbsent || hTextName != null) {
      map['h_text_name'] = Variable<String>(hTextName);
    }
    if (!nullToAbsent || hTextPosition != null) {
      map['h_text_position'] = Variable<String>(hTextPosition);
    }
    if (!nullToAbsent || hTextSize != null) {
      map['h_text_size'] = Variable<String>(hTextSize);
    }
    if (!nullToAbsent || hTextFont != null) {
      map['h_text_font'] = Variable<String>(hTextFont);
    }
    if (!nullToAbsent || hImagePath != null) {
      map['h_image_path'] = Variable<String>(hImagePath);
    }
    if (!nullToAbsent || hWidth != null) {
      map['h_width'] = Variable<double>(hWidth);
    }
    if (!nullToAbsent || hHeight != null) {
      map['h_height'] = Variable<double>(hHeight);
    }
    if (!nullToAbsent || hImagePos != null) {
      map['h_image_pos'] = Variable<String>(hImagePos);
    }
    map['h_company_name'] = Variable<bool>(hCompanyName);
    map['h_calibrate'] = Variable<bool>(hCalibrate);
    map['h_report_gen'] = Variable<bool>(hReportGen);
    map['h_device_id'] = Variable<bool>(hDeviceId);
    if (!nullToAbsent || fTextName != null) {
      map['f_text_name'] = Variable<String>(fTextName);
    }
    if (!nullToAbsent || fTextPosition != null) {
      map['f_text_position'] = Variable<String>(fTextPosition);
    }
    if (!nullToAbsent || fTextSize != null) {
      map['f_text_size'] = Variable<String>(fTextSize);
    }
    if (!nullToAbsent || fTextFont != null) {
      map['f_text_font'] = Variable<String>(fTextFont);
    }
    if (!nullToAbsent || fImagePath != null) {
      map['f_image_path'] = Variable<String>(fImagePath);
    }
    if (!nullToAbsent || fWidth != null) {
      map['f_width'] = Variable<double>(fWidth);
    }
    if (!nullToAbsent || fHeight != null) {
      map['f_height'] = Variable<double>(fHeight);
    }
    if (!nullToAbsent || fImagePos != null) {
      map['f_image_pos'] = Variable<String>(fImagePos);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HeaderFootersCompanion toCompanion(bool nullToAbsent) {
    return HeaderFootersCompanion(
      id: Value(id),
      name: Value(name),
      selected: Value(selected),
      hTextName: hTextName == null && nullToAbsent
          ? const Value.absent()
          : Value(hTextName),
      hTextPosition: hTextPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(hTextPosition),
      hTextSize: hTextSize == null && nullToAbsent
          ? const Value.absent()
          : Value(hTextSize),
      hTextFont: hTextFont == null && nullToAbsent
          ? const Value.absent()
          : Value(hTextFont),
      hImagePath: hImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(hImagePath),
      hWidth: hWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(hWidth),
      hHeight: hHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(hHeight),
      hImagePos: hImagePos == null && nullToAbsent
          ? const Value.absent()
          : Value(hImagePos),
      hCompanyName: Value(hCompanyName),
      hCalibrate: Value(hCalibrate),
      hReportGen: Value(hReportGen),
      hDeviceId: Value(hDeviceId),
      fTextName: fTextName == null && nullToAbsent
          ? const Value.absent()
          : Value(fTextName),
      fTextPosition: fTextPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(fTextPosition),
      fTextSize: fTextSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fTextSize),
      fTextFont: fTextFont == null && nullToAbsent
          ? const Value.absent()
          : Value(fTextFont),
      fImagePath: fImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(fImagePath),
      fWidth: fWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(fWidth),
      fHeight: fHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(fHeight),
      fImagePos: fImagePos == null && nullToAbsent
          ? const Value.absent()
          : Value(fImagePos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HeaderFooter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeaderFooter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      selected: serializer.fromJson<bool>(json['selected']),
      hTextName: serializer.fromJson<String?>(json['hTextName']),
      hTextPosition: serializer.fromJson<String?>(json['hTextPosition']),
      hTextSize: serializer.fromJson<String?>(json['hTextSize']),
      hTextFont: serializer.fromJson<String?>(json['hTextFont']),
      hImagePath: serializer.fromJson<String?>(json['hImagePath']),
      hWidth: serializer.fromJson<double?>(json['hWidth']),
      hHeight: serializer.fromJson<double?>(json['hHeight']),
      hImagePos: serializer.fromJson<String?>(json['hImagePos']),
      hCompanyName: serializer.fromJson<bool>(json['hCompanyName']),
      hCalibrate: serializer.fromJson<bool>(json['hCalibrate']),
      hReportGen: serializer.fromJson<bool>(json['hReportGen']),
      hDeviceId: serializer.fromJson<bool>(json['hDeviceId']),
      fTextName: serializer.fromJson<String?>(json['fTextName']),
      fTextPosition: serializer.fromJson<String?>(json['fTextPosition']),
      fTextSize: serializer.fromJson<String?>(json['fTextSize']),
      fTextFont: serializer.fromJson<String?>(json['fTextFont']),
      fImagePath: serializer.fromJson<String?>(json['fImagePath']),
      fWidth: serializer.fromJson<double?>(json['fWidth']),
      fHeight: serializer.fromJson<double?>(json['fHeight']),
      fImagePos: serializer.fromJson<String?>(json['fImagePos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'selected': serializer.toJson<bool>(selected),
      'hTextName': serializer.toJson<String?>(hTextName),
      'hTextPosition': serializer.toJson<String?>(hTextPosition),
      'hTextSize': serializer.toJson<String?>(hTextSize),
      'hTextFont': serializer.toJson<String?>(hTextFont),
      'hImagePath': serializer.toJson<String?>(hImagePath),
      'hWidth': serializer.toJson<double?>(hWidth),
      'hHeight': serializer.toJson<double?>(hHeight),
      'hImagePos': serializer.toJson<String?>(hImagePos),
      'hCompanyName': serializer.toJson<bool>(hCompanyName),
      'hCalibrate': serializer.toJson<bool>(hCalibrate),
      'hReportGen': serializer.toJson<bool>(hReportGen),
      'hDeviceId': serializer.toJson<bool>(hDeviceId),
      'fTextName': serializer.toJson<String?>(fTextName),
      'fTextPosition': serializer.toJson<String?>(fTextPosition),
      'fTextSize': serializer.toJson<String?>(fTextSize),
      'fTextFont': serializer.toJson<String?>(fTextFont),
      'fImagePath': serializer.toJson<String?>(fImagePath),
      'fWidth': serializer.toJson<double?>(fWidth),
      'fHeight': serializer.toJson<double?>(fHeight),
      'fImagePos': serializer.toJson<String?>(fImagePos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HeaderFooter copyWith({
    int? id,
    String? name,
    bool? selected,
    Value<String?> hTextName = const Value.absent(),
    Value<String?> hTextPosition = const Value.absent(),
    Value<String?> hTextSize = const Value.absent(),
    Value<String?> hTextFont = const Value.absent(),
    Value<String?> hImagePath = const Value.absent(),
    Value<double?> hWidth = const Value.absent(),
    Value<double?> hHeight = const Value.absent(),
    Value<String?> hImagePos = const Value.absent(),
    bool? hCompanyName,
    bool? hCalibrate,
    bool? hReportGen,
    bool? hDeviceId,
    Value<String?> fTextName = const Value.absent(),
    Value<String?> fTextPosition = const Value.absent(),
    Value<String?> fTextSize = const Value.absent(),
    Value<String?> fTextFont = const Value.absent(),
    Value<String?> fImagePath = const Value.absent(),
    Value<double?> fWidth = const Value.absent(),
    Value<double?> fHeight = const Value.absent(),
    Value<String?> fImagePos = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HeaderFooter(
    id: id ?? this.id,
    name: name ?? this.name,
    selected: selected ?? this.selected,
    hTextName: hTextName.present ? hTextName.value : this.hTextName,
    hTextPosition: hTextPosition.present
        ? hTextPosition.value
        : this.hTextPosition,
    hTextSize: hTextSize.present ? hTextSize.value : this.hTextSize,
    hTextFont: hTextFont.present ? hTextFont.value : this.hTextFont,
    hImagePath: hImagePath.present ? hImagePath.value : this.hImagePath,
    hWidth: hWidth.present ? hWidth.value : this.hWidth,
    hHeight: hHeight.present ? hHeight.value : this.hHeight,
    hImagePos: hImagePos.present ? hImagePos.value : this.hImagePos,
    hCompanyName: hCompanyName ?? this.hCompanyName,
    hCalibrate: hCalibrate ?? this.hCalibrate,
    hReportGen: hReportGen ?? this.hReportGen,
    hDeviceId: hDeviceId ?? this.hDeviceId,
    fTextName: fTextName.present ? fTextName.value : this.fTextName,
    fTextPosition: fTextPosition.present
        ? fTextPosition.value
        : this.fTextPosition,
    fTextSize: fTextSize.present ? fTextSize.value : this.fTextSize,
    fTextFont: fTextFont.present ? fTextFont.value : this.fTextFont,
    fImagePath: fImagePath.present ? fImagePath.value : this.fImagePath,
    fWidth: fWidth.present ? fWidth.value : this.fWidth,
    fHeight: fHeight.present ? fHeight.value : this.fHeight,
    fImagePos: fImagePos.present ? fImagePos.value : this.fImagePos,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HeaderFooter copyWithCompanion(HeaderFootersCompanion data) {
    return HeaderFooter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      selected: data.selected.present ? data.selected.value : this.selected,
      hTextName: data.hTextName.present ? data.hTextName.value : this.hTextName,
      hTextPosition: data.hTextPosition.present
          ? data.hTextPosition.value
          : this.hTextPosition,
      hTextSize: data.hTextSize.present ? data.hTextSize.value : this.hTextSize,
      hTextFont: data.hTextFont.present ? data.hTextFont.value : this.hTextFont,
      hImagePath: data.hImagePath.present
          ? data.hImagePath.value
          : this.hImagePath,
      hWidth: data.hWidth.present ? data.hWidth.value : this.hWidth,
      hHeight: data.hHeight.present ? data.hHeight.value : this.hHeight,
      hImagePos: data.hImagePos.present ? data.hImagePos.value : this.hImagePos,
      hCompanyName: data.hCompanyName.present
          ? data.hCompanyName.value
          : this.hCompanyName,
      hCalibrate: data.hCalibrate.present
          ? data.hCalibrate.value
          : this.hCalibrate,
      hReportGen: data.hReportGen.present
          ? data.hReportGen.value
          : this.hReportGen,
      hDeviceId: data.hDeviceId.present ? data.hDeviceId.value : this.hDeviceId,
      fTextName: data.fTextName.present ? data.fTextName.value : this.fTextName,
      fTextPosition: data.fTextPosition.present
          ? data.fTextPosition.value
          : this.fTextPosition,
      fTextSize: data.fTextSize.present ? data.fTextSize.value : this.fTextSize,
      fTextFont: data.fTextFont.present ? data.fTextFont.value : this.fTextFont,
      fImagePath: data.fImagePath.present
          ? data.fImagePath.value
          : this.fImagePath,
      fWidth: data.fWidth.present ? data.fWidth.value : this.fWidth,
      fHeight: data.fHeight.present ? data.fHeight.value : this.fHeight,
      fImagePos: data.fImagePos.present ? data.fImagePos.value : this.fImagePos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeaderFooter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('selected: $selected, ')
          ..write('hTextName: $hTextName, ')
          ..write('hTextPosition: $hTextPosition, ')
          ..write('hTextSize: $hTextSize, ')
          ..write('hTextFont: $hTextFont, ')
          ..write('hImagePath: $hImagePath, ')
          ..write('hWidth: $hWidth, ')
          ..write('hHeight: $hHeight, ')
          ..write('hImagePos: $hImagePos, ')
          ..write('hCompanyName: $hCompanyName, ')
          ..write('hCalibrate: $hCalibrate, ')
          ..write('hReportGen: $hReportGen, ')
          ..write('hDeviceId: $hDeviceId, ')
          ..write('fTextName: $fTextName, ')
          ..write('fTextPosition: $fTextPosition, ')
          ..write('fTextSize: $fTextSize, ')
          ..write('fTextFont: $fTextFont, ')
          ..write('fImagePath: $fImagePath, ')
          ..write('fWidth: $fWidth, ')
          ..write('fHeight: $fHeight, ')
          ..write('fImagePos: $fImagePos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    selected,
    hTextName,
    hTextPosition,
    hTextSize,
    hTextFont,
    hImagePath,
    hWidth,
    hHeight,
    hImagePos,
    hCompanyName,
    hCalibrate,
    hReportGen,
    hDeviceId,
    fTextName,
    fTextPosition,
    fTextSize,
    fTextFont,
    fImagePath,
    fWidth,
    fHeight,
    fImagePos,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeaderFooter &&
          other.id == this.id &&
          other.name == this.name &&
          other.selected == this.selected &&
          other.hTextName == this.hTextName &&
          other.hTextPosition == this.hTextPosition &&
          other.hTextSize == this.hTextSize &&
          other.hTextFont == this.hTextFont &&
          other.hImagePath == this.hImagePath &&
          other.hWidth == this.hWidth &&
          other.hHeight == this.hHeight &&
          other.hImagePos == this.hImagePos &&
          other.hCompanyName == this.hCompanyName &&
          other.hCalibrate == this.hCalibrate &&
          other.hReportGen == this.hReportGen &&
          other.hDeviceId == this.hDeviceId &&
          other.fTextName == this.fTextName &&
          other.fTextPosition == this.fTextPosition &&
          other.fTextSize == this.fTextSize &&
          other.fTextFont == this.fTextFont &&
          other.fImagePath == this.fImagePath &&
          other.fWidth == this.fWidth &&
          other.fHeight == this.fHeight &&
          other.fImagePos == this.fImagePos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HeaderFootersCompanion extends UpdateCompanion<HeaderFooter> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> selected;
  final Value<String?> hTextName;
  final Value<String?> hTextPosition;
  final Value<String?> hTextSize;
  final Value<String?> hTextFont;
  final Value<String?> hImagePath;
  final Value<double?> hWidth;
  final Value<double?> hHeight;
  final Value<String?> hImagePos;
  final Value<bool> hCompanyName;
  final Value<bool> hCalibrate;
  final Value<bool> hReportGen;
  final Value<bool> hDeviceId;
  final Value<String?> fTextName;
  final Value<String?> fTextPosition;
  final Value<String?> fTextSize;
  final Value<String?> fTextFont;
  final Value<String?> fImagePath;
  final Value<double?> fWidth;
  final Value<double?> fHeight;
  final Value<String?> fImagePos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const HeaderFootersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.selected = const Value.absent(),
    this.hTextName = const Value.absent(),
    this.hTextPosition = const Value.absent(),
    this.hTextSize = const Value.absent(),
    this.hTextFont = const Value.absent(),
    this.hImagePath = const Value.absent(),
    this.hWidth = const Value.absent(),
    this.hHeight = const Value.absent(),
    this.hImagePos = const Value.absent(),
    this.hCompanyName = const Value.absent(),
    this.hCalibrate = const Value.absent(),
    this.hReportGen = const Value.absent(),
    this.hDeviceId = const Value.absent(),
    this.fTextName = const Value.absent(),
    this.fTextPosition = const Value.absent(),
    this.fTextSize = const Value.absent(),
    this.fTextFont = const Value.absent(),
    this.fImagePath = const Value.absent(),
    this.fWidth = const Value.absent(),
    this.fHeight = const Value.absent(),
    this.fImagePos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  HeaderFootersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.selected = const Value.absent(),
    this.hTextName = const Value.absent(),
    this.hTextPosition = const Value.absent(),
    this.hTextSize = const Value.absent(),
    this.hTextFont = const Value.absent(),
    this.hImagePath = const Value.absent(),
    this.hWidth = const Value.absent(),
    this.hHeight = const Value.absent(),
    this.hImagePos = const Value.absent(),
    this.hCompanyName = const Value.absent(),
    this.hCalibrate = const Value.absent(),
    this.hReportGen = const Value.absent(),
    this.hDeviceId = const Value.absent(),
    this.fTextName = const Value.absent(),
    this.fTextPosition = const Value.absent(),
    this.fTextSize = const Value.absent(),
    this.fTextFont = const Value.absent(),
    this.fImagePath = const Value.absent(),
    this.fWidth = const Value.absent(),
    this.fHeight = const Value.absent(),
    this.fImagePos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<HeaderFooter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? selected,
    Expression<String>? hTextName,
    Expression<String>? hTextPosition,
    Expression<String>? hTextSize,
    Expression<String>? hTextFont,
    Expression<String>? hImagePath,
    Expression<double>? hWidth,
    Expression<double>? hHeight,
    Expression<String>? hImagePos,
    Expression<bool>? hCompanyName,
    Expression<bool>? hCalibrate,
    Expression<bool>? hReportGen,
    Expression<bool>? hDeviceId,
    Expression<String>? fTextName,
    Expression<String>? fTextPosition,
    Expression<String>? fTextSize,
    Expression<String>? fTextFont,
    Expression<String>? fImagePath,
    Expression<double>? fWidth,
    Expression<double>? fHeight,
    Expression<String>? fImagePos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (selected != null) 'selected': selected,
      if (hTextName != null) 'h_text_name': hTextName,
      if (hTextPosition != null) 'h_text_position': hTextPosition,
      if (hTextSize != null) 'h_text_size': hTextSize,
      if (hTextFont != null) 'h_text_font': hTextFont,
      if (hImagePath != null) 'h_image_path': hImagePath,
      if (hWidth != null) 'h_width': hWidth,
      if (hHeight != null) 'h_height': hHeight,
      if (hImagePos != null) 'h_image_pos': hImagePos,
      if (hCompanyName != null) 'h_company_name': hCompanyName,
      if (hCalibrate != null) 'h_calibrate': hCalibrate,
      if (hReportGen != null) 'h_report_gen': hReportGen,
      if (hDeviceId != null) 'h_device_id': hDeviceId,
      if (fTextName != null) 'f_text_name': fTextName,
      if (fTextPosition != null) 'f_text_position': fTextPosition,
      if (fTextSize != null) 'f_text_size': fTextSize,
      if (fTextFont != null) 'f_text_font': fTextFont,
      if (fImagePath != null) 'f_image_path': fImagePath,
      if (fWidth != null) 'f_width': fWidth,
      if (fHeight != null) 'f_height': fHeight,
      if (fImagePos != null) 'f_image_pos': fImagePos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  HeaderFootersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? selected,
    Value<String?>? hTextName,
    Value<String?>? hTextPosition,
    Value<String?>? hTextSize,
    Value<String?>? hTextFont,
    Value<String?>? hImagePath,
    Value<double?>? hWidth,
    Value<double?>? hHeight,
    Value<String?>? hImagePos,
    Value<bool>? hCompanyName,
    Value<bool>? hCalibrate,
    Value<bool>? hReportGen,
    Value<bool>? hDeviceId,
    Value<String?>? fTextName,
    Value<String?>? fTextPosition,
    Value<String?>? fTextSize,
    Value<String?>? fTextFont,
    Value<String?>? fImagePath,
    Value<double?>? fWidth,
    Value<double?>? fHeight,
    Value<String?>? fImagePos,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return HeaderFootersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      hTextName: hTextName ?? this.hTextName,
      hTextPosition: hTextPosition ?? this.hTextPosition,
      hTextSize: hTextSize ?? this.hTextSize,
      hTextFont: hTextFont ?? this.hTextFont,
      hImagePath: hImagePath ?? this.hImagePath,
      hWidth: hWidth ?? this.hWidth,
      hHeight: hHeight ?? this.hHeight,
      hImagePos: hImagePos ?? this.hImagePos,
      hCompanyName: hCompanyName ?? this.hCompanyName,
      hCalibrate: hCalibrate ?? this.hCalibrate,
      hReportGen: hReportGen ?? this.hReportGen,
      hDeviceId: hDeviceId ?? this.hDeviceId,
      fTextName: fTextName ?? this.fTextName,
      fTextPosition: fTextPosition ?? this.fTextPosition,
      fTextSize: fTextSize ?? this.fTextSize,
      fTextFont: fTextFont ?? this.fTextFont,
      fImagePath: fImagePath ?? this.fImagePath,
      fWidth: fWidth ?? this.fWidth,
      fHeight: fHeight ?? this.fHeight,
      fImagePos: fImagePos ?? this.fImagePos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (selected.present) {
      map['selected'] = Variable<bool>(selected.value);
    }
    if (hTextName.present) {
      map['h_text_name'] = Variable<String>(hTextName.value);
    }
    if (hTextPosition.present) {
      map['h_text_position'] = Variable<String>(hTextPosition.value);
    }
    if (hTextSize.present) {
      map['h_text_size'] = Variable<String>(hTextSize.value);
    }
    if (hTextFont.present) {
      map['h_text_font'] = Variable<String>(hTextFont.value);
    }
    if (hImagePath.present) {
      map['h_image_path'] = Variable<String>(hImagePath.value);
    }
    if (hWidth.present) {
      map['h_width'] = Variable<double>(hWidth.value);
    }
    if (hHeight.present) {
      map['h_height'] = Variable<double>(hHeight.value);
    }
    if (hImagePos.present) {
      map['h_image_pos'] = Variable<String>(hImagePos.value);
    }
    if (hCompanyName.present) {
      map['h_company_name'] = Variable<bool>(hCompanyName.value);
    }
    if (hCalibrate.present) {
      map['h_calibrate'] = Variable<bool>(hCalibrate.value);
    }
    if (hReportGen.present) {
      map['h_report_gen'] = Variable<bool>(hReportGen.value);
    }
    if (hDeviceId.present) {
      map['h_device_id'] = Variable<bool>(hDeviceId.value);
    }
    if (fTextName.present) {
      map['f_text_name'] = Variable<String>(fTextName.value);
    }
    if (fTextPosition.present) {
      map['f_text_position'] = Variable<String>(fTextPosition.value);
    }
    if (fTextSize.present) {
      map['f_text_size'] = Variable<String>(fTextSize.value);
    }
    if (fTextFont.present) {
      map['f_text_font'] = Variable<String>(fTextFont.value);
    }
    if (fImagePath.present) {
      map['f_image_path'] = Variable<String>(fImagePath.value);
    }
    if (fWidth.present) {
      map['f_width'] = Variable<double>(fWidth.value);
    }
    if (fHeight.present) {
      map['f_height'] = Variable<double>(fHeight.value);
    }
    if (fImagePos.present) {
      map['f_image_pos'] = Variable<String>(fImagePos.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeaderFootersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('selected: $selected, ')
          ..write('hTextName: $hTextName, ')
          ..write('hTextPosition: $hTextPosition, ')
          ..write('hTextSize: $hTextSize, ')
          ..write('hTextFont: $hTextFont, ')
          ..write('hImagePath: $hImagePath, ')
          ..write('hWidth: $hWidth, ')
          ..write('hHeight: $hHeight, ')
          ..write('hImagePos: $hImagePos, ')
          ..write('hCompanyName: $hCompanyName, ')
          ..write('hCalibrate: $hCalibrate, ')
          ..write('hReportGen: $hReportGen, ')
          ..write('hDeviceId: $hDeviceId, ')
          ..write('fTextName: $fTextName, ')
          ..write('fTextPosition: $fTextPosition, ')
          ..write('fTextSize: $fTextSize, ')
          ..write('fTextFont: $fTextFont, ')
          ..write('fImagePath: $fImagePath, ')
          ..write('fWidth: $fWidth, ')
          ..write('fHeight: $fHeight, ')
          ..write('fImagePos: $fImagePos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CompanyDetailsTable extends CompanyDetails
    with TableInfo<$CompanyDetailsTable, CompanyDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanyDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _gstNoMeta = const VerificationMeta('gstNo');
  @override
  late final GeneratedColumn<String> gstNo = GeneratedColumn<String>(
    'gst_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    address,
    phone,
    email,
    website,
    gstNo,
    logoPath,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompanyDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('gst_no')) {
      context.handle(
        _gstNoMeta,
        gstNo.isAcceptableOrUnknown(data['gst_no']!, _gstNoMeta),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanyDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanyDetail(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      )!,
      gstNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gst_no'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CompanyDetailsTable createAlias(String alias) {
    return $CompanyDetailsTable(attachedDatabase, alias);
  }
}

class CompanyDetail extends DataClass implements Insertable<CompanyDetail> {
  final int id;
  final String companyName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String gstNo;
  final String? logoPath;
  final DateTime updatedAt;
  const CompanyDetail({
    required this.id,
    required this.companyName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.gstNo,
    this.logoPath,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_name'] = Variable<String>(companyName);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['website'] = Variable<String>(website);
    map['gst_no'] = Variable<String>(gstNo);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CompanyDetailsCompanion toCompanion(bool nullToAbsent) {
    return CompanyDetailsCompanion(
      id: Value(id),
      companyName: Value(companyName),
      address: Value(address),
      phone: Value(phone),
      email: Value(email),
      website: Value(website),
      gstNo: Value(gstNo),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      updatedAt: Value(updatedAt),
    );
  }

  factory CompanyDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanyDetail(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      website: serializer.fromJson<String>(json['website']),
      gstNo: serializer.fromJson<String>(json['gstNo']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String>(companyName),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'website': serializer.toJson<String>(website),
      'gstNo': serializer.toJson<String>(gstNo),
      'logoPath': serializer.toJson<String?>(logoPath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CompanyDetail copyWith({
    int? id,
    String? companyName,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? gstNo,
    Value<String?> logoPath = const Value.absent(),
    DateTime? updatedAt,
  }) => CompanyDetail(
    id: id ?? this.id,
    companyName: companyName ?? this.companyName,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    website: website ?? this.website,
    gstNo: gstNo ?? this.gstNo,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CompanyDetail copyWithCompanion(CompanyDetailsCompanion data) {
    return CompanyDetail(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      website: data.website.present ? data.website.value : this.website,
      gstNo: data.gstNo.present ? data.gstNo.value : this.gstNo,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanyDetail(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('gstNo: $gstNo, ')
          ..write('logoPath: $logoPath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyName,
    address,
    phone,
    email,
    website,
    gstNo,
    logoPath,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanyDetail &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.website == this.website &&
          other.gstNo == this.gstNo &&
          other.logoPath == this.logoPath &&
          other.updatedAt == this.updatedAt);
}

class CompanyDetailsCompanion extends UpdateCompanion<CompanyDetail> {
  final Value<int> id;
  final Value<String> companyName;
  final Value<String> address;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> website;
  final Value<String> gstNo;
  final Value<String?> logoPath;
  final Value<DateTime> updatedAt;
  const CompanyDetailsCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.website = const Value.absent(),
    this.gstNo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CompanyDetailsCompanion.insert({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.website = const Value.absent(),
    this.gstNo = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<CompanyDetail> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? website,
    Expression<String>? gstNo,
    Expression<String>? logoPath,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (website != null) 'website': website,
      if (gstNo != null) 'gst_no': gstNo,
      if (logoPath != null) 'logo_path': logoPath,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CompanyDetailsCompanion copyWith({
    Value<int>? id,
    Value<String>? companyName,
    Value<String>? address,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? website,
    Value<String>? gstNo,
    Value<String?>? logoPath,
    Value<DateTime>? updatedAt,
  }) {
    return CompanyDetailsCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      gstNo: gstNo ?? this.gstNo,
      logoPath: logoPath ?? this.logoPath,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (gstNo.present) {
      map['gst_no'] = Variable<String>(gstNo.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanyDetailsCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('website: $website, ')
          ..write('gstNo: $gstNo, ')
          ..write('logoPath: $logoPath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReportFilesTable extends ReportFiles
    with TableInfo<$ReportFilesTable, ReportFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportTypeMeta = const VerificationMeta(
    'reportType',
  );
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
    'report_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceTypeMeta = const VerificationMeta(
    'deviceType',
  );
  @override
  late final GeneratedColumn<String> deviceType = GeneratedColumn<String>(
    'device_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _generatedByMeta = const VerificationMeta(
    'generatedBy',
  );
  @override
  late final GeneratedColumn<String> generatedBy = GeneratedColumn<String>(
    'generated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pdf'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileName,
    reportType,
    deviceId,
    deviceType,
    filePath,
    fileSize,
    generatedBy,
    format,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('report_type')) {
      context.handle(
        _reportTypeMeta,
        reportType.isAcceptableOrUnknown(data['report_type']!, _reportTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_reportTypeMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_type')) {
      context.handle(
        _deviceTypeMeta,
        deviceType.isAcceptableOrUnknown(data['device_type']!, _deviceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceTypeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('generated_by')) {
      context.handle(
        _generatedByMeta,
        generatedBy.isAcceptableOrUnknown(
          data['generated_by']!,
          _generatedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedByMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      reportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_type'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      deviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_type'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      generatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generated_by'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReportFilesTable createAlias(String alias) {
    return $ReportFilesTable(attachedDatabase, alias);
  }
}

class ReportFile extends DataClass implements Insertable<ReportFile> {
  final int id;
  final String fileName;
  final String reportType;
  final String deviceId;
  final String deviceType;
  final String filePath;
  final int fileSize;
  final String generatedBy;
  final String format;
  final DateTime createdAt;
  const ReportFile({
    required this.id,
    required this.fileName,
    required this.reportType,
    required this.deviceId,
    required this.deviceType,
    required this.filePath,
    required this.fileSize,
    required this.generatedBy,
    required this.format,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_name'] = Variable<String>(fileName);
    map['report_type'] = Variable<String>(reportType);
    map['device_id'] = Variable<String>(deviceId);
    map['device_type'] = Variable<String>(deviceType);
    map['file_path'] = Variable<String>(filePath);
    map['file_size'] = Variable<int>(fileSize);
    map['generated_by'] = Variable<String>(generatedBy);
    map['format'] = Variable<String>(format);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportFilesCompanion toCompanion(bool nullToAbsent) {
    return ReportFilesCompanion(
      id: Value(id),
      fileName: Value(fileName),
      reportType: Value(reportType),
      deviceId: Value(deviceId),
      deviceType: Value(deviceType),
      filePath: Value(filePath),
      fileSize: Value(fileSize),
      generatedBy: Value(generatedBy),
      format: Value(format),
      createdAt: Value(createdAt),
    );
  }

  factory ReportFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportFile(
      id: serializer.fromJson<int>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      reportType: serializer.fromJson<String>(json['reportType']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceType: serializer.fromJson<String>(json['deviceType']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      generatedBy: serializer.fromJson<String>(json['generatedBy']),
      format: serializer.fromJson<String>(json['format']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileName': serializer.toJson<String>(fileName),
      'reportType': serializer.toJson<String>(reportType),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceType': serializer.toJson<String>(deviceType),
      'filePath': serializer.toJson<String>(filePath),
      'fileSize': serializer.toJson<int>(fileSize),
      'generatedBy': serializer.toJson<String>(generatedBy),
      'format': serializer.toJson<String>(format),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReportFile copyWith({
    int? id,
    String? fileName,
    String? reportType,
    String? deviceId,
    String? deviceType,
    String? filePath,
    int? fileSize,
    String? generatedBy,
    String? format,
    DateTime? createdAt,
  }) => ReportFile(
    id: id ?? this.id,
    fileName: fileName ?? this.fileName,
    reportType: reportType ?? this.reportType,
    deviceId: deviceId ?? this.deviceId,
    deviceType: deviceType ?? this.deviceType,
    filePath: filePath ?? this.filePath,
    fileSize: fileSize ?? this.fileSize,
    generatedBy: generatedBy ?? this.generatedBy,
    format: format ?? this.format,
    createdAt: createdAt ?? this.createdAt,
  );
  ReportFile copyWithCompanion(ReportFilesCompanion data) {
    return ReportFile(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      reportType: data.reportType.present
          ? data.reportType.value
          : this.reportType,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceType: data.deviceType.present
          ? data.deviceType.value
          : this.deviceType,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      generatedBy: data.generatedBy.present
          ? data.generatedBy.value
          : this.generatedBy,
      format: data.format.present ? data.format.value : this.format,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportFile(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('reportType: $reportType, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceType: $deviceType, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('format: $format, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileName,
    reportType,
    deviceId,
    deviceType,
    filePath,
    fileSize,
    generatedBy,
    format,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportFile &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.reportType == this.reportType &&
          other.deviceId == this.deviceId &&
          other.deviceType == this.deviceType &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.generatedBy == this.generatedBy &&
          other.format == this.format &&
          other.createdAt == this.createdAt);
}

class ReportFilesCompanion extends UpdateCompanion<ReportFile> {
  final Value<int> id;
  final Value<String> fileName;
  final Value<String> reportType;
  final Value<String> deviceId;
  final Value<String> deviceType;
  final Value<String> filePath;
  final Value<int> fileSize;
  final Value<String> generatedBy;
  final Value<String> format;
  final Value<DateTime> createdAt;
  const ReportFilesCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.reportType = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceType = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.generatedBy = const Value.absent(),
    this.format = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReportFilesCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    required String reportType,
    required String deviceId,
    required String deviceType,
    required String filePath,
    this.fileSize = const Value.absent(),
    required String generatedBy,
    this.format = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fileName = Value(fileName),
       reportType = Value(reportType),
       deviceId = Value(deviceId),
       deviceType = Value(deviceType),
       filePath = Value(filePath),
       generatedBy = Value(generatedBy);
  static Insertable<ReportFile> custom({
    Expression<int>? id,
    Expression<String>? fileName,
    Expression<String>? reportType,
    Expression<String>? deviceId,
    Expression<String>? deviceType,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<String>? generatedBy,
    Expression<String>? format,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (reportType != null) 'report_type': reportType,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceType != null) 'device_type': deviceType,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (generatedBy != null) 'generated_by': generatedBy,
      if (format != null) 'format': format,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReportFilesCompanion copyWith({
    Value<int>? id,
    Value<String>? fileName,
    Value<String>? reportType,
    Value<String>? deviceId,
    Value<String>? deviceType,
    Value<String>? filePath,
    Value<int>? fileSize,
    Value<String>? generatedBy,
    Value<String>? format,
    Value<DateTime>? createdAt,
  }) {
    return ReportFilesCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      reportType: reportType ?? this.reportType,
      deviceId: deviceId ?? this.deviceId,
      deviceType: deviceType ?? this.deviceType,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      generatedBy: generatedBy ?? this.generatedBy,
      format: format ?? this.format,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceType.present) {
      map['device_type'] = Variable<String>(deviceType.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (generatedBy.present) {
      map['generated_by'] = Variable<String>(generatedBy.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportFilesCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('reportType: $reportType, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceType: $deviceType, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('generatedBy: $generatedBy, ')
          ..write('format: $format, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PasswordHistoriesTable extends PasswordHistories
    with TableInfo<$PasswordHistoriesTable, PasswordHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, passwordHash, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'password_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<PasswordHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PasswordHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PasswordHistoriesTable createAlias(String alias) {
    return $PasswordHistoriesTable(attachedDatabase, alias);
  }
}

class PasswordHistory extends DataClass implements Insertable<PasswordHistory> {
  final int id;
  final int userId;
  final String passwordHash;
  final DateTime createdAt;
  const PasswordHistory({
    required this.id,
    required this.userId,
    required this.passwordHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['password_hash'] = Variable<String>(passwordHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PasswordHistoriesCompanion toCompanion(bool nullToAbsent) {
    return PasswordHistoriesCompanion(
      id: Value(id),
      userId: Value(userId),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
    );
  }

  factory PasswordHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordHistory(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PasswordHistory copyWith({
    int? id,
    int? userId,
    String? passwordHash,
    DateTime? createdAt,
  }) => PasswordHistory(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    passwordHash: passwordHash ?? this.passwordHash,
    createdAt: createdAt ?? this.createdAt,
  );
  PasswordHistory copyWithCompanion(PasswordHistoriesCompanion data) {
    return PasswordHistory(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistory(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, passwordHash, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordHistory &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.passwordHash == this.passwordHash &&
          other.createdAt == this.createdAt);
}

class PasswordHistoriesCompanion extends UpdateCompanion<PasswordHistory> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> passwordHash;
  final Value<DateTime> createdAt;
  const PasswordHistoriesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PasswordHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String passwordHash,
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       passwordHash = Value(passwordHash);
  static Insertable<PasswordHistory> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? passwordHash,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PasswordHistoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? passwordHash,
    Value<DateTime>? createdAt,
  }) {
    return PasswordHistoriesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('success'),
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _integrityHashMeta = const VerificationMeta(
    'integrityHash',
  );
  @override
  late final GeneratedColumn<String> integrityHash = GeneratedColumn<String>(
    'integrity_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    action,
    userId,
    userName,
    entityType,
    entityId,
    status,
    details,
    integrityHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('integrity_hash')) {
      context.handle(
        _integrityHashMeta,
        integrityHash.isAcceptableOrUnknown(
          data['integrity_hash']!,
          _integrityHashMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
      integrityHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}integrity_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;

  /// Category: auth, user, device, calibration, report, file, settings
  final String category;

  /// Specific action: login, logout, create, edit, delete, print, export, etc.
  final String action;

  /// User who performed the action
  final int? userId;
  final String userName;

  /// What entity was affected (e.g. "user", "device", "report")
  final String entityType;
  final String entityId;

  /// Outcome
  final String status;

  /// Additional details (JSON string)
  final String details;

  /// SHA-256 hash of previous log entry + this entry's data = tamper-proof chain
  final String integrityHash;

  /// Timestamp
  final DateTime createdAt;
  const AuditLog({
    required this.id,
    required this.category,
    required this.action,
    this.userId,
    required this.userName,
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.details,
    required this.integrityHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['user_name'] = Variable<String>(userName);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['status'] = Variable<String>(status);
    map['details'] = Variable<String>(details);
    map['integrity_hash'] = Variable<String>(integrityHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      category: Value(category),
      action: Value(action),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      userName: Value(userName),
      entityType: Value(entityType),
      entityId: Value(entityId),
      status: Value(status),
      details: Value(details),
      integrityHash: Value(integrityHash),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      action: serializer.fromJson<String>(json['action']),
      userId: serializer.fromJson<int?>(json['userId']),
      userName: serializer.fromJson<String>(json['userName']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      status: serializer.fromJson<String>(json['status']),
      details: serializer.fromJson<String>(json['details']),
      integrityHash: serializer.fromJson<String>(json['integrityHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'action': serializer.toJson<String>(action),
      'userId': serializer.toJson<int?>(userId),
      'userName': serializer.toJson<String>(userName),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'status': serializer.toJson<String>(status),
      'details': serializer.toJson<String>(details),
      'integrityHash': serializer.toJson<String>(integrityHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLog copyWith({
    int? id,
    String? category,
    String? action,
    Value<int?> userId = const Value.absent(),
    String? userName,
    String? entityType,
    String? entityId,
    String? status,
    String? details,
    String? integrityHash,
    DateTime? createdAt,
  }) => AuditLog(
    id: id ?? this.id,
    category: category ?? this.category,
    action: action ?? this.action,
    userId: userId.present ? userId.value : this.userId,
    userName: userName ?? this.userName,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    status: status ?? this.status,
    details: details ?? this.details,
    integrityHash: integrityHash ?? this.integrityHash,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      action: data.action.present ? data.action.value : this.action,
      userId: data.userId.present ? data.userId.value : this.userId,
      userName: data.userName.present ? data.userName.value : this.userName,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      status: data.status.present ? data.status.value : this.status,
      details: data.details.present ? data.details.value : this.details,
      integrityHash: data.integrityHash.present
          ? data.integrityHash.value
          : this.integrityHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('details: $details, ')
          ..write('integrityHash: $integrityHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    action,
    userId,
    userName,
    entityType,
    entityId,
    status,
    details,
    integrityHash,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.category == this.category &&
          other.action == this.action &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.status == this.status &&
          other.details == this.details &&
          other.integrityHash == this.integrityHash &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> action;
  final Value<int?> userId;
  final Value<String> userName;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> status;
  final Value<String> details;
  final Value<String> integrityHash;
  final Value<DateTime> createdAt;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.action = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.details = const Value.absent(),
    this.integrityHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String action,
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.details = const Value.absent(),
    this.integrityHash = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : category = Value(category),
       action = Value(action);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? action,
    Expression<int>? userId,
    Expression<String>? userName,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? status,
    Expression<String>? details,
    Expression<String>? integrityHash,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (action != null) 'action': action,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (status != null) 'status': status,
      if (details != null) 'details': details,
      if (integrityHash != null) 'integrity_hash': integrityHash,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? action,
    Value<int?>? userId,
    Value<String>? userName,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? status,
    Value<String>? details,
    Value<String>? integrityHash,
    Value<DateTime>? createdAt,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      details: details ?? this.details,
      integrityHash: integrityHash ?? this.integrityHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (integrityHash.present) {
      map['integrity_hash'] = Variable<String>(integrityHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('details: $details, ')
          ..write('integrityHash: $integrityHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $DeviceConfigsTable deviceConfigs = $DeviceConfigsTable(this);
  late final $CalibrationRowsTable calibrationRows = $CalibrationRowsTable(
    this,
  );
  late final $LogsTable logs = $LogsTable(this);
  late final $HeaderFootersTable headerFooters = $HeaderFootersTable(this);
  late final $CompanyDetailsTable companyDetails = $CompanyDetailsTable(this);
  late final $ReportFilesTable reportFiles = $ReportFilesTable(this);
  late final $PasswordHistoriesTable passwordHistories =
      $PasswordHistoriesTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    devices,
    deviceConfigs,
    calibrationRows,
    logs,
    headerFooters,
    companyDetails,
    reportFiles,
    passwordHistories,
    auditLogs,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String name,
      required String email,
      required String passwordHash,
      Value<String> role,
      Value<bool> isActive,
      Value<int> sessionDuration,
      Value<DateTime> passwordChangedAt,
      Value<int> passwordExpiryDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String> passwordHash,
      Value<String> role,
      Value<bool> isActive,
      Value<int> sessionDuration,
      Value<DateTime> passwordChangedAt,
      Value<int> passwordExpiryDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionDuration => $composableBuilder(
    column: $table.sessionDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get passwordChangedAt => $composableBuilder(
    column: $table.passwordChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passwordExpiryDays => $composableBuilder(
    column: $table.passwordExpiryDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionDuration => $composableBuilder(
    column: $table.sessionDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get passwordChangedAt => $composableBuilder(
    column: $table.passwordChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passwordExpiryDays => $composableBuilder(
    column: $table.passwordExpiryDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sessionDuration => $composableBuilder(
    column: $table.sessionDuration,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get passwordChangedAt => $composableBuilder(
    column: $table.passwordChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get passwordExpiryDays => $composableBuilder(
    column: $table.passwordExpiryDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sessionDuration = const Value.absent(),
                Value<DateTime> passwordChangedAt = const Value.absent(),
                Value<int> passwordExpiryDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
                sessionDuration: sessionDuration,
                passwordChangedAt: passwordChangedAt,
                passwordExpiryDays: passwordExpiryDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String email,
                required String passwordHash,
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sessionDuration = const Value.absent(),
                Value<DateTime> passwordChangedAt = const Value.absent(),
                Value<int> passwordExpiryDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
                sessionDuration: sessionDuration,
                passwordChangedAt: passwordChangedAt,
                passwordExpiryDays: passwordExpiryDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$DevicesTableCreateCompanionBuilder =
    DevicesCompanion Function({
      Value<int> id,
      required String deviceId,
      required String type,
      Value<String> mode,
      Value<bool> calibrate,
      Value<bool> log,
      Value<String?> status,
      Value<DateTime?> lastUpdated,
      Value<DateTime> createdAt,
    });
typedef $$DevicesTableUpdateCompanionBuilder =
    DevicesCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> type,
      Value<String> mode,
      Value<bool> calibrate,
      Value<bool> log,
      Value<String?> status,
      Value<DateTime?> lastUpdated,
      Value<DateTime> createdAt,
    });

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, Device> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DeviceConfigsTable, List<DeviceConfig>>
  _deviceConfigsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deviceConfigs,
    aliasName: $_aliasNameGenerator(db.devices.id, db.deviceConfigs.deviceId),
  );

  $$DeviceConfigsTableProcessedTableManager get deviceConfigsRefs {
    final manager = $$DeviceConfigsTableTableManager(
      $_db,
      $_db.deviceConfigs,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_deviceConfigsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LogsTable, List<Log>> _logsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.logs,
    aliasName: $_aliasNameGenerator(db.devices.id, db.logs.deviceId),
  );

  $$LogsTableProcessedTableManager get logsRefs {
    final manager = $$LogsTableTableManager(
      $_db,
      $_db.logs,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_logsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calibrate => $composableBuilder(
    column: $table.calibrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get log => $composableBuilder(
    column: $table.log,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> deviceConfigsRefs(
    Expression<bool> Function($$DeviceConfigsTableFilterComposer f) f,
  ) {
    final $$DeviceConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceConfigs,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceConfigsTableFilterComposer(
            $db: $db,
            $table: $db.deviceConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> logsRefs(
    Expression<bool> Function($$LogsTableFilterComposer f) f,
  ) {
    final $$LogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logs,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogsTableFilterComposer(
            $db: $db,
            $table: $db.logs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calibrate => $composableBuilder(
    column: $table.calibrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get log => $composableBuilder(
    column: $table.log,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<bool> get calibrate =>
      $composableBuilder(column: $table.calibrate, builder: (column) => column);

  GeneratedColumn<bool> get log =>
      $composableBuilder(column: $table.log, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> deviceConfigsRefs<T extends Object>(
    Expression<T> Function($$DeviceConfigsTableAnnotationComposer a) f,
  ) {
    final $$DeviceConfigsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceConfigs,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceConfigsTableAnnotationComposer(
            $db: $db,
            $table: $db.deviceConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> logsRefs<T extends Object>(
    Expression<T> Function($$LogsTableAnnotationComposer a) f,
  ) {
    final $$LogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logs,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogsTableAnnotationComposer(
            $db: $db,
            $table: $db.logs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          Device,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (Device, $$DevicesTableReferences),
          Device,
          PrefetchHooks Function({bool deviceConfigsRefs, bool logsRefs})
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<bool> calibrate = const Value.absent(),
                Value<bool> log = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                deviceId: deviceId,
                type: type,
                mode: mode,
                calibrate: calibrate,
                log: log,
                status: status,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String type,
                Value<String> mode = const Value.absent(),
                Value<bool> calibrate = const Value.absent(),
                Value<bool> log = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                deviceId: deviceId,
                type: type,
                mode: mode,
                calibrate: calibrate,
                log: log,
                status: status,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({deviceConfigsRefs = false, logsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (deviceConfigsRefs) db.deviceConfigs,
                    if (logsRefs) db.logs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (deviceConfigsRefs)
                        await $_getPrefetchedData<
                          Device,
                          $DevicesTable,
                          DeviceConfig
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._deviceConfigsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).deviceConfigsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (logsRefs)
                        await $_getPrefetchedData<Device, $DevicesTable, Log>(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._logsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(db, table, p0).logsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      Device,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (Device, $$DevicesTableReferences),
      Device,
      PrefetchHooks Function({bool deviceConfigsRefs, bool logsRefs})
    >;
typedef $$DeviceConfigsTableCreateCompanionBuilder =
    DeviceConfigsCompanion Function({
      Value<int> id,
      required int deviceId,
      required String mode,
      Value<String?> probe,
      Value<double?> minPh,
      Value<double?> maxPh,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DeviceConfigsTableUpdateCompanionBuilder =
    DeviceConfigsCompanion Function({
      Value<int> id,
      Value<int> deviceId,
      Value<String> mode,
      Value<String?> probe,
      Value<double?> minPh,
      Value<double?> maxPh,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DeviceConfigsTableReferences
    extends BaseReferences<_$AppDatabase, $DeviceConfigsTable, DeviceConfig> {
  $$DeviceConfigsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias(
        $_aliasNameGenerator(db.deviceConfigs.deviceId, db.devices.id),
      );

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<int>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CalibrationRowsTable, List<CalibrationRow>>
  _calibrationRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.calibrationRows,
    aliasName: $_aliasNameGenerator(
      db.deviceConfigs.id,
      db.calibrationRows.configId,
    ),
  );

  $$CalibrationRowsTableProcessedTableManager get calibrationRowsRefs {
    final manager = $$CalibrationRowsTableTableManager(
      $_db,
      $_db.calibrationRows,
    ).filter((f) => f.configId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _calibrationRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeviceConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceConfigsTable> {
  $$DeviceConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get probe => $composableBuilder(
    column: $table.probe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minPh => $composableBuilder(
    column: $table.minPh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxPh => $composableBuilder(
    column: $table.maxPh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> calibrationRowsRefs(
    Expression<bool> Function($$CalibrationRowsTableFilterComposer f) f,
  ) {
    final $$CalibrationRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calibrationRows,
      getReferencedColumn: (t) => t.configId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationRowsTableFilterComposer(
            $db: $db,
            $table: $db.calibrationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeviceConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceConfigsTable> {
  $$DeviceConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get probe => $composableBuilder(
    column: $table.probe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minPh => $composableBuilder(
    column: $table.minPh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxPh => $composableBuilder(
    column: $table.maxPh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceConfigsTable> {
  $$DeviceConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get probe =>
      $composableBuilder(column: $table.probe, builder: (column) => column);

  GeneratedColumn<double> get minPh =>
      $composableBuilder(column: $table.minPh, builder: (column) => column);

  GeneratedColumn<double> get maxPh =>
      $composableBuilder(column: $table.maxPh, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> calibrationRowsRefs<T extends Object>(
    Expression<T> Function($$CalibrationRowsTableAnnotationComposer a) f,
  ) {
    final $$CalibrationRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.calibrationRows,
      getReferencedColumn: (t) => t.configId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalibrationRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.calibrationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeviceConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceConfigsTable,
          DeviceConfig,
          $$DeviceConfigsTableFilterComposer,
          $$DeviceConfigsTableOrderingComposer,
          $$DeviceConfigsTableAnnotationComposer,
          $$DeviceConfigsTableCreateCompanionBuilder,
          $$DeviceConfigsTableUpdateCompanionBuilder,
          (DeviceConfig, $$DeviceConfigsTableReferences),
          DeviceConfig,
          PrefetchHooks Function({bool deviceId, bool calibrationRowsRefs})
        > {
  $$DeviceConfigsTableTableManager(_$AppDatabase db, $DeviceConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deviceId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> probe = const Value.absent(),
                Value<double?> minPh = const Value.absent(),
                Value<double?> maxPh = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DeviceConfigsCompanion(
                id: id,
                deviceId: deviceId,
                mode: mode,
                probe: probe,
                minPh: minPh,
                maxPh: maxPh,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deviceId,
                required String mode,
                Value<String?> probe = const Value.absent(),
                Value<double?> minPh = const Value.absent(),
                Value<double?> maxPh = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DeviceConfigsCompanion.insert(
                id: id,
                deviceId: deviceId,
                mode: mode,
                probe: probe,
                minPh: minPh,
                maxPh: maxPh,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeviceConfigsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({deviceId = false, calibrationRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (calibrationRowsRefs) db.calibrationRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (deviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.deviceId,
                                    referencedTable:
                                        $$DeviceConfigsTableReferences
                                            ._deviceIdTable(db),
                                    referencedColumn:
                                        $$DeviceConfigsTableReferences
                                            ._deviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (calibrationRowsRefs)
                        await $_getPrefetchedData<
                          DeviceConfig,
                          $DeviceConfigsTable,
                          CalibrationRow
                        >(
                          currentTable: table,
                          referencedTable: $$DeviceConfigsTableReferences
                              ._calibrationRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DeviceConfigsTableReferences(
                                db,
                                table,
                                p0,
                              ).calibrationRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.configId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DeviceConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceConfigsTable,
      DeviceConfig,
      $$DeviceConfigsTableFilterComposer,
      $$DeviceConfigsTableOrderingComposer,
      $$DeviceConfigsTableAnnotationComposer,
      $$DeviceConfigsTableCreateCompanionBuilder,
      $$DeviceConfigsTableUpdateCompanionBuilder,
      (DeviceConfig, $$DeviceConfigsTableReferences),
      DeviceConfig,
      PrefetchHooks Function({bool deviceId, bool calibrationRowsRefs})
    >;
typedef $$CalibrationRowsTableCreateCompanionBuilder =
    CalibrationRowsCompanion Function({
      Value<int> id,
      required int configId,
      required double val,
      Value<double?> valAfterCal,
      Value<double?> slope,
      Value<double?> temp,
      Value<double?> mv,
      Value<double?> minMv,
      Value<double?> maxMv,
      Value<DateTime?> time,
    });
typedef $$CalibrationRowsTableUpdateCompanionBuilder =
    CalibrationRowsCompanion Function({
      Value<int> id,
      Value<int> configId,
      Value<double> val,
      Value<double?> valAfterCal,
      Value<double?> slope,
      Value<double?> temp,
      Value<double?> mv,
      Value<double?> minMv,
      Value<double?> maxMv,
      Value<DateTime?> time,
    });

final class $$CalibrationRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CalibrationRowsTable, CalibrationRow> {
  $$CalibrationRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DeviceConfigsTable _configIdTable(_$AppDatabase db) =>
      db.deviceConfigs.createAlias(
        $_aliasNameGenerator(db.calibrationRows.configId, db.deviceConfigs.id),
      );

  $$DeviceConfigsTableProcessedTableManager get configId {
    final $_column = $_itemColumn<int>('config_id')!;

    final manager = $$DeviceConfigsTableTableManager(
      $_db,
      $_db.deviceConfigs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_configIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CalibrationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationRowsTable> {
  $$CalibrationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get val => $composableBuilder(
    column: $table.val,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valAfterCal => $composableBuilder(
    column: $table.valAfterCal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get slope => $composableBuilder(
    column: $table.slope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mv => $composableBuilder(
    column: $table.mv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minMv => $composableBuilder(
    column: $table.minMv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxMv => $composableBuilder(
    column: $table.maxMv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  $$DeviceConfigsTableFilterComposer get configId {
    final $$DeviceConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.configId,
      referencedTable: $db.deviceConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceConfigsTableFilterComposer(
            $db: $db,
            $table: $db.deviceConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalibrationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationRowsTable> {
  $$CalibrationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get val => $composableBuilder(
    column: $table.val,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valAfterCal => $composableBuilder(
    column: $table.valAfterCal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get slope => $composableBuilder(
    column: $table.slope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mv => $composableBuilder(
    column: $table.mv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minMv => $composableBuilder(
    column: $table.minMv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxMv => $composableBuilder(
    column: $table.maxMv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeviceConfigsTableOrderingComposer get configId {
    final $$DeviceConfigsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.configId,
      referencedTable: $db.deviceConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceConfigsTableOrderingComposer(
            $db: $db,
            $table: $db.deviceConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalibrationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationRowsTable> {
  $$CalibrationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get val =>
      $composableBuilder(column: $table.val, builder: (column) => column);

  GeneratedColumn<double> get valAfterCal => $composableBuilder(
    column: $table.valAfterCal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get slope =>
      $composableBuilder(column: $table.slope, builder: (column) => column);

  GeneratedColumn<double> get temp =>
      $composableBuilder(column: $table.temp, builder: (column) => column);

  GeneratedColumn<double> get mv =>
      $composableBuilder(column: $table.mv, builder: (column) => column);

  GeneratedColumn<double> get minMv =>
      $composableBuilder(column: $table.minMv, builder: (column) => column);

  GeneratedColumn<double> get maxMv =>
      $composableBuilder(column: $table.maxMv, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  $$DeviceConfigsTableAnnotationComposer get configId {
    final $$DeviceConfigsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.configId,
      referencedTable: $db.deviceConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceConfigsTableAnnotationComposer(
            $db: $db,
            $table: $db.deviceConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalibrationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalibrationRowsTable,
          CalibrationRow,
          $$CalibrationRowsTableFilterComposer,
          $$CalibrationRowsTableOrderingComposer,
          $$CalibrationRowsTableAnnotationComposer,
          $$CalibrationRowsTableCreateCompanionBuilder,
          $$CalibrationRowsTableUpdateCompanionBuilder,
          (CalibrationRow, $$CalibrationRowsTableReferences),
          CalibrationRow,
          PrefetchHooks Function({bool configId})
        > {
  $$CalibrationRowsTableTableManager(
    _$AppDatabase db,
    $CalibrationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalibrationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalibrationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> configId = const Value.absent(),
                Value<double> val = const Value.absent(),
                Value<double?> valAfterCal = const Value.absent(),
                Value<double?> slope = const Value.absent(),
                Value<double?> temp = const Value.absent(),
                Value<double?> mv = const Value.absent(),
                Value<double?> minMv = const Value.absent(),
                Value<double?> maxMv = const Value.absent(),
                Value<DateTime?> time = const Value.absent(),
              }) => CalibrationRowsCompanion(
                id: id,
                configId: configId,
                val: val,
                valAfterCal: valAfterCal,
                slope: slope,
                temp: temp,
                mv: mv,
                minMv: minMv,
                maxMv: maxMv,
                time: time,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int configId,
                required double val,
                Value<double?> valAfterCal = const Value.absent(),
                Value<double?> slope = const Value.absent(),
                Value<double?> temp = const Value.absent(),
                Value<double?> mv = const Value.absent(),
                Value<double?> minMv = const Value.absent(),
                Value<double?> maxMv = const Value.absent(),
                Value<DateTime?> time = const Value.absent(),
              }) => CalibrationRowsCompanion.insert(
                id: id,
                configId: configId,
                val: val,
                valAfterCal: valAfterCal,
                slope: slope,
                temp: temp,
                mv: mv,
                minMv: minMv,
                maxMv: maxMv,
                time: time,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalibrationRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({configId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (configId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.configId,
                                referencedTable:
                                    $$CalibrationRowsTableReferences
                                        ._configIdTable(db),
                                referencedColumn:
                                    $$CalibrationRowsTableReferences
                                        ._configIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CalibrationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalibrationRowsTable,
      CalibrationRow,
      $$CalibrationRowsTableFilterComposer,
      $$CalibrationRowsTableOrderingComposer,
      $$CalibrationRowsTableAnnotationComposer,
      $$CalibrationRowsTableCreateCompanionBuilder,
      $$CalibrationRowsTableUpdateCompanionBuilder,
      (CalibrationRow, $$CalibrationRowsTableReferences),
      CalibrationRow,
      PrefetchHooks Function({bool configId})
    >;
typedef $$LogsTableCreateCompanionBuilder =
    LogsCompanion Function({
      Value<int> id,
      required int deviceId,
      required double val,
      required double temp,
      Value<String?> product,
      Value<String?> batchNo,
      Value<String?> arNo,
      Value<DateTime> createdAt,
    });
typedef $$LogsTableUpdateCompanionBuilder =
    LogsCompanion Function({
      Value<int> id,
      Value<int> deviceId,
      Value<double> val,
      Value<double> temp,
      Value<String?> product,
      Value<String?> batchNo,
      Value<String?> arNo,
      Value<DateTime> createdAt,
    });

final class $$LogsTableReferences
    extends BaseReferences<_$AppDatabase, $LogsTable, Log> {
  $$LogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DevicesTable _deviceIdTable(_$AppDatabase db) => db.devices
      .createAlias($_aliasNameGenerator(db.logs.deviceId, db.devices.id));

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<int>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LogsTableFilterComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get val => $composableBuilder(
    column: $table.val,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arNo => $composableBuilder(
    column: $table.arNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableOrderingComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get val => $composableBuilder(
    column: $table.val,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temp => $composableBuilder(
    column: $table.temp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNo => $composableBuilder(
    column: $table.batchNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arNo => $composableBuilder(
    column: $table.arNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get val =>
      $composableBuilder(column: $table.val, builder: (column) => column);

  GeneratedColumn<double> get temp =>
      $composableBuilder(column: $table.temp, builder: (column) => column);

  GeneratedColumn<String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<String> get batchNo =>
      $composableBuilder(column: $table.batchNo, builder: (column) => column);

  GeneratedColumn<String> get arNo =>
      $composableBuilder(column: $table.arNo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogsTable,
          Log,
          $$LogsTableFilterComposer,
          $$LogsTableOrderingComposer,
          $$LogsTableAnnotationComposer,
          $$LogsTableCreateCompanionBuilder,
          $$LogsTableUpdateCompanionBuilder,
          (Log, $$LogsTableReferences),
          Log,
          PrefetchHooks Function({bool deviceId})
        > {
  $$LogsTableTableManager(_$AppDatabase db, $LogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> deviceId = const Value.absent(),
                Value<double> val = const Value.absent(),
                Value<double> temp = const Value.absent(),
                Value<String?> product = const Value.absent(),
                Value<String?> batchNo = const Value.absent(),
                Value<String?> arNo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LogsCompanion(
                id: id,
                deviceId: deviceId,
                val: val,
                temp: temp,
                product: product,
                batchNo: batchNo,
                arNo: arNo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int deviceId,
                required double val,
                required double temp,
                Value<String?> product = const Value.absent(),
                Value<String?> batchNo = const Value.absent(),
                Value<String?> arNo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LogsCompanion.insert(
                id: id,
                deviceId: deviceId,
                val: val,
                temp: temp,
                product: product,
                batchNo: batchNo,
                arNo: arNo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LogsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable: $$LogsTableReferences
                                    ._deviceIdTable(db),
                                referencedColumn: $$LogsTableReferences
                                    ._deviceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogsTable,
      Log,
      $$LogsTableFilterComposer,
      $$LogsTableOrderingComposer,
      $$LogsTableAnnotationComposer,
      $$LogsTableCreateCompanionBuilder,
      $$LogsTableUpdateCompanionBuilder,
      (Log, $$LogsTableReferences),
      Log,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$HeaderFootersTableCreateCompanionBuilder =
    HeaderFootersCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> selected,
      Value<String?> hTextName,
      Value<String?> hTextPosition,
      Value<String?> hTextSize,
      Value<String?> hTextFont,
      Value<String?> hImagePath,
      Value<double?> hWidth,
      Value<double?> hHeight,
      Value<String?> hImagePos,
      Value<bool> hCompanyName,
      Value<bool> hCalibrate,
      Value<bool> hReportGen,
      Value<bool> hDeviceId,
      Value<String?> fTextName,
      Value<String?> fTextPosition,
      Value<String?> fTextSize,
      Value<String?> fTextFont,
      Value<String?> fImagePath,
      Value<double?> fWidth,
      Value<double?> fHeight,
      Value<String?> fImagePos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$HeaderFootersTableUpdateCompanionBuilder =
    HeaderFootersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> selected,
      Value<String?> hTextName,
      Value<String?> hTextPosition,
      Value<String?> hTextSize,
      Value<String?> hTextFont,
      Value<String?> hImagePath,
      Value<double?> hWidth,
      Value<double?> hHeight,
      Value<String?> hImagePos,
      Value<bool> hCompanyName,
      Value<bool> hCalibrate,
      Value<bool> hReportGen,
      Value<bool> hDeviceId,
      Value<String?> fTextName,
      Value<String?> fTextPosition,
      Value<String?> fTextSize,
      Value<String?> fTextFont,
      Value<String?> fImagePath,
      Value<double?> fWidth,
      Value<double?> fHeight,
      Value<String?> fImagePos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$HeaderFootersTableFilterComposer
    extends Composer<_$AppDatabase, $HeaderFootersTable> {
  $$HeaderFootersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get selected => $composableBuilder(
    column: $table.selected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hTextName => $composableBuilder(
    column: $table.hTextName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hTextPosition => $composableBuilder(
    column: $table.hTextPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hTextSize => $composableBuilder(
    column: $table.hTextSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hTextFont => $composableBuilder(
    column: $table.hTextFont,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hImagePath => $composableBuilder(
    column: $table.hImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hWidth => $composableBuilder(
    column: $table.hWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hHeight => $composableBuilder(
    column: $table.hHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hImagePos => $composableBuilder(
    column: $table.hImagePos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hCompanyName => $composableBuilder(
    column: $table.hCompanyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hCalibrate => $composableBuilder(
    column: $table.hCalibrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hReportGen => $composableBuilder(
    column: $table.hReportGen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hDeviceId => $composableBuilder(
    column: $table.hDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fTextName => $composableBuilder(
    column: $table.fTextName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fTextPosition => $composableBuilder(
    column: $table.fTextPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fTextSize => $composableBuilder(
    column: $table.fTextSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fTextFont => $composableBuilder(
    column: $table.fTextFont,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fImagePath => $composableBuilder(
    column: $table.fImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fWidth => $composableBuilder(
    column: $table.fWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fHeight => $composableBuilder(
    column: $table.fHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fImagePos => $composableBuilder(
    column: $table.fImagePos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeaderFootersTableOrderingComposer
    extends Composer<_$AppDatabase, $HeaderFootersTable> {
  $$HeaderFootersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get selected => $composableBuilder(
    column: $table.selected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hTextName => $composableBuilder(
    column: $table.hTextName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hTextPosition => $composableBuilder(
    column: $table.hTextPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hTextSize => $composableBuilder(
    column: $table.hTextSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hTextFont => $composableBuilder(
    column: $table.hTextFont,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hImagePath => $composableBuilder(
    column: $table.hImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hWidth => $composableBuilder(
    column: $table.hWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hHeight => $composableBuilder(
    column: $table.hHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hImagePos => $composableBuilder(
    column: $table.hImagePos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hCompanyName => $composableBuilder(
    column: $table.hCompanyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hCalibrate => $composableBuilder(
    column: $table.hCalibrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hReportGen => $composableBuilder(
    column: $table.hReportGen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hDeviceId => $composableBuilder(
    column: $table.hDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fTextName => $composableBuilder(
    column: $table.fTextName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fTextPosition => $composableBuilder(
    column: $table.fTextPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fTextSize => $composableBuilder(
    column: $table.fTextSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fTextFont => $composableBuilder(
    column: $table.fTextFont,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fImagePath => $composableBuilder(
    column: $table.fImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fWidth => $composableBuilder(
    column: $table.fWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fHeight => $composableBuilder(
    column: $table.fHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fImagePos => $composableBuilder(
    column: $table.fImagePos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeaderFootersTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeaderFootersTable> {
  $$HeaderFootersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get selected =>
      $composableBuilder(column: $table.selected, builder: (column) => column);

  GeneratedColumn<String> get hTextName =>
      $composableBuilder(column: $table.hTextName, builder: (column) => column);

  GeneratedColumn<String> get hTextPosition => $composableBuilder(
    column: $table.hTextPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hTextSize =>
      $composableBuilder(column: $table.hTextSize, builder: (column) => column);

  GeneratedColumn<String> get hTextFont =>
      $composableBuilder(column: $table.hTextFont, builder: (column) => column);

  GeneratedColumn<String> get hImagePath => $composableBuilder(
    column: $table.hImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hWidth =>
      $composableBuilder(column: $table.hWidth, builder: (column) => column);

  GeneratedColumn<double> get hHeight =>
      $composableBuilder(column: $table.hHeight, builder: (column) => column);

  GeneratedColumn<String> get hImagePos =>
      $composableBuilder(column: $table.hImagePos, builder: (column) => column);

  GeneratedColumn<bool> get hCompanyName => $composableBuilder(
    column: $table.hCompanyName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hCalibrate => $composableBuilder(
    column: $table.hCalibrate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hReportGen => $composableBuilder(
    column: $table.hReportGen,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hDeviceId =>
      $composableBuilder(column: $table.hDeviceId, builder: (column) => column);

  GeneratedColumn<String> get fTextName =>
      $composableBuilder(column: $table.fTextName, builder: (column) => column);

  GeneratedColumn<String> get fTextPosition => $composableBuilder(
    column: $table.fTextPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fTextSize =>
      $composableBuilder(column: $table.fTextSize, builder: (column) => column);

  GeneratedColumn<String> get fTextFont =>
      $composableBuilder(column: $table.fTextFont, builder: (column) => column);

  GeneratedColumn<String> get fImagePath => $composableBuilder(
    column: $table.fImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fWidth =>
      $composableBuilder(column: $table.fWidth, builder: (column) => column);

  GeneratedColumn<double> get fHeight =>
      $composableBuilder(column: $table.fHeight, builder: (column) => column);

  GeneratedColumn<String> get fImagePos =>
      $composableBuilder(column: $table.fImagePos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HeaderFootersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeaderFootersTable,
          HeaderFooter,
          $$HeaderFootersTableFilterComposer,
          $$HeaderFootersTableOrderingComposer,
          $$HeaderFootersTableAnnotationComposer,
          $$HeaderFootersTableCreateCompanionBuilder,
          $$HeaderFootersTableUpdateCompanionBuilder,
          (
            HeaderFooter,
            BaseReferences<_$AppDatabase, $HeaderFootersTable, HeaderFooter>,
          ),
          HeaderFooter,
          PrefetchHooks Function()
        > {
  $$HeaderFootersTableTableManager(_$AppDatabase db, $HeaderFootersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeaderFootersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeaderFootersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeaderFootersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> selected = const Value.absent(),
                Value<String?> hTextName = const Value.absent(),
                Value<String?> hTextPosition = const Value.absent(),
                Value<String?> hTextSize = const Value.absent(),
                Value<String?> hTextFont = const Value.absent(),
                Value<String?> hImagePath = const Value.absent(),
                Value<double?> hWidth = const Value.absent(),
                Value<double?> hHeight = const Value.absent(),
                Value<String?> hImagePos = const Value.absent(),
                Value<bool> hCompanyName = const Value.absent(),
                Value<bool> hCalibrate = const Value.absent(),
                Value<bool> hReportGen = const Value.absent(),
                Value<bool> hDeviceId = const Value.absent(),
                Value<String?> fTextName = const Value.absent(),
                Value<String?> fTextPosition = const Value.absent(),
                Value<String?> fTextSize = const Value.absent(),
                Value<String?> fTextFont = const Value.absent(),
                Value<String?> fImagePath = const Value.absent(),
                Value<double?> fWidth = const Value.absent(),
                Value<double?> fHeight = const Value.absent(),
                Value<String?> fImagePos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HeaderFootersCompanion(
                id: id,
                name: name,
                selected: selected,
                hTextName: hTextName,
                hTextPosition: hTextPosition,
                hTextSize: hTextSize,
                hTextFont: hTextFont,
                hImagePath: hImagePath,
                hWidth: hWidth,
                hHeight: hHeight,
                hImagePos: hImagePos,
                hCompanyName: hCompanyName,
                hCalibrate: hCalibrate,
                hReportGen: hReportGen,
                hDeviceId: hDeviceId,
                fTextName: fTextName,
                fTextPosition: fTextPosition,
                fTextSize: fTextSize,
                fTextFont: fTextFont,
                fImagePath: fImagePath,
                fWidth: fWidth,
                fHeight: fHeight,
                fImagePos: fImagePos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> selected = const Value.absent(),
                Value<String?> hTextName = const Value.absent(),
                Value<String?> hTextPosition = const Value.absent(),
                Value<String?> hTextSize = const Value.absent(),
                Value<String?> hTextFont = const Value.absent(),
                Value<String?> hImagePath = const Value.absent(),
                Value<double?> hWidth = const Value.absent(),
                Value<double?> hHeight = const Value.absent(),
                Value<String?> hImagePos = const Value.absent(),
                Value<bool> hCompanyName = const Value.absent(),
                Value<bool> hCalibrate = const Value.absent(),
                Value<bool> hReportGen = const Value.absent(),
                Value<bool> hDeviceId = const Value.absent(),
                Value<String?> fTextName = const Value.absent(),
                Value<String?> fTextPosition = const Value.absent(),
                Value<String?> fTextSize = const Value.absent(),
                Value<String?> fTextFont = const Value.absent(),
                Value<String?> fImagePath = const Value.absent(),
                Value<double?> fWidth = const Value.absent(),
                Value<double?> fHeight = const Value.absent(),
                Value<String?> fImagePos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => HeaderFootersCompanion.insert(
                id: id,
                name: name,
                selected: selected,
                hTextName: hTextName,
                hTextPosition: hTextPosition,
                hTextSize: hTextSize,
                hTextFont: hTextFont,
                hImagePath: hImagePath,
                hWidth: hWidth,
                hHeight: hHeight,
                hImagePos: hImagePos,
                hCompanyName: hCompanyName,
                hCalibrate: hCalibrate,
                hReportGen: hReportGen,
                hDeviceId: hDeviceId,
                fTextName: fTextName,
                fTextPosition: fTextPosition,
                fTextSize: fTextSize,
                fTextFont: fTextFont,
                fImagePath: fImagePath,
                fWidth: fWidth,
                fHeight: fHeight,
                fImagePos: fImagePos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeaderFootersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeaderFootersTable,
      HeaderFooter,
      $$HeaderFootersTableFilterComposer,
      $$HeaderFootersTableOrderingComposer,
      $$HeaderFootersTableAnnotationComposer,
      $$HeaderFootersTableCreateCompanionBuilder,
      $$HeaderFootersTableUpdateCompanionBuilder,
      (
        HeaderFooter,
        BaseReferences<_$AppDatabase, $HeaderFootersTable, HeaderFooter>,
      ),
      HeaderFooter,
      PrefetchHooks Function()
    >;
typedef $$CompanyDetailsTableCreateCompanionBuilder =
    CompanyDetailsCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String> address,
      Value<String> phone,
      Value<String> email,
      Value<String> website,
      Value<String> gstNo,
      Value<String?> logoPath,
      Value<DateTime> updatedAt,
    });
typedef $$CompanyDetailsTableUpdateCompanionBuilder =
    CompanyDetailsCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String> address,
      Value<String> phone,
      Value<String> email,
      Value<String> website,
      Value<String> gstNo,
      Value<String?> logoPath,
      Value<DateTime> updatedAt,
    });

class $$CompanyDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $CompanyDetailsTable> {
  $$CompanyDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstNo => $composableBuilder(
    column: $table.gstNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompanyDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanyDetailsTable> {
  $$CompanyDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstNo => $composableBuilder(
    column: $table.gstNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompanyDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanyDetailsTable> {
  $$CompanyDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get gstNo =>
      $composableBuilder(column: $table.gstNo, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CompanyDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanyDetailsTable,
          CompanyDetail,
          $$CompanyDetailsTableFilterComposer,
          $$CompanyDetailsTableOrderingComposer,
          $$CompanyDetailsTableAnnotationComposer,
          $$CompanyDetailsTableCreateCompanionBuilder,
          $$CompanyDetailsTableUpdateCompanionBuilder,
          (
            CompanyDetail,
            BaseReferences<_$AppDatabase, $CompanyDetailsTable, CompanyDetail>,
          ),
          CompanyDetail,
          PrefetchHooks Function()
        > {
  $$CompanyDetailsTableTableManager(
    _$AppDatabase db,
    $CompanyDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanyDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanyDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanyDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> website = const Value.absent(),
                Value<String> gstNo = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompanyDetailsCompanion(
                id: id,
                companyName: companyName,
                address: address,
                phone: phone,
                email: email,
                website: website,
                gstNo: gstNo,
                logoPath: logoPath,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> website = const Value.absent(),
                Value<String> gstNo = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CompanyDetailsCompanion.insert(
                id: id,
                companyName: companyName,
                address: address,
                phone: phone,
                email: email,
                website: website,
                gstNo: gstNo,
                logoPath: logoPath,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompanyDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanyDetailsTable,
      CompanyDetail,
      $$CompanyDetailsTableFilterComposer,
      $$CompanyDetailsTableOrderingComposer,
      $$CompanyDetailsTableAnnotationComposer,
      $$CompanyDetailsTableCreateCompanionBuilder,
      $$CompanyDetailsTableUpdateCompanionBuilder,
      (
        CompanyDetail,
        BaseReferences<_$AppDatabase, $CompanyDetailsTable, CompanyDetail>,
      ),
      CompanyDetail,
      PrefetchHooks Function()
    >;
typedef $$ReportFilesTableCreateCompanionBuilder =
    ReportFilesCompanion Function({
      Value<int> id,
      required String fileName,
      required String reportType,
      required String deviceId,
      required String deviceType,
      required String filePath,
      Value<int> fileSize,
      required String generatedBy,
      Value<String> format,
      Value<DateTime> createdAt,
    });
typedef $$ReportFilesTableUpdateCompanionBuilder =
    ReportFilesCompanion Function({
      Value<int> id,
      Value<String> fileName,
      Value<String> reportType,
      Value<String> deviceId,
      Value<String> deviceType,
      Value<String> filePath,
      Value<int> fileSize,
      Value<String> generatedBy,
      Value<String> format,
      Value<DateTime> createdAt,
    });

class $$ReportFilesTableFilterComposer
    extends Composer<_$AppDatabase, $ReportFilesTable> {
  $$ReportFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceType => $composableBuilder(
    column: $table.deviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportFilesTable> {
  $$ReportFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceType => $composableBuilder(
    column: $table.deviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportFilesTable> {
  $$ReportFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get reportType => $composableBuilder(
    column: $table.reportType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get deviceType => $composableBuilder(
    column: $table.deviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get generatedBy => $composableBuilder(
    column: $table.generatedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReportFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportFilesTable,
          ReportFile,
          $$ReportFilesTableFilterComposer,
          $$ReportFilesTableOrderingComposer,
          $$ReportFilesTableAnnotationComposer,
          $$ReportFilesTableCreateCompanionBuilder,
          $$ReportFilesTableUpdateCompanionBuilder,
          (
            ReportFile,
            BaseReferences<_$AppDatabase, $ReportFilesTable, ReportFile>,
          ),
          ReportFile,
          PrefetchHooks Function()
        > {
  $$ReportFilesTableTableManager(_$AppDatabase db, $ReportFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> reportType = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> deviceType = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<String> generatedBy = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReportFilesCompanion(
                id: id,
                fileName: fileName,
                reportType: reportType,
                deviceId: deviceId,
                deviceType: deviceType,
                filePath: filePath,
                fileSize: fileSize,
                generatedBy: generatedBy,
                format: format,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fileName,
                required String reportType,
                required String deviceId,
                required String deviceType,
                required String filePath,
                Value<int> fileSize = const Value.absent(),
                required String generatedBy,
                Value<String> format = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReportFilesCompanion.insert(
                id: id,
                fileName: fileName,
                reportType: reportType,
                deviceId: deviceId,
                deviceType: deviceType,
                filePath: filePath,
                fileSize: fileSize,
                generatedBy: generatedBy,
                format: format,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportFilesTable,
      ReportFile,
      $$ReportFilesTableFilterComposer,
      $$ReportFilesTableOrderingComposer,
      $$ReportFilesTableAnnotationComposer,
      $$ReportFilesTableCreateCompanionBuilder,
      $$ReportFilesTableUpdateCompanionBuilder,
      (
        ReportFile,
        BaseReferences<_$AppDatabase, $ReportFilesTable, ReportFile>,
      ),
      ReportFile,
      PrefetchHooks Function()
    >;
typedef $$PasswordHistoriesTableCreateCompanionBuilder =
    PasswordHistoriesCompanion Function({
      Value<int> id,
      required int userId,
      required String passwordHash,
      Value<DateTime> createdAt,
    });
typedef $$PasswordHistoriesTableUpdateCompanionBuilder =
    PasswordHistoriesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> passwordHash,
      Value<DateTime> createdAt,
    });

class $$PasswordHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $PasswordHistoriesTable> {
  $$PasswordHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PasswordHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PasswordHistoriesTable> {
  $$PasswordHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PasswordHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PasswordHistoriesTable> {
  $$PasswordHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PasswordHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PasswordHistoriesTable,
          PasswordHistory,
          $$PasswordHistoriesTableFilterComposer,
          $$PasswordHistoriesTableOrderingComposer,
          $$PasswordHistoriesTableAnnotationComposer,
          $$PasswordHistoriesTableCreateCompanionBuilder,
          $$PasswordHistoriesTableUpdateCompanionBuilder,
          (
            PasswordHistory,
            BaseReferences<
              _$AppDatabase,
              $PasswordHistoriesTable,
              PasswordHistory
            >,
          ),
          PasswordHistory,
          PrefetchHooks Function()
        > {
  $$PasswordHistoriesTableTableManager(
    _$AppDatabase db,
    $PasswordHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PasswordHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PasswordHistoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PasswordHistoriesCompanion(
                id: id,
                userId: userId,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String passwordHash,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PasswordHistoriesCompanion.insert(
                id: id,
                userId: userId,
                passwordHash: passwordHash,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PasswordHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PasswordHistoriesTable,
      PasswordHistory,
      $$PasswordHistoriesTableFilterComposer,
      $$PasswordHistoriesTableOrderingComposer,
      $$PasswordHistoriesTableAnnotationComposer,
      $$PasswordHistoriesTableCreateCompanionBuilder,
      $$PasswordHistoriesTableUpdateCompanionBuilder,
      (
        PasswordHistory,
        BaseReferences<_$AppDatabase, $PasswordHistoriesTable, PasswordHistory>,
      ),
      PasswordHistory,
      PrefetchHooks Function()
    >;
typedef $$AuditLogsTableCreateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      required String category,
      required String action,
      Value<int?> userId,
      Value<String> userName,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> status,
      Value<String> details,
      Value<String> integrityHash,
      Value<DateTime> createdAt,
    });
typedef $$AuditLogsTableUpdateCompanionBuilder =
    AuditLogsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> action,
      Value<int?> userId,
      Value<String> userName,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> status,
      Value<String> details,
      Value<String> integrityHash,
      Value<DateTime> createdAt,
    });

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get integrityHash => $composableBuilder(
    column: $table.integrityHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get integrityHash => $composableBuilder(
    column: $table.integrityHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get integrityHash => $composableBuilder(
    column: $table.integrityHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogsTable,
          AuditLog,
          $$AuditLogsTableFilterComposer,
          $$AuditLogsTableOrderingComposer,
          $$AuditLogsTableAnnotationComposer,
          $$AuditLogsTableCreateCompanionBuilder,
          $$AuditLogsTableUpdateCompanionBuilder,
          (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
          AuditLog,
          PrefetchHooks Function()
        > {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<String> integrityHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogsCompanion(
                id: id,
                category: category,
                action: action,
                userId: userId,
                userName: userName,
                entityType: entityType,
                entityId: entityId,
                status: status,
                details: details,
                integrityHash: integrityHash,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String action,
                Value<int?> userId = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<String> integrityHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogsCompanion.insert(
                id: id,
                category: category,
                action: action,
                userId: userId,
                userName: userName,
                entityType: entityType,
                entityId: entityId,
                status: status,
                details: details,
                integrityHash: integrityHash,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogsTable,
      AuditLog,
      $$AuditLogsTableFilterComposer,
      $$AuditLogsTableOrderingComposer,
      $$AuditLogsTableAnnotationComposer,
      $$AuditLogsTableCreateCompanionBuilder,
      $$AuditLogsTableUpdateCompanionBuilder,
      (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
      AuditLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$DeviceConfigsTableTableManager get deviceConfigs =>
      $$DeviceConfigsTableTableManager(_db, _db.deviceConfigs);
  $$CalibrationRowsTableTableManager get calibrationRows =>
      $$CalibrationRowsTableTableManager(_db, _db.calibrationRows);
  $$LogsTableTableManager get logs => $$LogsTableTableManager(_db, _db.logs);
  $$HeaderFootersTableTableManager get headerFooters =>
      $$HeaderFootersTableTableManager(_db, _db.headerFooters);
  $$CompanyDetailsTableTableManager get companyDetails =>
      $$CompanyDetailsTableTableManager(_db, _db.companyDetails);
  $$ReportFilesTableTableManager get reportFiles =>
      $$ReportFilesTableTableManager(_db, _db.reportFiles);
  $$PasswordHistoriesTableTableManager get passwordHistories =>
      $$PasswordHistoriesTableTableManager(_db, _db.passwordHistories);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
}
