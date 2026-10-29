import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/widgets/dialogs/ban_account_dialog.dart';
import 'package:takroom/widgets/dialogs/delete_account_dialog.dart';
import 'package:takroom/widgets/dialogs/unban_account_dialog.dart';
import 'package:takroom/widgets/dialogs/withdraw_from_supplier_dialog.dart';

class SupplierAccountsListView extends StatefulWidget {
  const SupplierAccountsListView({super.key});

  @override
  State<SupplierAccountsListView> createState() =>
      _SupplierAccountsListViewState();
}

class _SupplierAccountsListViewState extends State<SupplierAccountsListView> {
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
      ).fetchAccounts("supplier");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    if (provider.isLoadingAccounts) {
      return Container(
        height: 400,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.accounts.isEmpty) {
      return Container(
        height: 400,
        width: double.infinity,
        child: Center(child: Text("No Accounts")),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: provider.accounts.length,
        itemBuilder: (context, index) {
          final account = provider.accounts[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,

              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide.none,
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide.none,
              ),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 6,
              ),

              title: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              account.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          account.role.toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Icon(
                        account.isBanned ? Icons.block : Icons.check_circle,
                        size: 18,
                        color: account.isBanned ? Colors.red : Colors.green,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        account.isBanned ? "Banned" : "Active",
                        style: TextStyle(
                          color: account.isBanned ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,

                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.orange,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "${account.balance} SP",

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(
                            account.isBanned ? Icons.block : Icons.check_circle,

                            color: account.isBanned ? Colors.red : Colors.green,
                          ),

                          const SizedBox(width: 10),

                          Text(account.isBanned ? "Banned" : "Active"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "",
                          barrierColor: Colors.black.withOpacity(.45),
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder: (_, __, ___) {
                            return WithdrawFromSupplierDialog(
                              supplierId: account.id,
                              supplierName: account.name,
                            );
                          },
                          transitionBuilder: (_, animation, __, child) {
                            return Transform.scale(
                              scale: Curves.easeInOutBack.transform(
                                animation.value,
                              ),
                              child: Opacity(
                                opacity: animation.value,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_circle),
                      label: const Text("withdraw"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        account.isBanned
                            ? showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "",
                                barrierColor: Colors.black.withOpacity(.45),
                                transitionDuration: const Duration(
                                  milliseconds: 350,
                                ),
                                pageBuilder: (_, __, ___) {
                                  return UnBanAccountDialog(
                                    userId: account.id,
                                    userName: account.name,
                                  );
                                },
                                transitionBuilder: (_, animation, __, child) {
                                  return Transform.scale(
                                    scale: Curves.easeInOutBack.transform(
                                      animation.value,
                                    ),
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    ),
                                  );
                                },
                              )
                            : showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: "",
                                barrierColor: Colors.black.withOpacity(.45),
                                transitionDuration: const Duration(
                                  milliseconds: 350,
                                ),
                                pageBuilder: (_, __, ___) {
                                  return BanAccountDialog(
                                    userId: account.id,
                                    userName: account.name,
                                  );
                                },
                                transitionBuilder: (_, animation, __, child) {
                                  return Transform.scale(
                                    scale: Curves.easeInOutBack.transform(
                                      animation.value,
                                    ),
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    ),
                                  );
                                },
                              );
                      },
                      icon: Icon(
                        account.isBanned ? Icons.lock_open : Icons.block,
                      ),
                      label: Text(account.isBanned ? "Unban" : "Ban"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: account.isBanned
                            ? Colors.green
                            : Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "",
                          barrierColor: Colors.black.withOpacity(.45),
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder: (_, __, ___) {
                            return DeleteAccountDialog(
                              userId: account.id,
                              userName: account.name,
                            );
                          },
                          transitionBuilder: (_, animation, __, child) {
                            return Transform.scale(
                              scale: Curves.easeInOutBack.transform(
                                animation.value,
                              ),
                              child: Opacity(
                                opacity: animation.value,
                                child: child,
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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
