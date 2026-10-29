import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/widgets/suppliser_product_card.dart';

class SupplierProductsListView extends StatefulWidget {
  SupplierProductsListView({super.key});

  @override
  State<SupplierProductsListView> createState() =>
      _SupplierProductsListViewState();
}

class _SupplierProductsListViewState extends State<SupplierProductsListView> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<UserProvider>(
      context,
      listen: true,
    ).supplierproducts;
    if (Provider.of<UserProvider>(context).isLodingSupplierProducts) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (Provider.of<UserProvider>(context).supplierproducts.isEmpty)
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
          return SuppliserProductCard(product: products[index]);
        },
      ),
    );
  }
}
