class SupplierOrderModel {
  final int orderId;
  String state;
  final String customerName;
  final DeliveryAddress deliveryAddress;
  final String createdAt;
  final double myProductsTotal;
  final List<SupplierOrderItem> items;

  SupplierOrderModel({
    required this.orderId,
    required this.state,
    required this.customerName,
    required this.deliveryAddress,
    required this.createdAt,
    required this.myProductsTotal,
    required this.items,
  });

  factory SupplierOrderModel.fromJson(Map<String, dynamic> json) {
    return SupplierOrderModel(
      orderId: json['id'],

      state: json['state'],

      customerName: json['customer_name'],

      deliveryAddress: DeliveryAddress.fromJson(json['delivery_address']),

      createdAt: json['created_at'],

      myProductsTotal: json['my_products_total'].toDouble(),

      items: (json['items'] as List)
          .map((e) => SupplierOrderItem.fromJson(e))
          .toList(),
    );
  }
  @override
  String toString() {
    return '''
Order ID: $orderId
Customer: $customerName
State: $state
Total: $myProductsTotal
''';
  }
}

class DeliveryAddress {
  final String building;
  final String roomNumber;

  DeliveryAddress({required this.building, required this.roomNumber});

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      building: (json['building'] ?? '').toString(),
      roomNumber: (json['room_number'] ?? '').toString(),
    );
  }
}

class SupplierOrderItem {
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  SupplierOrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory SupplierOrderItem.fromJson(Map<String, dynamic> json) {
    return SupplierOrderItem(
      productName: json['product_name'],

      quantity: json['quantity'],

      price: json['price'].toDouble(),

      subtotal: json['subtotal'].toDouble(),
    );
  }
}
