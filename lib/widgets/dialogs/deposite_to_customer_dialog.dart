import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/admin_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class DepositToCustomerDialog extends StatefulWidget {
  final String customerId;
  final String customerName;

  const DepositToCustomerDialog({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<DepositToCustomerDialog> createState() =>
      _DepositToCustomerDialogState();
}

class _DepositToCustomerDialogState extends State<DepositToCustomerDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();

  bool isLoading = false;

  Future<void> _deposit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
      });

      final message = await AdminService.depositToCustomer(
        customerId: widget.customerId,
        amount: int.parse(amountController.text),
      );

      if (!mounted) return;

      ShowSnackbar.showSnackbar(context, message);
      Provider.of<UserProvider>(context, listen: false).refreshAccounts();
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ShowSnackbar.showSnackbar(
        context,
        e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(.1),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.teal.shade500],
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Deposit Balance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Add balance to customer account",
                    style: TextStyle(color: Colors.white.withOpacity(.7)),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withOpacity(.08),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIconsBold.user,
                          color: Colors.green.shade300,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.customerName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount is required";
                      }

                      final amount = int.tryParse(value);

                      if (amount == null || amount <= 0) {
                        return "Enter a valid amount";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter amount",
                      hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                        color: Colors.green.shade300,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(.08),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.green.shade400,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            side: BorderSide(
                              color: Colors.white.withOpacity(.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.teal.shade500,
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: isLoading ? null : _deposit,
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Deposit Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
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
      ),
    );
  }
}
