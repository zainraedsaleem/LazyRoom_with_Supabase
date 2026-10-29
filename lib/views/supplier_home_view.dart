import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:takroom/views/supplier_views/suplier_profile_tab.dart';
import 'package:takroom/views/supplier_views/supplier_orders_tab.dart';
import 'package:takroom/views/supplier_views/supplier_products_tab.dart';

class SupplierHomeView extends StatefulWidget {
  const SupplierHomeView({super.key});

  @override
  State<SupplierHomeView> createState() => _SupplierHomeViewState();
}

class _SupplierHomeViewState extends State<SupplierHomeView> {
  int currentIndex = 0;
  List pages = [
    SupplierOrdersTab(),
    SupplierProductsTab(),
    SuplierProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: pages[currentIndex],
        bottomNavigationBar: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.surface.withOpacity(.08),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(.12),
                  ),
                ),
                child: GNav(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  iconSize: 20,
                  tabBorderRadius: 100,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.onSurface,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  tabBackgroundColor: Colors.orange,
                  gap: 5,
                  selectedIndex: currentIndex,
                  onTabChange: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  tabs: [
                    GButton(icon: Icons.shopping_bag, text: "Orders"),
                    GButton(
                      icon: Icons.production_quantity_limits,
                      text: "Products",
                    ),
                    GButton(icon: Icons.person, text: "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
