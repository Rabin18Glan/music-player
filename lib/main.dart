import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/data/datasources/audio_local_data_source.dart';
import 'package:music_player/data/repositories/audio_repository_impl.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_player/presentation/bloc/playlist_bloc/playlist_bloc.dart';
import 'package:music_player/presentation/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure audio session
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  // Request storage permissions to access music files
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioBloc>(
          create:
              (context) => AudioBloc(
                audioRepository: AudioRepositoryImpl(
                  localDataSource: AudioLocalDataSourceImpl(),
                ),
              )..add(LoadAudioFiles()),
        ),
        BlocProvider<PlaylistBloc>(create: (context) => PlaylistBloc()),
        BlocProvider<FavoritesBloc>(create: (context) => FavoritesBloc()),
      ],
      child: MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark theme
        home: const HomePage(),
      ),
    );
  }
}
