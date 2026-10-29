import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/providers/user_provider.dart';

/// خيار الوضع الليلي: System / On / Off (يُحفظ في SharedPreferences).
/// يعمل بالضغط: System ← On ← Off ← System.
class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<UserProvider>().themeMode;
    final label = switch (mode) {
      ThemeMode.system => 'System',
      ThemeMode.dark => 'On',
      ThemeMode.light => 'Off',
    };
    final icon = switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.dark => Icons.dark_mode,
      ThemeMode.light => Icons.light_mode,
    };

    return GestureDetector(
      onTap: () => context.read<UserProvider>().cycleThemeMode(),
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
              child: Icon(icon, color: Colors.orange),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
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
    );
  }
}
