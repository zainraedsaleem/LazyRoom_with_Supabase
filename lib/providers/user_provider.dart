import 'dart:async';

import 'package:flutter/material.dart';
import 'package:takroom/app_keys.dart';
import 'package:takroom/services/auth_service.dart';
import 'package:takroom/services/local_storage_service.dart';
import 'package:takroom/services/notification_service.dart';
import 'package:takroom/services/order_stats_service.dart';
import 'package:takroom/views/login_view.dart';
import 'package:takroom/models/account_model.dart';
import 'package:takroom/models/cart_item_model.dart';
import 'package:takroom/models/customer_order_model.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/models/supplier_order_model.dart';
import 'package:takroom/models/user_model.dart';
import 'package:takroom/services/admin_service.dart';
import 'package:takroom/services/orders_service.dart';
import 'package:takroom/services/product_service.dart';
import 'package:takroom/services/refresh_balance_service.dart';
import 'package:takroom/services/supplier_order_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({
    bool productsWithPhotos = false,
    ThemeMode themeMode = ThemeMode.system,
  }) : products_with_photos = productsWithPhotos,
       _themeMode = themeMode;

  //global variabls
  UserModel? _user;
  ThemeMode _themeMode;

  //Realtime
  StreamSubscription? _balanceSub;
  StreamSubscription? _ordersSub;
  StreamSubscription? _notifSub;
  bool _realtimeStarted = false;
  bool _ordersBusy = false;
  bool _ordersAgain = false;
  final Set<int> _shownNotifications = {};

  //Stats
  int completedOrdersCount = 0;
  int receivedOrdersCount = 0;

  //Accounts (admin)
  String accountsType = 'customer';

  //Lists
  List<SupplierOrderModel> _supplier_orders = [];
  List<CustomerOrderModel> orders = [];
  List<Product> products = [];
  List<Product> supplierproducts = [];
  List<CartItem> cart_items = [];
  List<AccountModel> accounts = [];

  //Booleans
  bool isLoadingAccounts = false;
  bool isLodingCustomerOrders = false;
  bool isLodingSupplierOrders = false;
  bool isLodingProducts = false;
  bool isLodingSupplierProducts = false;
  bool isLodingBalance = false;
  bool products_with_photos;

  //Getters
  List<SupplierOrderModel> get supplier_orders => _supplier_orders;
  int get itemCount => cart_items.length;
  UserModel? get user => _user;
  double get totalPrice {
    return cart_items.fold(0, (sum, item) => sum + item.total);
  }

  //Seters
  //setSupplierOrders
  void setSupplierOrders(List<SupplierOrderModel> newOrders) {
    _supplier_orders = newOrders;
    notifyListeners();
  }

  void setProductsWithPhotos(bool w) {
    products_with_photos = w;
    notifyListeners();
    LocalStorageService.saveProductsWithPhotos(w);
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    LocalStorageService.saveThemeMode(mode);
  }

  //System -> On -> Off -> System
  void cycleThemeMode() {
    setThemeMode(switch (_themeMode) {
      ThemeMode.system => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.system,
    });
  }

  //User Setter Used in Auth
  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  //setUser (Splash / Login / Register) ثم تشغيل الـ Streams
  void setUser(UserModel newUser) {
    user = newUser;
    startRealtime();
  }

  //clearUser
  void clearUser() {
    stopRealtime();
    orders = [];
    _supplier_orders = [];
    cart_items = [];
    accounts = [];
    completedOrdersCount = 0;
    receivedOrdersCount = 0;
    user = null;
  }

  //تسجيل الخروج: إنهاء الجلسة فعلياً + إيقاف الـ Streams
  Future<void> logout() async {
    stopRealtime();
    await AuthService().logout();
    clearUser();
  }

  //Realtime------------------------------------------------------------------
  void startRealtime() {
    final u = _user;
    if (u == null || _realtimeStarted) return;
    _realtimeStarted = true;
    NotificationService.instance.init();

    //Balance + ban
    isLodingBalance = true;
    _balanceSub = RefreshBalanceService().watchOwnUserRow().listen(
      (row) {
        if (_user == null) return;
        _user!.balance = (row['balance'] as num).toDouble().toString();
        isLodingBalance = false;
        notifyListeners();
        if (row['is_banned'] == true) _forceLogout('Your account has been banned');
      },
      onError: (e) {
        debugPrint('Balance stream error: $e');
        isLodingBalance = false;
        notifyListeners();
      },
    );

    //Orders
    if (u.role == 'customer') {
      isLodingCustomerOrders = true;
      _ordersSub = OrderService().watchCustomerOrderEvents().listen(
        (_) => _refreshOrders(),
        onError: (e) => debugPrint('Orders stream error: $e'),
      );
      _refreshOrders();
    } else if (u.role == 'supplier') {
      isLodingSupplierOrders = true;
      _ordersSub = SupplierOrderService.watchSupplierOrderEvents().listen(
        (_) => _refreshOrders(),
        onError: (e) => debugPrint('Orders stream error: $e'),
      );
      _refreshOrders();
    }

    //Notifications (supplier: new order | customer: accepted / rejected)
    if (u.role == 'customer' || u.role == 'supplier') {
      _notifSub = NotificationService.instance.watchMyNotifications().listen(
        _onNotifications,
        onError: (e) => debugPrint('Notifications stream error: $e'),
      );
    }
  }

  void stopRealtime() {
    _balanceSub?.cancel();
    _ordersSub?.cancel();
    _notifSub?.cancel();
    _balanceSub = _ordersSub = _notifSub = null;
    _realtimeStarted = false;
    _shownNotifications.clear();
  }

  //إعادة جلب الطلبات + الإحصائيات عند أي تغيير (مع منع التداخل)
  Future<void> _refreshOrders() async {
    final role = _user?.role;
    if (role != 'customer' && role != 'supplier') return;
    if (_ordersBusy) {
      _ordersAgain = true;
      return;
    }
    _ordersBusy = true;
    try {
      do {
        _ordersAgain = false;
        if (role == 'customer') {
          orders = await OrderService().getCustomerOrders();
        } else {
          _supplier_orders = await SupplierOrderService.getSupplierOrders();
        }
        try {
          final stats = await OrderStatsService.getStats();
          completedOrdersCount = stats.completed;
          receivedOrdersCount = stats.received;
        } catch (e) {
          debugPrint('Stats error: $e');
        }
        notifyListeners();
      } while (_ordersAgain);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _ordersBusy = false;
      isLodingCustomerOrders = false;
      isLodingSupplierOrders = false;
      notifyListeners();
    }
  }

  Future<void> _onNotifications(List<Map<String, dynamic>> rows) async {
    final unread = rows
        .where(
          (r) =>
              r['is_read'] == false &&
              !_shownNotifications.contains(r['id'] as int),
        )
        .toList()
      ..sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    if (unread.isEmpty) return;

    for (final n in unread.take(5)) {
      _shownNotifications.add(n['id'] as int);
      await NotificationService.instance.show(
        id: n['id'] as int,
        title: n['title'] as String,
        body: n['body'] as String,
      );
    }
    final ids = unread.map((n) => n['id'] as int).toList();
    _shownNotifications.addAll(ids);
    try {
      await NotificationService.instance.markRead(ids);
    } catch (e) {
      debugPrint('Mark read error: $e');
    }
  }

  Future<void> _forceLogout(String message) async {
    await logout();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginView()),
      (route) => false,
    );
  }

  //Function

  //Cart Functions---------------------------------------------------------------

  //addToCart
  void addToCart(BuildContext context, Product product, int quantity) {
    // إذا كانت السلة غير فارغة تحقق من أن المزود نفسه
    if (cart_items.isNotEmpty &&
        cart_items.first.product.supplier_id != product.supplier_id) {
      ShowSnackbar.showSnackbar(
        context,
        "You can only add products from one supplier at a time",
      );
      return;
    }
    final index = cart_items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (index != -1) {
      cart_items[index].quantity += quantity;
    } else {
      cart_items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  //removeFromCart
  void removeFromCart(int productId) {
    cart_items.removeWhere((item) => item.product.id == productId);

    notifyListeners();
  }

  //clearCart
  void clearCart() {
    cart_items.clear();
    notifyListeners();
  }

  //Admin-------------------------------------------------------------------------
  //fetchAccounts
  Future<void> fetchAccounts(String type) async {
    try {
      accountsType = type;
      isLoadingAccounts = true;
      notifyListeners();

      accounts = await AdminService.getAccounts(type: type);
    } catch (e) {
      debugPrint('Fetch accounts error: $e');
    } finally {
      isLoadingAccounts = false;
      notifyListeners();
    }
  }

  //إعادة تحميل القائمة المعروضة حالياً (customer / supplier)
  Future<void> refreshAccounts() async {
    try {
      await fetchAccounts(accountsType);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //removeAccount
  void removeAccount(String accountId) {
    accounts.removeWhere((account) => account.id == accountId);
    notifyListeners();
  }

  //Customer-------------------------------------------------------------------------
  //fetchProducts
  Future<void> fetchProducts(BuildContext context, index) async {
    isLodingProducts = true;
    notifyListeners();
    try {
      products = await ProductService().getProductsByCategory(id: index);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingProducts = false;
    notifyListeners();
  }

  //RefreshBalance
  Future<void> RefreshBalance(double value) async {
    isLodingBalance = true;
    notifyListeners();
    user!.balance = value.toString();
    isLodingBalance = false;
    notifyListeners();
  }

  //fetchAllProducts
  Future<void> fetchAllProducts(BuildContext context) async {
    isLodingProducts = true;
    notifyListeners();
    try {
      products = await ProductService().getProducts();
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingProducts = false;
    notifyListeners();
  }

  //fetchOrders (احتياطي — التحديث يتم تلقائياً عبر الـ Stream)
  Future<void> fetchOrders(String token) => _refreshOrders();

  //cancelOrder
  Future<void> cancelOrder(String token, int orderId) async {
    try {
      await OrderService().cancelOrder(orderId);
    } catch (e) {
      await _refreshOrders();
      rethrow;
    }
  }

  //completeOrder
  Future<void> completeOrder(int orderId, BuildContext context) async {
    try {
      await OrderService().completeOrder(orderId: orderId);
    } catch (e) {
      ShowSnackbar.showSnackbar(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  //Supplier-------------------------------------------------------------------------

  //fetchSupplierProducts
  Future<void> fetchSupplierProducts(BuildContext context) async {
    isLodingSupplierProducts = true;
    notifyListeners();
    try {
      supplierproducts = await ProductService().getSupplierProducts();
    } catch (e) {
      debugPrint(e.toString());
    }
    isLodingSupplierProducts = false;
    notifyListeners();
  }

  //fetchSupplierOrders (احتياطي — التحديث يتم تلقائياً عبر الـ Stream)
  Future<void> fetchSupplierOrders(String token) => _refreshOrders();
}
