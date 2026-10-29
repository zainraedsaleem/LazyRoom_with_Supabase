import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/models/supplier_order_model.dart';

class SupplierOrderService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // =========================
  // getSupplierOrders
  // =========================

  static Future<List<SupplierOrderModel>> getSupplierOrders() async {
    try {
      final supplierId = _supabase.auth.currentUser?.id;

      if (supplierId == null) {
        throw Exception('Supplier is not logged in');
      }

      final response = await _supabase.rpc('get_supplier_orders');

      final orders = (response as List).map((order) {
        final data = Map<String, dynamic>.from(order as Map);

        final customer = data['customer'];

        // إنشاء الشكل الذي يتوقعه SupplierOrderModel
        data['customer_name'] = customer['name'];

        data['delivery_address'] = {
          'building': customer['building'],
          'room_number': customer['room_number'],
        };

        final items = (data['items'] as List).map((item) {
          final product = item['product'];

          final quantity = item['quantity'] as int;
          final price = (item['price'] as num).toDouble();

          return {
            'product_name': product['name'],
            'quantity': quantity,
            'price': price,
            'subtotal': price * quantity,
          };
        }).toList();

        data['items'] = items;

        data['my_products_total'] = items.fold<double>(
          0,
          (total, item) => total + (item['subtotal'] as double),
        );

        return SupplierOrderModel.fromJson(data);
      }).toList();

      return orders;
    } catch (e) {
      print('Get supplier orders error: $e');
      throw Exception('Failed to load supplier orders');
    }
  }

  // =========================
  // acceptOrder
  // =========================

  static Future<String> acceptOrder({required int orderId}) async {
    try {
      await _supabase.rpc('accept_order', params: {'p_order_id': orderId});

      return 'Order accepted successfully';
    } catch (e) {
      print('Accept order error: $e');

      throw Exception(_err(e));
    }
  }

  // =========================
  // rejectOrder
  // =========================

  static Future<String> rejectOrder({required int orderId}) async {
    try {
      await _supabase.rpc('reject_order', params: {'p_order_id': orderId});
      return 'Order rejected successfully';
    } catch (e) {
      print('Reject order error: $e');
      throw Exception(_err(e));
    }
  }

  //أي تغيير على طلبات المورد (Stream) — يصل الطلب الجديد فوراً
  static Stream<List<Map<String, dynamic>>> watchSupplierOrderEvents() {
    final uid = _supabase.auth.currentUser!.id;
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('supplier_id', uid);
  }

  static String _err(Object e) {
    if (e is PostgrestException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}
