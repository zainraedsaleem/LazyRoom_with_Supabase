import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/views/login_view.dart';
import 'package:takroom/widgets/theme_mode_tile.dart';

class SuplierProfileTab extends StatelessWidget {
  const SuplierProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 100,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xffff8a00), Color(0xffffb347)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Text(
                        user?.name[0].toUpperCase() ?? "",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      user?.name ?? "",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      user?.email ?? "",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(
                          context,
                          "Done / Received",
                          "${Provider.of<UserProvider>(context).completedOrdersCount} / ${Provider.of<UserProvider>(context).receivedOrdersCount}",
                        ),
                        _divider(),
                        _statItem(context, "Balance", user?.balance ?? ""),
                        _divider(),
                        _statItem(context, "Role", user?.role ?? ""),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ACCOUNT SECTION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Account Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              _ModernTile(
                title: "Full Name",
                value: user?.name ?? "",
                icon: PhosphorIcons.user(),
              ),

              _ModernTile(
                title: "Building",
                value: user?.building ?? "",
                icon: PhosphorIcons.buildings(),
              ),

              _ModernTile(
                title: "Room Number",
                value: user?.room_number ?? "",
                icon: PhosphorIcons.door(),
              ),
              GestureDetector(
                onTap: () {
                  if (Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).products_with_photos) {
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).setProductsWithPhotos(false);
                  } else {
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).setProductsWithPhotos(true);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.12),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.photo, color: Colors.orange),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Products with photos",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              Provider.of<UserProvider>(
                                    context,
                                  ).products_with_photos
                                  ? "ON"
                                  : "Off",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const ThemeModeTile(),
              const SizedBox(height: 10),

              /// LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: Dialog(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Log out",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Are you sure you want to Log out from this account ?",
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Spacer(),
                                          TextButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                            ),
                                            onPressed: () async {
                                              await Provider.of<UserProvider>(
                                                context,
                                                listen: false,
                                              ).logout();

                                              Navigator.of(context).pop();

                                              Navigator.of(
                                                context,
                                              ).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (_) => LoginView(),
                                                ),
                                              );
                                            },
                                            child: Text("Confirm"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(PhosphorIcons.signOut()),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(height: 40, width: 1, color: Colors.white.withOpacity(.4));
  }

  Widget _statItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ],
    );
  }
}

class _ModernTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ModernTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.orange),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
