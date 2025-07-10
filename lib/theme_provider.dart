import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'shared_preferences_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<ThemeMode> build() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final themeString = prefs.getString('themeMode') ?? 'system';
    return _stringToThemeMode(themeString);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('themeMode', _themeModeToString(mode));
    state = AsyncValue.data(mode);
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

// Provider to get the actual brightness based on system settings
@riverpod
Future<Brightness> systemBrightness(SystemBrightnessRef ref) async {
  final themeMode = await ref.watch(themeNotifierProvider.future);
  
  if (themeMode == ThemeMode.system) {
    // Use MediaQuery to get the system brightness
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  } else if (themeMode == ThemeMode.light) {
    return Brightness.light;
  } else {
    return Brightness.dark;
  }
}

 