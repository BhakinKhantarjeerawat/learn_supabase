import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_supabase/instrument_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'instrument_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hqzcumtovywyggsveipn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxemN1bXRvdnl3eWdnc3ZlaXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE4OTcyMzcsImV4cCI6MjA2NzQ3MzIzN30.w6Bze1CHEMAKL3r6XL_3_-8__JthWJ-UKyYdKSf-RD0',
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Instruments', home: HomePage());
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Instruments'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    // await Supabase.instance.client.from('instruments').insert({
                    //   'name': _nameController.text,
                    // });
                    // setState(() {
                    //   _loadInstruments(); // Refresh the data
                    // });
                    ref.read(instrumentControllerProvider.notifier).addInstrument(_nameController.text);
                  },
                  child: Text('Add Instrument'),
                ),
              ],
            ),
          ),


          
          SizedBox(
            height: 500,
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final instruments = snapshot.data!;
                return ListView.builder(
                  itemCount: instruments.length,
                  itemBuilder: ((context, index) {
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
                                    await Supabase.instance.client
                                        .from('instruments')
                                        .update({'name': _nameController.text})
                                        .eq('id', instrument['id']);
                                    setState(() {
                                      _loadInstruments(); // Refresh the data
                                    });
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
                            await Supabase.instance.client
                                .from('instruments')
                                .delete()
                                .eq('id', instrument['id']);
                            setState(() {
                              _loadInstruments(); // Refresh the data
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
