import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:takroom/views/customer_views/home_tab.dart';
import 'package:takroom/views/customer_views/order_tab.dart';
import 'package:takroom/views/customer_views/profile_tab.dart';
import 'package:takroom/widgets/dialogs/cart_dialog.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({super.key});

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  int currentIndex = 0;
  List pages = [HomeTab(), OrderTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      top: false,
      child: Scaffold(
        floatingActionButton: currentIndex == 0
            ? Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.deepOrange.shade600,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    CartDialog.show(context);
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              )
            : SizedBox(),
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
                    GButton(icon: Icons.home, text: "Home"),
                    GButton(icon: Icons.shopping_cart, text: "Orders"),
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
