import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final notes = <Map<String, dynamic>>[];
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();

    Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .listen((event) {
        setState(() {
          notes.clear();
          notes.addAll(event);
        });
      });
  }

  void loadNotes() async {
    final response = await Supabase.instance.client.from('notes').select('*').order('created_at');
    setState(() => notes.addAll(response));
  }

  void addNote() async {
    final text = noteController.text;
    if (text.isNotEmpty) {
      await Supabase.instance.client.from('notes').insert({'text': text});
      noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: Column(
        children: [
          TextField(controller: noteController, decoration: InputDecoration(labelText: 'Add note')),
          ElevatedButton(onPressed: addNote, child: Text('Save')),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, i) => ListTile(title: Text(notes[i]['text'])),
            ),
          ),
        ],
      ),
    );
  }
}
