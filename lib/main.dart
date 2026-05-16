import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/notes/data/repositories/note_repository.dart';
import 'features/notes/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'features/notes/presentation/pages/notes_dashboard_page.dart';
import 'features/notes/presentation/pages/splash_screen.dart';

import 'features/notes/presentation/bloc/auth/auth_bloc.dart';

import 'features/notes/data/repositories/cloud_sync_repository.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final repository = NoteRepository();
  final cloudSyncRepository = CloudSyncRepository(repository);
  runApp(VisNotesApp(repository: repository, cloudSyncRepository: cloudSyncRepository));
}

class VisNotesApp extends StatelessWidget {
  final NoteRepository repository;
  final CloudSyncRepository cloudSyncRepository;
  
  const VisNotesApp({
    super.key, 
    required this.repository, 
    required this.cloudSyncRepository
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        RepositoryProvider.value(value: cloudSyncRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DashboardBloc(repository: repository)..add(LoadDashboard()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(repository, cloudSyncRepository)..add(AuthAppStarted()),
          ),
        ],
        child: MaterialApp(
          title: 'VisNotes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
