import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

class Terminals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get terminalName => text()();
  TextColumn get status => text()(); // "Active", "Delayed", "Pending"
}

class Routes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get routeName => text()();
  TextColumn get origin => text()();
  TextColumn get destination => text()();
  RealColumn get fare => real()();
  IntColumn get terminalId => integer().references(Terminals, #id)();
}

@DriftDatabase(tables: [Terminals, Routes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Watch terminal by ID
  Stream<Terminal> watchTerminal(int id) {
    return (select(terminals)..where((t) => t.id.equals(id))).watchSingle();
  }

  // Watch routes for a terminal
  Stream<List<Route>> watchRoutes(int terminalId) {
    return (select(routes)..where((r) => r.terminalId.equals(terminalId))).watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'smartsakay_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
