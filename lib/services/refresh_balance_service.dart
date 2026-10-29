import 'package:supabase_flutter/supabase_flutter.dart';

class RefreshBalanceService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<Map<String, dynamic>> watchOwnUserRow() {
    final uid = _client.auth.currentUser!.id;
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .where((rows) => rows.isNotEmpty)
        .map((rows) => rows.first);
  }

  Stream<double> watchBalance() =>
      watchOwnUserRow().map((row) => (row['balance'] as num).toDouble());

  Future<double> refreshBalance() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('users')
        .select('balance')
        .eq('id', userId)
        .single();
    return (data['balance'] as num).toDouble();
  }
}
