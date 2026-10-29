class CustomerOrderModel {
  final int orderId;
  String state;
  final double totalPrice;
  final String createdAt;
  final List<OrderItemModel> items;

  CustomerOrderModel({
    required this.orderId,
    required this.state,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderModel(
      orderId: json['id'],
      state: json['state'],
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: json['created_at'],
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int itemId;
  final String productName;
  final int quantity;
  final double pricePerItem;
  final double subtotal;

  OrderItemModel({
    required this.itemId,
    required this.productName,
    required this.quantity,
    required this.pricePerItem,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final int quantity = json['quantity'];
    final double price = (json['price'] as num).toDouble();

    return OrderItemModel(
      itemId: json['id'],
      productName: json['product']['name'],
      quantity: quantity,
      pricePerItem: price,
      subtotal: price * quantity,
    );
  }
}
