// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $TerminalsTable extends Terminals
    with TableInfo<$TerminalsTable, Terminal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TerminalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _terminalNameMeta = const VerificationMeta(
    'terminalName',
  );
  @override
  late final GeneratedColumn<String> terminalName = GeneratedColumn<String>(
    'terminal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, terminalName, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'terminals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Terminal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('terminal_name')) {
      context.handle(
        _terminalNameMeta,
        terminalName.isAcceptableOrUnknown(
          data['terminal_name']!,
          _terminalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_terminalNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Terminal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Terminal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      terminalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terminal_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $TerminalsTable createAlias(String alias) {
    return $TerminalsTable(attachedDatabase, alias);
  }
}

class Terminal extends DataClass implements Insertable<Terminal> {
  final int id;
  final String terminalName;
  final String status;
  const Terminal({
    required this.id,
    required this.terminalName,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['terminal_name'] = Variable<String>(terminalName);
    map['status'] = Variable<String>(status);
    return map;
  }

  TerminalsCompanion toCompanion(bool nullToAbsent) {
    return TerminalsCompanion(
      id: Value(id),
      terminalName: Value(terminalName),
      status: Value(status),
    );
  }

  factory Terminal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Terminal(
      id: serializer.fromJson<int>(json['id']),
      terminalName: serializer.fromJson<String>(json['terminalName']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'terminalName': serializer.toJson<String>(terminalName),
      'status': serializer.toJson<String>(status),
    };
  }

  Terminal copyWith({int? id, String? terminalName, String? status}) =>
      Terminal(
        id: id ?? this.id,
        terminalName: terminalName ?? this.terminalName,
        status: status ?? this.status,
      );
  Terminal copyWithCompanion(TerminalsCompanion data) {
    return Terminal(
      id: data.id.present ? data.id.value : this.id,
      terminalName: data.terminalName.present
          ? data.terminalName.value
          : this.terminalName,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Terminal(')
          ..write('id: $id, ')
          ..write('terminalName: $terminalName, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, terminalName, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Terminal &&
          other.id == this.id &&
          other.terminalName == this.terminalName &&
          other.status == this.status);
}

class TerminalsCompanion extends UpdateCompanion<Terminal> {
  final Value<int> id;
  final Value<String> terminalName;
  final Value<String> status;
  const TerminalsCompanion({
    this.id = const Value.absent(),
    this.terminalName = const Value.absent(),
    this.status = const Value.absent(),
  });
  TerminalsCompanion.insert({
    this.id = const Value.absent(),
    required String terminalName,
    required String status,
  }) : terminalName = Value(terminalName),
       status = Value(status);
  static Insertable<Terminal> custom({
    Expression<int>? id,
    Expression<String>? terminalName,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (terminalName != null) 'terminal_name': terminalName,
      if (status != null) 'status': status,
    });
  }

  TerminalsCompanion copyWith({
    Value<int>? id,
    Value<String>? terminalName,
    Value<String>? status,
  }) {
    return TerminalsCompanion(
      id: id ?? this.id,
      terminalName: terminalName ?? this.terminalName,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (terminalName.present) {
      map['terminal_name'] = Variable<String>(terminalName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TerminalsCompanion(')
          ..write('id: $id, ')
          ..write('terminalName: $terminalName, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _routeNameMeta = const VerificationMeta(
    'routeName',
  );
  @override
  late final GeneratedColumn<String> routeName = GeneratedColumn<String>(
    'route_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fareMeta = const VerificationMeta('fare');
  @override
  late final GeneratedColumn<double> fare = GeneratedColumn<double>(
    'fare',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  @override
  late final GeneratedColumn<int> terminalId = GeneratedColumn<int>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES terminals (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routeName,
    origin,
    destination,
    fare,
    terminalId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Route> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_name')) {
      context.handle(
        _routeNameMeta,
        routeName.isAcceptableOrUnknown(data['route_name']!, _routeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_routeNameMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('fare')) {
      context.handle(
        _fareMeta,
        fare.isAcceptableOrUnknown(data['fare']!, _fareMeta),
      );
    } else if (isInserting) {
      context.missing(_fareMeta);
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_name'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      fare: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fare'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}terminal_id'],
      )!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final int id;
  final String routeName;
  final String origin;
  final String destination;
  final double fare;
  final int terminalId;
  const Route({
    required this.id,
    required this.routeName,
    required this.origin,
    required this.destination,
    required this.fare,
    required this.terminalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['route_name'] = Variable<String>(routeName);
    map['origin'] = Variable<String>(origin);
    map['destination'] = Variable<String>(destination);
    map['fare'] = Variable<double>(fare);
    map['terminal_id'] = Variable<int>(terminalId);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      routeName: Value(routeName),
      origin: Value(origin),
      destination: Value(destination),
      fare: Value(fare),
      terminalId: Value(terminalId),
    );
  }

  factory Route.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      id: serializer.fromJson<int>(json['id']),
      routeName: serializer.fromJson<String>(json['routeName']),
      origin: serializer.fromJson<String>(json['origin']),
      destination: serializer.fromJson<String>(json['destination']),
      fare: serializer.fromJson<double>(json['fare']),
      terminalId: serializer.fromJson<int>(json['terminalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routeName': serializer.toJson<String>(routeName),
      'origin': serializer.toJson<String>(origin),
      'destination': serializer.toJson<String>(destination),
      'fare': serializer.toJson<double>(fare),
      'terminalId': serializer.toJson<int>(terminalId),
    };
  }

  Route copyWith({
    int? id,
    String? routeName,
    String? origin,
    String? destination,
    double? fare,
    int? terminalId,
  }) => Route(
    id: id ?? this.id,
    routeName: routeName ?? this.routeName,
    origin: origin ?? this.origin,
    destination: destination ?? this.destination,
    fare: fare ?? this.fare,
    terminalId: terminalId ?? this.terminalId,
  );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      id: data.id.present ? data.id.value : this.id,
      routeName: data.routeName.present ? data.routeName.value : this.routeName,
      origin: data.origin.present ? data.origin.value : this.origin,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      fare: data.fare.present ? data.fare.value : this.fare,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('id: $id, ')
          ..write('routeName: $routeName, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('fare: $fare, ')
          ..write('terminalId: $terminalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routeName, origin, destination, fare, terminalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route &&
          other.id == this.id &&
          other.routeName == this.routeName &&
          other.origin == this.origin &&
          other.destination == this.destination &&
          other.fare == this.fare &&
          other.terminalId == this.terminalId);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<int> id;
  final Value<String> routeName;
  final Value<String> origin;
  final Value<String> destination;
  final Value<double> fare;
  final Value<int> terminalId;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.routeName = const Value.absent(),
    this.origin = const Value.absent(),
    this.destination = const Value.absent(),
    this.fare = const Value.absent(),
    this.terminalId = const Value.absent(),
  });
  RoutesCompanion.insert({
    this.id = const Value.absent(),
    required String routeName,
    required String origin,
    required String destination,
    required double fare,
    required int terminalId,
  }) : routeName = Value(routeName),
       origin = Value(origin),
       destination = Value(destination),
       fare = Value(fare),
       terminalId = Value(terminalId);
  static Insertable<Route> custom({
    Expression<int>? id,
    Expression<String>? routeName,
    Expression<String>? origin,
    Expression<String>? destination,
    Expression<double>? fare,
    Expression<int>? terminalId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeName != null) 'route_name': routeName,
      if (origin != null) 'origin': origin,
      if (destination != null) 'destination': destination,
      if (fare != null) 'fare': fare,
      if (terminalId != null) 'terminal_id': terminalId,
    });
  }

  RoutesCompanion copyWith({
    Value<int>? id,
    Value<String>? routeName,
    Value<String>? origin,
    Value<String>? destination,
    Value<double>? fare,
    Value<int>? terminalId,
  }) {
    return RoutesCompanion(
      id: id ?? this.id,
      routeName: routeName ?? this.routeName,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      fare: fare ?? this.fare,
      terminalId: terminalId ?? this.terminalId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routeName.present) {
      map['route_name'] = Variable<String>(routeName.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (fare.present) {
      map['fare'] = Variable<double>(fare.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<int>(terminalId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('routeName: $routeName, ')
          ..write('origin: $origin, ')
          ..write('destination: $destination, ')
          ..write('fare: $fare, ')
          ..write('terminalId: $terminalId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TerminalsTable terminals = $TerminalsTable(this);
  late final $RoutesTable routes = $RoutesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [terminals, routes];
}

typedef $$TerminalsTableCreateCompanionBuilder =
    TerminalsCompanion Function({
      Value<int> id,
      required String terminalName,
      required String status,
    });
typedef $$TerminalsTableUpdateCompanionBuilder =
    TerminalsCompanion Function({
      Value<int> id,
      Value<String> terminalName,
      Value<String> status,
    });

final class $$TerminalsTableReferences
    extends BaseReferences<_$AppDatabase, $TerminalsTable, Terminal> {
  $$TerminalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutesTable, List<Route>> _routesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.routes,
    aliasName: $_aliasNameGenerator(db.terminals.id, db.routes.terminalId),
  );

  $$RoutesTableProcessedTableManager get routesRefs {
    final manager = $$RoutesTableTableManager(
      $_db,
      $_db.routes,
    ).filter((f) => f.terminalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_routesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TerminalsTableFilterComposer
    extends Composer<_$AppDatabase, $TerminalsTable> {
  $$TerminalsTableFilterComposer({
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

  ColumnFilters<String> get terminalName => $composableBuilder(
    column: $table.terminalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routesRefs(
    Expression<bool> Function($$RoutesTableFilterComposer f) f,
  ) {
    final $$RoutesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableFilterComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TerminalsTableOrderingComposer
    extends Composer<_$AppDatabase, $TerminalsTable> {
  $$TerminalsTableOrderingComposer({
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

  ColumnOrderings<String> get terminalName => $composableBuilder(
    column: $table.terminalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TerminalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TerminalsTable> {
  $$TerminalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get terminalName => $composableBuilder(
    column: $table.terminalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> routesRefs<T extends Object>(
    Expression<T> Function($$RoutesTableAnnotationComposer a) f,
  ) {
    final $$RoutesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableAnnotationComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TerminalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TerminalsTable,
          Terminal,
          $$TerminalsTableFilterComposer,
          $$TerminalsTableOrderingComposer,
          $$TerminalsTableAnnotationComposer,
          $$TerminalsTableCreateCompanionBuilder,
          $$TerminalsTableUpdateCompanionBuilder,
          (Terminal, $$TerminalsTableReferences),
          Terminal,
          PrefetchHooks Function({bool routesRefs})
        > {
  $$TerminalsTableTableManager(_$AppDatabase db, $TerminalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TerminalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TerminalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TerminalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> terminalName = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => TerminalsCompanion(
                id: id,
                terminalName: terminalName,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String terminalName,
                required String status,
              }) => TerminalsCompanion.insert(
                id: id,
                terminalName: terminalName,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TerminalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (routesRefs) db.routes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routesRefs)
                    await $_getPrefetchedData<Terminal, $TerminalsTable, Route>(
                      currentTable: table,
                      referencedTable: $$TerminalsTableReferences
                          ._routesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TerminalsTableReferences(db, table, p0).routesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.terminalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TerminalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TerminalsTable,
      Terminal,
      $$TerminalsTableFilterComposer,
      $$TerminalsTableOrderingComposer,
      $$TerminalsTableAnnotationComposer,
      $$TerminalsTableCreateCompanionBuilder,
      $$TerminalsTableUpdateCompanionBuilder,
      (Terminal, $$TerminalsTableReferences),
      Terminal,
      PrefetchHooks Function({bool routesRefs})
    >;
typedef $$RoutesTableCreateCompanionBuilder =
    RoutesCompanion Function({
      Value<int> id,
      required String routeName,
      required String origin,
      required String destination,
      required double fare,
      required int terminalId,
    });
typedef $$RoutesTableUpdateCompanionBuilder =
    RoutesCompanion Function({
      Value<int> id,
      Value<String> routeName,
      Value<String> origin,
      Value<String> destination,
      Value<double> fare,
      Value<int> terminalId,
    });

final class $$RoutesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutesTable, Route> {
  $$RoutesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TerminalsTable _terminalIdTable(_$AppDatabase db) => db.terminals
      .createAlias($_aliasNameGenerator(db.routes.terminalId, db.terminals.id));

  $$TerminalsTableProcessedTableManager get terminalId {
    final $_column = $_itemColumn<int>('terminal_id')!;

    final manager = $$TerminalsTableTableManager(
      $_db,
      $_db.terminals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_terminalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
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

  ColumnFilters<String> get routeName => $composableBuilder(
    column: $table.routeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fare => $composableBuilder(
    column: $table.fare,
    builder: (column) => ColumnFilters(column),
  );

  $$TerminalsTableFilterComposer get terminalId {
    final $$TerminalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TerminalsTableFilterComposer(
            $db: $db,
            $table: $db.terminals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
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

  ColumnOrderings<String> get routeName => $composableBuilder(
    column: $table.routeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fare => $composableBuilder(
    column: $table.fare,
    builder: (column) => ColumnOrderings(column),
  );

  $$TerminalsTableOrderingComposer get terminalId {
    final $$TerminalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TerminalsTableOrderingComposer(
            $db: $db,
            $table: $db.terminals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routeName =>
      $composableBuilder(column: $table.routeName, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fare =>
      $composableBuilder(column: $table.fare, builder: (column) => column);

  $$TerminalsTableAnnotationComposer get terminalId {
    final $$TerminalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TerminalsTableAnnotationComposer(
            $db: $db,
            $table: $db.terminals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutesTable,
          Route,
          $$RoutesTableFilterComposer,
          $$RoutesTableOrderingComposer,
          $$RoutesTableAnnotationComposer,
          $$RoutesTableCreateCompanionBuilder,
          $$RoutesTableUpdateCompanionBuilder,
          (Route, $$RoutesTableReferences),
          Route,
          PrefetchHooks Function({bool terminalId})
        > {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> routeName = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<double> fare = const Value.absent(),
                Value<int> terminalId = const Value.absent(),
              }) => RoutesCompanion(
                id: id,
                routeName: routeName,
                origin: origin,
                destination: destination,
                fare: fare,
                terminalId: terminalId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String routeName,
                required String origin,
                required String destination,
                required double fare,
                required int terminalId,
              }) => RoutesCompanion.insert(
                id: id,
                routeName: routeName,
                origin: origin,
                destination: destination,
                fare: fare,
                terminalId: terminalId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoutesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({terminalId = false}) {
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
                    if (terminalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.terminalId,
                                referencedTable: $$RoutesTableReferences
                                    ._terminalIdTable(db),
                                referencedColumn: $$RoutesTableReferences
                                    ._terminalIdTable(db)
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

typedef $$RoutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutesTable,
      Route,
      $$RoutesTableFilterComposer,
      $$RoutesTableOrderingComposer,
      $$RoutesTableAnnotationComposer,
      $$RoutesTableCreateCompanionBuilder,
      $$RoutesTableUpdateCompanionBuilder,
      (Route, $$RoutesTableReferences),
      Route,
      PrefetchHooks Function({bool terminalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TerminalsTableTableManager get terminals =>
      $$TerminalsTableTableManager(_db, _db.terminals);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
}
