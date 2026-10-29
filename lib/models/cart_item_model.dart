import 'package:takroom/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => double.parse(product.price.toString()) * quantity;
  Map<String, dynamic> toJson() {
    return {"product_id": product.id, "quantity": quantity};
  }
}
