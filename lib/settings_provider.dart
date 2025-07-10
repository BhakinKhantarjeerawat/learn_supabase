import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'shared_preferences_provider.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<Map<String, dynamic>> build() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    return {
      'theme': prefs.getString('theme') ?? 'light',
      'username': prefs.getString('username') ?? '',
      'lastLogin': prefs.getString('lastLogin') ?? '',
    };
  }

  Future<void> setTheme(String theme) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('theme', theme);
    ref.invalidateSelf();
  }

  Future<void> setUsername(String username) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('username', username);
    ref.invalidateSelf();
  }

  Future<void> setLastLogin(String date) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString('lastLogin', date);
    ref.invalidateSelf();
  }

  Future<void> clearAll() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.clear();
    ref.invalidateSelf();
  }
} 

