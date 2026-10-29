import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/supplier_order_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/refresh_balance_service.dart';
import 'package:takroom/services/supplier_order_service.dart';
import 'package:takroom/widgets/listes_view/supplier_order_list_view.dart';

class SupplierOrdersTab extends StatefulWidget {
  const SupplierOrdersTab({super.key});

  @override
  State<SupplierOrdersTab> createState() => _SupplierOrdersTabState();
}

class _SupplierOrdersTabState extends State<SupplierOrdersTab> {
  @override
  void initState() {
    super.initState();
    // الرصيد والطلبات تصل تلقائياً عبر Stream
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false).startRealtime(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menu Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Theme.of(context).brightness == Brightness.light
                        ? Image.asset("assets/light_icon_logo.jpg")
                        : Image.asset("assets/dark_icon_logo.jpg"),
                  ),
                ),

                // Logo
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Lazy",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: "Room",
                            style: TextStyle(
                              color: Color(0xffF9A825),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Order. Relax. We deliver",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.info_outline),
                ),
                // Notification Button
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xffFFA000), Color(0xffFBC02D)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    // Left Side
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xffF9A825),
                              size: 35,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<UserProvider>(context).user!.name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Supplier",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Wallet Box
                    GestureDetector(
                      child: Container(
                        width: 120,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Color(0xffF9A825),
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            Text(
                              Provider.of<UserProvider>(context).isLodingBalance
                                  ? "?????"
                                  : Provider.of<UserProvider>(
                                      context,
                                    ).user!.balance,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Text(
                  "Orders:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SupplierOrderListView(),
          ],
        ),
      ),
    );
  }
}
