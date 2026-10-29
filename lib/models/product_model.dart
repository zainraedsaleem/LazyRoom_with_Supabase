class Product {
  final int id;
  final String name;
  final String? description;
  final String imageUrl;
  final double price;
  final int stock;
  final int category_id;
  final supplier_id;
  final supplier_name;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    required this.price,
    required this.stock,
    required this.category_id,
    required this.supplier_id,
    required this.supplier_name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: (json['image_url'] ?? '') as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      category_id: json['category_id'],
      supplier_id: json['supplier_id'],
      supplier_name: json['users']['name'],
    );
  }
}
