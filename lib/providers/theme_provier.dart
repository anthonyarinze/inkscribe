import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themesProvider = StateNotifierProvider<ThemesProvider, ThemeMode?>((ref) {
  final provider = ThemesProvider();
  provider.loadTheme(); // Load the theme when creating the provider
  return provider;
});

class ThemesProvider extends StateNotifier<ThemeMode?> {
  ThemesProvider() : super(null);

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> loadTheme() async {
    final savedTheme = await secureStorage.read(key: 'themeMode');
    state = savedTheme != null ? (savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light) : ThemeMode.system;
  }

  void changeTheme(bool isOn) async {
    state = isOn ? ThemeMode.dark : ThemeMode.light;
    await secureStorage.write(key: 'themeMode', value: isOn ? 'dark' : 'light');
  }
}
