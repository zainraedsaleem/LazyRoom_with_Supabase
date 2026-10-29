import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/widgets/product_card.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<UserProvider>(context).products;
    if (Provider.of<UserProvider>(context).isLodingProducts) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (Provider.of<UserProvider>(context).products.isEmpty)
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: Text("No Products")),
        ),
      );
    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
