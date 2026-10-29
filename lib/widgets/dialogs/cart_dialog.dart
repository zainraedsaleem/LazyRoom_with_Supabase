import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/orders_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class CartDialog {
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const _CartDialogView();
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

class _CartDialogView extends StatelessWidget {
  const _CartDialogView();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<UserProvider>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(.08),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        cart.clearCart();
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                if (cart.cart_items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Cart is empty",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: cart.cart_items.length,
                      itemBuilder: (context, index) {
                        final item = cart.cart_items[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.05),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "${item.quantity} × ${item.product.price}",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cart.removeFromCart(item.product.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${cart.totalPrice.toStringAsFixed(2)} SP",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.deepOrange.shade500,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: cart.cart_items.isEmpty
                        ? null
                        : () async {
                            if (double.parse(
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).user!.balance,
                                ) <
                                cart.totalPrice) {
                              ShowSnackbar.showSnackbar(
                                context,
                                "You Dont have enough money",
                              );
                              Navigator.pop(context);
                            } else {
                              try {
                                final String message =
                                    await OrderService.createMulteOrder(
                                      context,
                                      items: Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).cart_items,
                                    );
                                ShowSnackbar.showSnackbar(context, message);
                              } catch (e) {
                                ShowSnackbar.showSnackbar(
                                  context,
                                  e.toString(),
                                );
                              }
                              cart.clearCart();
                              Navigator.pop(context);
                            }
                            // TODO: go to checkout
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
