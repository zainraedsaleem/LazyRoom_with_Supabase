import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/admin_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({super.key});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = "customer";

  final List<String> categories = ["customer", "supplier", "admin"];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  bool isLoading = false;

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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(.1),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.deepOrange.shade500,
                          ],
                        ),
                      ),
                      child: Icon(
                        PhosphorIconsBold.userPlus,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Add Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Enter new account info",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildField(
                      controller: nameController,
                      hint: "User name",
                      icon: PhosphorIconsBold.user,
                    ),

                    const SizedBox(height: 18),

                    _buildField(
                      controller: emailController,
                      hint: "User email",
                      icon: Icons.alternate_email_rounded,
                    ),

                    const SizedBox(height: 18),

                    _buildField(
                      controller: passwordController,
                      hint: "User Password",
                      icon: Icons.lock_outline,
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(.08),
                        border: Border.all(
                          color: Colors.white.withOpacity(.08),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          dropdownColor:
                              Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.surface
                              : Colors.orange.shade100,
                          icon: Icon(
                            PhosphorIconsBold.caretDown,
                            color: Colors.orange.shade300,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          isExpanded: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(
                                    switch (category) {
                                      "customer" =>
                                        Icons.account_circle_rounded,
                                      "supplier" =>
                                        Icons.local_shipping_rounded,
                                      "admin" => Icons.security_rounded,
                                      _ => PhosphorIconsBold.bowlFood,
                                    },
                                    color: Colors.orange.shade300,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 12),

                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: unitController,
                            hint: "Unit",
                            icon: Icons.apartment_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildField(
                            controller: roomController,
                            hint: "Room",
                            icon: Icons.door_back_door_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "cancle",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  final message =
                                      await AdminService.createAccount(
                                        body: {
                                          "name": nameController.text.trim(),
                                          "email": emailController.text.trim(),
                                          "password": passwordController.text,
                                          "role": selectedCategory,
                                          "room_number": roomController.text
                                              .trim(),
                                          "building": unitController.text
                                              .trim(),
                                        },
                                      );
                                  if (!mounted) return;
                                  ShowSnackbar.showSnackbar(context, message);
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).refreshAccounts();
                                  Navigator.pop(context);
                                } catch (e) {
                                  if (!mounted) return;
                                  ShowSnackbar.showSnackbar(
                                    context,
                                    e.toString().replaceFirst(
                                      "Exception: ",
                                      "",
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
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
                                      "Add now",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "this field is required";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
        prefixIcon: Icon(icon, color: Colors.orange.shade300),
        filled: true,
        fillColor: Colors.white.withOpacity(.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.orange.shade400, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
