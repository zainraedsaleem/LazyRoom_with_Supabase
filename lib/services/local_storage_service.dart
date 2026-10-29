import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool productsWithPhotos;
  final ThemeMode themeMode;
  const AppSettings({
    this.productsWithPhotos = false,
    this.themeMode = ThemeMode.system,
  });
}

class LocalStorageService {
  static const _kPhotos = 'products_with_photos';
  static const _kTheme = 'theme_mode'; // system | light | dark

  static Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = switch (prefs.getString(_kTheme)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return AppSettings(
      productsWithPhotos: prefs.getBool(_kPhotos) ?? false,
      themeMode: theme,
    );
  }

  static Future<void> saveProductsWithPhotos(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPhotos, value);
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
