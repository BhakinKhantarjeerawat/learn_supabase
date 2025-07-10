import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';
import 'route_controller.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Force a rebuild when system theme changes
    ref.invalidate(themeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeNotifierProvider);
    final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    return themeModeAsync.when(
      data: (themeMode) {
        // Determine the actual theme mode considering system settings
        ThemeMode actualThemeMode = themeMode;
        if (themeMode == ThemeMode.system) {
          actualThemeMode = platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
        }
        
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          title: 'Instruments',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: actualThemeMode,
          routerConfig: router,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, st) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Theme error: $e'))),
      ),
    );
  }
}

