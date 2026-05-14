import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/notes/data/repositories/note_repository.dart';
import 'features/notes/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'features/notes/presentation/pages/notes_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = NoteRepository();
  runApp(VisNotesApp(repository: repository));
}

class VisNotesApp extends StatelessWidget {
  final NoteRepository repository;
  const VisNotesApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DashboardBloc(repository: repository)..add(LoadDashboard()),
          ),
        ],
        child: MaterialApp(
          title: 'VisNotes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const NotesDashboardPage(),
        ),
      ),
    );
  }
}
