import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';
import 'package:takroom/services/role_router.dart';
import 'package:takroom/views/login_view.dart';
import 'package:takroom/views/no_Internet_view.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> logoAnimation;
  late Animation<double> textAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    logoAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.3, 1)),
    );

    controller.forward();

    checkLogin();
  }

  Future<void> checkLogin() async {
    final session = Supabase.instance.client.auth.currentSession;
    await Future.delayed(const Duration(milliseconds: 2000));
    if (session != null) {
      try {
        final user = await AuthService().getCurrentUserProfile();
        if (user.isBanned) {
          await AuthService().logout();
          ShowSnackbar.showSnackbar(context, "This account has been banned");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginView()),
          );
          return;
        }
        {
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => getHomePageByRole(user.role)),
          );
        }
      } catch (e) {
        ShowSnackbar.showSnackbar(context, "No InterNet Access");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => NoInternetView()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // LOGO
                    const SizedBox(height: 18),

                    // APP NAME
                    Opacity(
                      opacity: textAnimation.value,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          children: [
                            TextSpan(
                              text: "Lazy",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: "Room",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // SLOGAN
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Opacity(
                        opacity: textAnimation.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Order",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black54,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              ".",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              " Relax",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black54,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              ".",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              " We deliver",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black54,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
