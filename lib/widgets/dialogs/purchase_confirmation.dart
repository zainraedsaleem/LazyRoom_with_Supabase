import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/order_request_item.dart';
import 'package:takroom/models/product_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/orders_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class PurchaseConfirmation {
  static void show(BuildContext context, Product product) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return _PurchaseDialog(product: product);
      },
      transitionBuilder: (_, animation, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }
}

class _PurchaseDialog extends StatefulWidget {
  final Product product;

  const _PurchaseDialog({required this.product});

  @override
  State<_PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<_PurchaseDialog> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ICON
                Provider.of<UserProvider>(context).products_with_photos == true
                    ? Container(
                        height: 170,
                        width: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(16),
                          child: Image.network(
                            widget.product.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.deepOrange.shade500,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "Confirm Purchase",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.product.name,
                  style: TextStyle(color: Colors.white.withOpacity(.7)),
                ),

                const SizedBox(height: 20),

                /// PRICE CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(.05),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${widget.product.price} SP",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(.05),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          /// minus
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(.1),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// number
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// plus
                          GestureDetector(
                            onTap: () {
                              setState(() => quantity++);
                            },
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange.withOpacity(.2),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.orange,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [
                    /// ADD TO CART
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).addToCart(context, widget.product, quantity);
                          Navigator.pop(context);

                          // TODO: add to cart logic
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Cart"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(.2)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// BUY NOW
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final items = [
                            OrderRequestItem(
                              productId: widget.product.id,
                              quantity: quantity,
                            ),
                          ];
                          /*
                          if (items[0].quantity *
                                  double.parse(widget.product.price) >
                              double.parse(
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user!.balance,
                              )) {
                            ShowSnackbar.showSnackbar(
                              context,
                              "Insufficient balance. Please add funds to your account.",
                            );
                            Navigator.pop(context);
                          }
*/
                          if (double.parse(
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user!.balance,
                              ) <
                              quantity * widget.product.price) {
                            ShowSnackbar.showSnackbar(
                              context,
                              "You Dont have enough money",
                            );
                            Navigator.pop(context);
                          } else {
                            try {
                              final String message = await OrderService()
                                  .createOrder(items: items);
                              ShowSnackbar.showSnackbar(context, message);
                            } catch (e) {
                              ShowSnackbar.showSnackbar(context, e.toString());
                            }
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.flash_on),
                        label: const Text("Buy Now"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
