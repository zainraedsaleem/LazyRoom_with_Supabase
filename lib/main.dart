import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/app_keys.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/local_storage_service.dart';
import 'package:takroom/theme/app_theme.dart';
import 'package:takroom/views/splash_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '^_^',
    anonKey:
        '^_^',
  );
  final settings = await LocalStorageService.loadSettings();
  runApp(MyApp(settings: settings));
}

class MyApp extends StatelessWidget {
  final AppSettings settings;
  const MyApp({super.key, this.settings = const AppSettings()});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(
        productsWithPhotos: settings.productsWithPhotos,
        themeMode: settings.themeMode,
      ),
      child: const _AppRoot(),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<UserProvider, ThemeMode>(
      (p) => p.themeMode,
    );
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'LazyRoom',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}
