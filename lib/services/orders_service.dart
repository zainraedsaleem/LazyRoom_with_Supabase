import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/models/cart_item_model.dart';
import 'package:takroom/models/customer_order_model.dart';
import 'package:takroom/models/order_request_item.dart';

class OrderService {
  SupabaseClient _supabase = Supabase.instance.client;

  static String _err(Object e) {
    if (e is PostgrestException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }

  //createOrder (السعر والمورد والمخزون والرصيد تُحسب وتُفحص في السيرفر)
  Future<String> createOrder({required List<OrderRequestItem> items}) async {
    try {
      await _supabase.rpc(
        'create_order',
        params: {
          'p_items': items
              .map((i) => {'product_id': i.productId, 'quantity': i.quantity})
              .toList(),
        },
      );
      return "Order Sent";
    } catch (e) {
      debugPrint('Create order error: $e');
      return "Order Not Sent: ${_err(e)}";
    }
  }

  //createMulteOrder
  static Future<String> createMulteOrder(
    BuildContext context, {
    required List<CartItem> items,
  }) async {
    try {
      final orderitems = items
          .map(
            (i) => OrderRequestItem(productId: i.product.id, quantity: i.quantity),
          )
          .toList();
      return await OrderService().createOrder(items: orderitems);
    } catch (e) {
      print("$e");
      return "Order Not Sent";
    }
  }

  //cancelOrder (pending فقط، وللزبون صاحب الطلب فقط)
  Future<void> cancelOrder(int orderId) async {
    try {
      await _supabase.rpc('cancel_order', params: {'p_order_id': orderId});
    } catch (e) {
      throw Exception(_err(e));
    }
  }

  //Complete Order
  Future<void> completeOrder({required int orderId}) async {
    try {
      await _supabase.rpc('complete_order', params: {'p_order_id': orderId});
    } catch (e) {
      print('Complete order error: $e');
      throw Exception(_err(e));
    }
  }

  //أي تغيير على طلبات الزبون (Stream)
  Stream<List<Map<String, dynamic>>> watchCustomerOrderEvents() {
    final uid = _supabase.auth.currentUser!.id;
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_id', uid);
  }

  //getCustomerOrders
  Future<List<CustomerOrderModel>> getCustomerOrders() async {
    try {
      final response = await _supabase.rpc('get_customer_orders');
      return (response as List)
          .map(
            (e) => CustomerOrderModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } catch (e) {
      print('Get customer orders error: $e');
      throw Exception('Failed to load orders');
    }
  }
}
