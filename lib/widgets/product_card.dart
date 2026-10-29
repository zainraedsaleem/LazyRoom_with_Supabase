import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/widgets/dialogs/purchase_confirmation.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PurchaseConfirmation.show(context, widget.product);
      },
      child: Provider.of<UserProvider>(context).products_with_photos == false
          ? Container(
              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: widget.product.category_id == 1
                        ? Icon(Icons.lunch_dining, color: Colors.orange)
                        : widget.product.category_id == 2
                        ? Icon(Icons.wine_bar, color: Colors.orange)
                        : widget.product.category_id == 3
                        ? Icon(Icons.kitchen, color: Colors.orange)
                        : widget.product.category_id == 4
                        ? Icon(Icons.cookie, color: Colors.orange)
                        : Icon(Icons.fastfood, color: Colors.orange),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          widget.product.name,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Supplier: ${widget.product.supplier_name}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "${widget.product.price} sp",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.only(
                right: 15,
                top: 5,
                bottom: 5,
                left: 5,
              ),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      child: Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          widget.product.name,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "Supplier: ${widget.product.supplier_name}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "${widget.product.price} sp",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
