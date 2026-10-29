import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/services/refresh_balance_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

import '../../providers/user_provider.dart';

class CustomerOrderListView extends StatefulWidget {
  const CustomerOrderListView({super.key});

  @override
  State<CustomerOrderListView> createState() => _CustomerOrderListViewState();
}

class _CustomerOrderListViewState extends State<CustomerOrderListView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final token = Provider.of<UserProvider>(
        context,
        listen: false,
      ).user!.token;

      Provider.of<UserProvider>(context, listen: false).fetchOrders(token);
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;

      case 'accept':
        return Colors.green;

      case 'complete':
        return Colors.lightBlueAccent;

      case 'cancelled':
        return Colors.red;

      case 'reject':
        return Colors.redAccent;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    if (provider.isLodingCustomerOrders) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (provider.orders.isEmpty) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: Text("No Orders Yet")),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.orders.length,

      itemBuilder: (context, index) {
        final order = provider.orders[index];

        final statusColor = getStatusColor(order.state);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),

          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),

            childrenPadding: const EdgeInsets.all(16),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(Icons.receipt_long, color: Colors.orange),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Order #${order.orderId}",

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Text(
                          order.state.toUpperCase(),

                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    const Text("Total"),

                    Text(
                      "${order.totalPrice} \sp",

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            children: [
              Column(
                children: order.items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,

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

                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                item.productName,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Quantity: ${item.quantity}",

                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          "${item.subtotal} sp",

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              if (order.state == "pending")
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final token = provider.user!.token;

                      try {
                        await provider.cancelOrder(token, order.orderId);
                      } catch (e) {
                        ShowSnackbar.showSnackbar(
                          context,
                          e.toString().replaceFirst('Exception: ', ''),
                        );
                      }
                    },

                    icon: const Icon(Icons.close),

                    label: const Text("Cancel Order"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,

                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              if (order.state == "accept")
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await provider.completeOrder(order.orderId, context);
                    },

                    icon: const Icon(Icons.check),

                    label: const Text("Complete Order"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,

                      foregroundColor: Colors.white,

                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
