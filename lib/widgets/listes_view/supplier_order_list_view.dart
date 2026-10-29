import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/supplier_order_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class SupplierOrderListView extends StatefulWidget {
  const SupplierOrderListView({super.key});

  @override
  State<SupplierOrderListView> createState() => _SupplierOrderListViewState();
}

class _SupplierOrderListViewState extends State<SupplierOrderListView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final token = Provider.of<UserProvider>(
        context,
        listen: false,
      ).user!.token;

      Provider.of<UserProvider>(
        context,
        listen: false,
      ).fetchSupplierOrders(token);
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

    if (provider.isLodingSupplierOrders) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (provider.supplier_orders.isEmpty) {
      return Center(
        child: Container(
          height: 400,
          width: double.infinity,
          child: const Center(child: Text("No Orders")),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: provider.supplier_orders.length,

        itemBuilder: (context, index) {
          final order = provider.supplier_orders[index];

          final statusColor = getStatusColor(order.state);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),

              childrenPadding: const EdgeInsets.all(16),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(Icons.shopping_bag, color: Colors.orange),
                  ),

                  const SizedBox(width: 14),

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

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
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
                      const Text("Your Profit"),

                      Text(
                        "${order.myProductsTotal} sp",

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
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.orange),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              order.customerName,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Building ${order.deliveryAddress.building} - Room ${order.deliveryAddress.roomNumber}",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

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

                                const SizedBox(height: 5),

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
                              fontSize: 16,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8),

                if (order.state == "pending")
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final message =
                                  await SupplierOrderService.acceptOrder(
                                    orderId: order.orderId,
                                  );

                              ShowSnackbar.showSnackbar(context, message);
                            } catch (e) {
                              ShowSnackbar.showSnackbar(context, e.toString());
                            }
                          },

                          icon: const Icon(Icons.check),

                          label: const Text("Accept"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,

                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(vertical: 14),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final message =
                                  await SupplierOrderService.rejectOrder(
                                    orderId: order.orderId,
                                  );

                              ShowSnackbar.showSnackbar(context, message);
                            } catch (e) {
                              ShowSnackbar.showSnackbar(context, e.toString());
                            }
                          },

                          icon: const Icon(Icons.close),

                          label: const Text("Reject"),

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
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
