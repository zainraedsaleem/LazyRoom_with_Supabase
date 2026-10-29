import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/models/account_model.dart';

class AdminService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static String _msg(Object e) {
    if (e is PostgrestException) return e.message;
    if (e is FunctionException) {
      final d = e.details;
      if (d is Map && d['error'] != null) return d['error'].toString();
      return 'Request failed';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  // Get Accounts
  static Future<List<AccountModel>> getAccounts({required String type}) async {
    try {
      final res = await _supabase.rpc(
        'admin_list_accounts',
        params: {'p_role': type},
      );
      return (res as List)
          .map((e) => AccountModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Create Account
  static Future<String> createAccount({
    required Map<String, dynamic> body,
  }) async {
    try {
      final res = await _supabase.functions.invoke(
        'admin-create-user',
        body: body,
      );
      final data = res.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return 'Account created successfully';
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Delete Account
  static Future<String> deleteAccount({required String userId}) async {
    try {
      final res = await _supabase.rpc(
        'admin_delete_account',
        params: {'p_user_id': userId},
      );
      return res.toString();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Ban User
  static Future<String> banUser({required String userId}) async {
    try {
      final res = await _supabase.rpc(
        'admin_set_ban',
        params: {'p_user_id': userId, 'p_ban': true},
      );
      return res.toString();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Unban User
  static Future<String> unbanUser({required String userId}) async {
    try {
      final res = await _supabase.rpc(
        'admin_set_ban',
        params: {'p_user_id': userId, 'p_ban': false},
      );
      return res.toString();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Deposit To Customer
  static Future<String> depositToCustomer({
    required String customerId,
    required int amount,
  }) async {
    try {
      final res = await _supabase.rpc(
        'admin_deposit',
        params: {'p_customer_id': customerId, 'p_amount': amount},
      );
      return res.toString();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  // Withdraw From Supplier
  static Future<String> withdrawFromSupplier({
    required String supplierId,
    required int amount,
  }) async {
    try {
      final res = await _supabase.rpc(
        'admin_withdraw',
        params: {'p_supplier_id': supplierId, 'p_amount': amount},
      );
      return res.toString();
    } catch (e) {
      throw Exception(_msg(e));
    }
  }
}
