import 'package:supabase_flutter/supabase_flutter.dart';

class OrderStats {
  final int completed;
  final int received;
  const OrderStats({this.completed = 0, this.received = 0});
}

class OrderStatsService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<OrderStats> getStats() async {
    final res = await _supabase.rpc('get_order_stats');
    final map = Map<String, dynamic>.from(res as Map);
    return OrderStats(
      completed: (map['completed'] as num?)?.toInt() ?? 0,
      received: (map['received'] as num?)?.toInt() ?? 0,
    );
  }
}
