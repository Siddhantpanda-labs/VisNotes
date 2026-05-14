import 'package:flutter/material.dart';
import 'features/notes/presentation/pages/note_editor_page.dart';

void main() {
  runApp(const VisNotesApp());
}

class VisNotesApp extends StatelessWidget {
  const VisNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NoteEditorPage(),
    );
  }
}
