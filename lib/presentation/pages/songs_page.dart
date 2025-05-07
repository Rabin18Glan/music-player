import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/presentation/bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc.dart';
import 'package:music_player/presentation/widgets/song_tile.dart';
import 'package:music_player/presentation/widgets/empty_music_view.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, audioState) {
        if (audioState is AudioLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (audioState is AudioLoaded) {
          if (audioState.songs.isEmpty) {
            return EmptyMusicView(
              onRefresh: () {
                context.read<AudioBloc>().add(LoadAudioFiles());
              },
            );
          }
          
          return BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favoritesState) {
              final favorites = favoritesState is FavoritesLoaded 
                  ? favoritesState.favorites 
                  : [];
              
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80), // Space for mini player
                itemCount: audioState.songs.length,
                itemBuilder: (context, index) {
                  final song = audioState.songs[index];
                  final isFavorite = favorites.any((fav) => fav.id == song.id);
                  
                  return SongTile(
                    song: song,
                    isPlaying: false,
                    isFavorite: isFavorite,
                  );
                },
              );
            },
          );
        } else if (audioState is AudioPlaying) {
          return BlocBuilder<AudioBloc, AudioState>(
            builder: (context, state) {
              if (state is AudioLoaded) {
                if (state.songs.isEmpty) {
                  return EmptyMusicView(
                    onRefresh: () {
                      context.read<AudioBloc>().add(LoadAudioFiles());
                    },
                  );
                }
                
                return BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, favoritesState) {
                    final favorites = favoritesState is FavoritesLoaded 
                        ? favoritesState.favorites 
                        : [];
                    
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.songs.length,
                      itemBuilder: (context, index) {
                        final song = state.songs[index];
                        final isPlaying = audioState.currentSong.id == song.id && 
                            audioState.isPlaying;
                        final isFavorite = favorites.any((fav) => fav.id == song.id);
                        
                        return SongTile(
                          song: song,
                          isPlaying: isPlaying,
                          isFavorite: isFavorite,
                        );
                      },
                    );
                  },
                );
              }
              
              // Fallback to showing just the current playing song
              return BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favoritesState) {
                  final favorites = favoritesState is FavoritesLoaded 
                      ? favoritesState.favorites 
                      : [];
                  
                  final isFavorite = favorites.any((fav) => fav.id == audioState.currentSong.id);
                  
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      SongTile(
                        song: audioState.currentSong,
                        isPlaying: audioState.isPlaying,
                        isFavorite: isFavorite,
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else if (audioState is AudioError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${audioState.message}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AudioBloc>().add(LoadAudioFiles());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        } else {
          return EmptyMusicView(
            onRefresh: () {
              context.read<AudioBloc>().add(LoadAudioFiles());
            },
          );
        }
      },
    );
  }
}
