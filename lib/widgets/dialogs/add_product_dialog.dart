import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';

import 'package:takroom/services/product_service.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = "Food";

  final List<String> categories = ["Food", "Drink", "Preserves", "Entrees"];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  bool isLoading = false;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
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
                        PhosphorIconsBold.shoppingCart,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Add Product",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Enter new product info",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ---------- Image picker ----------
                    GestureDetector(
                      onTap: isLoading ? null : _pickImage,
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white.withOpacity(.08),
                          border: Border.all(
                            color: Colors.white.withOpacity(.12),
                          ),
                        ),
                        child: selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    PhosphorIconsBold.camera,
                                    color: Colors.orange.shade300,
                                    size: 34,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Add product image",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => selectedImage = null),
                                      child: const CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.black54,
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildField(
                      controller: nameController,
                      hint: "Product name",
                      icon: PhosphorIconsBold.package,
                    ),

                    const SizedBox(height: 18),

                    _buildField(
                      controller: descriptionController,
                      hint: "Description",
                      icon: PhosphorIconsBold.notePencil,
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
                                      "Food" => PhosphorIconsBold.hamburger,
                                      "Drink" => PhosphorIconsBold.coffee,
                                      "Preserves" => PhosphorIconsBold.jar,
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
                            controller: priceController,
                            hint: "Price",
                            icon: PhosphorIconsBold.currencyDollar,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildField(
                            controller: quantityController,
                            hint: "Stock",
                            icon: PhosphorIconsBold.cube,
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
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            child: const Text(
                              "Cancel",
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
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      if (selectedImage == null) {
                                        ShowSnackbar.showSnackbar(
                                          context,
                                          "Please select a product image",
                                        );
                                        return;
                                      }

                                      setState(() => isLoading = true);

                                      final addedSuccessfully =
                                          await ProductService().addProduct(
                                            name: nameController.text,
                                            description:
                                                descriptionController.text,
                                            price: double.parse(
                                              priceController.text,
                                            ),
                                            category_id: getCategory_id(
                                              selectedCategory,
                                            ),
                                            stock: int.parse(
                                              quantityController.text,
                                            ),
                                            image: selectedImage!,
                                          );

                                      if (!mounted) return;

                                      ShowSnackbar.showSnackbar(
                                        context,
                                        addedSuccessfully
                                            ? "Product Added Successfully"
                                            : "Failed To Add Product",
                                      );

                                      setState(() => isLoading = false);

                                      Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).fetchSupplierProducts(context);
                                      Navigator.pop(context);
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

int getCategory_id(String category) {
  if (category == "Food") return 1;
  if (category == "Drink") return 2;
  if (category == "Preserves") return 3;
  if (category == "Entrees") return 4;
  return 1;
}
