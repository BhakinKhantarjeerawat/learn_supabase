import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_supabase/instrument_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final instruments = ref.watch(instrumentControllerProvider);
    final themeModeAsync = ref.watch(themeNotifierProvider);
    final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    // Determine the actual brightness
    Brightness actualBrightness = platformBrightness;
    themeModeAsync.whenData((themeMode) {
      if (themeMode == ThemeMode.light) {
        actualBrightness = Brightness.light;
      } else if (themeMode == ThemeMode.dark) {
        actualBrightness = Brightness.dark;
      }
      // If system, use platformBrightness
    });
    
    return Scaffold(
      backgroundColor: actualBrightness == Brightness.light ? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: actualBrightness == Brightness.light ? Colors.white : Colors.black,
        title: const Text('Instruments'),
        actions: [
          IconButton(
            onPressed: () {
              Supabase.instance.client.auth.signOut();
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 16),
          Consumer(
            builder: (context, ref, child) {
              final themeModeAsync = ref.watch(themeNotifierProvider);
              return themeModeAsync.when(
                data: (themeMode) => PopupMenuButton<ThemeMode>(
                  icon: const Icon(Icons.color_lens),
                  onSelected: (mode) {
                    ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
                  },
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: ThemeMode.system,
                      checked: themeMode == ThemeMode.system,
                      child: const Text('System'),
                    ),
                    CheckedPopupMenuItem(
                      value: ThemeMode.light,
                      checked: themeMode == ThemeMode.light,
                      child: const Text('Light'),
                    ),
                    CheckedPopupMenuItem(
                      value: ThemeMode.dark,
                      checked: themeMode == ThemeMode.dark,
                      child: const Text('Dark'),
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (e, st) => Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter instrument name',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    ref.read(instrumentControllerProvider.notifier).addInstrument(_nameController.text);
                  },
                  child: Text('Add Instrument'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 500,
            child: instruments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (instruments) => ListView.builder(
                itemCount: instruments.length,
                itemBuilder: (context, index) {
                  final instrument = instruments[index];
                  return GestureDetector(
                        onTap: () {
                          _nameController.text =
                              instrument['name']; // Set initial value
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Instrument'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Instrument Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                            ref.read(instrumentControllerProvider.notifier).updateInstrument(instrument['id'], _nameController.text);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(instrument['name']),
                          subtitle: Text(instrument['desc'] ?? 'no description'),
                          trailing: IconButton(
                            onPressed: () async {
                                  ref.read(instrumentControllerProvider.notifier).deleteInstrument(instrument['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      );
                },
              ),
                     
            ),
          ),
        ],
      ),
    );
  }
}