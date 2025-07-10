import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_preferences_provider.dart';

class AppInitializer {
  static Future<ProviderContainer> initialize() async {
    // Create a container for initialization
    final container = ProviderContainer();
    
    // Initialize SharedPreferences
    await container.read(sharedPreferencesProvider.future);
    
    return container;
  }
} 