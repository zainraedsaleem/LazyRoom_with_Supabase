import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final SupabaseClient _client = Supabase.instance.client;
  bool _ready = false;

  Future<void> init() async {
    if (_ready || kIsWeb) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      _ready = true;
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_ready) await init();
    if (!_ready) return;
    try {
      await _plugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'orders_channel',
            'Orders',
            channelDescription: 'Order notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint('Notification show error: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> watchMyNotifications() {
    final uid = _client.auth.currentUser!.id;
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('id', ascending: false)
        .limit(20);
  }

  Future<void> markRead(List<int> ids) async {
    if (ids.isEmpty) return;
    await _client.rpc('mark_notifications_read', params: {'p_ids': ids});
  }
}
