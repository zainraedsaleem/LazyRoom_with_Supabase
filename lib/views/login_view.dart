import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:takroom/widgets/user_login.dart';
import 'package:takroom/widgets/user_register.dart';

int currentIndexforLoginBage = 0;

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.surface,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Lazy",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Text(
                      "Room",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 300),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Welcome...!",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withOpacity(0.08)
                                    : Colors.black12,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(23),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 200,
                                ),
                              ],
                            ),
                            child: GNav(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              iconSize: 20,
                              tabBorderRadius: 21,
                              backgroundColor: Colors.transparent,
                              color: Theme.of(context).colorScheme.onSurface,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              tabBackgroundColor: Colors.orange,
                              gap: 5,
                              selectedIndex: currentIndexforLoginBage,
                              onTabChange: (index) {
                                setState(() {
                                  currentIndexforLoginBage = index;
                                });
                              },
                              tabs: [
                                GButton(
                                  icon: PhosphorIconsBold.userPlus,
                                  text: "     Register         ",
                                ),
                                GButton(
                                  icon: PhosphorIconsDuotone.user,
                                  text: "         Login         ",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          currentIndexforLoginBage == 0
                              ? UserRegister()
                              : UserLogin(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
