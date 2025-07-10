// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$systemBrightnessHash() => r'5221b2035716323be480993d71020212bca09146';

/// See also [systemBrightness].
@ProviderFor(systemBrightness)
final systemBrightnessProvider = AutoDisposeFutureProvider<Brightness>.internal(
  systemBrightness,
  name: r'systemBrightnessProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$systemBrightnessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SystemBrightnessRef = AutoDisposeFutureProviderRef<Brightness>;
String _$themeNotifierHash() => r'bb96233ce26002b5019690e09e457edb737d5c6c';

/// See also [ThemeNotifier].
@ProviderFor(ThemeNotifier)
final themeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ThemeNotifier, ThemeMode>.internal(
      ThemeNotifier.new,
      name: r'themeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeNotifier = AutoDisposeAsyncNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
