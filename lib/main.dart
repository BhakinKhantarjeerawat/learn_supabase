import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_supabase/instrument_controller.dart';
import 'package:learn_supabase/my_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://hqzcumtovywyggsveipn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxemN1bXRvdnl3eWdnc3ZlaXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE4OTcyMzcsImV4cCI6MjA2NzQ3MzIzN30.w6Bze1CHEMAKL3r6XL_3_-8__JthWJ-UKyYdKSf-RD0',
  );

  // Initialize SharedPreferences and other dependencies
  final container = await AppInitializer.initialize();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}


