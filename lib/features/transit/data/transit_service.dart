import 'package:drift/drift.dart';
import '../../core/database/drift_database.dart';

/// Mock TransitService acting as a bridge for MCP (Supabase/n8n) hook.
class TransitService {
  final AppDatabase db;

  TransitService(this.db);

  /// Called after successful login to trigger MCP data fetch
  /// and persist to Drift database.
  Future<void> syncRemoteTransitData() async {
    // 1. In a real scenario, invoke Supabase or n8n webhook to fetch route JSON.
    // 2. Here we simulate the MCP response.

    await Future.delayed(const Duration(seconds: 2));

    // Upsert Terminal
    final terminalId = await db.into(db.terminals).insertOnConflictUpdate(
      const TerminalsCompanion(
        id: Value(1),
        terminalName: Value('North Avenue Grand Terminal'),
        status: Value('Active'),
      ),
    );

    // Upsert Routes
    final routesToInsert = [
      RoutesCompanion(
        id: const Value(101),
        routeName: const Value('City Express'),
        origin: const Value('North Ave'),
        destination: const Value('South IT Park'),
        fare: const Value(25.50),
        terminalId: Value(terminalId),
      ),
      RoutesCompanion(
        id: const Value(102),
        routeName: const Value('Campus Loop'),
        origin: const Value('North Ave'),
        destination: const Value('University Town'),
        fare: const Value(15.00),
        terminalId: Value(terminalId),
      ),
      RoutesCompanion(
        id: const Value(103),
        routeName: const Value('Midnight Owl'),
        origin: const Value('North Ave'),
        destination: const Value('Downtown Hub'),
        fare: const Value(35.00),
        terminalId: Value(terminalId),
      ),
    ];

    for (final r in routesToInsert) {
      await db.into(db.routes).insertOnConflictUpdate(r);
    }
  }
}
