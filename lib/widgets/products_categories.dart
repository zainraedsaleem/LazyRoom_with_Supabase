import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';

class ProductsCategories extends StatefulWidget {
  const ProductsCategories({super.key});

  @override
  State<ProductsCategories> createState() => _ProductsCategoriesState();
}

class _ProductsCategoriesState extends State<ProductsCategories> {
  final List<String> categories = [
    'All',
    'Food',
    'Drinks',
    'Preserves',
    'Entrees',
  ];

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // categories
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,

            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),

                child: ChoiceChip(
                  showCheckmark: false,
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() {
                      selectedCategory = category;
                      index == 0
                          ? Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).fetchAllProducts(context)
                          : Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).fetchProducts(context, index);
                    });
                  },
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
