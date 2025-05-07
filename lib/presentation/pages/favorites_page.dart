import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc.dart';
import 'package:music_player/presentation/widgets/song_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 80,
                      color: AppTheme.primaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add songs to your favorites',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites[index];

                return BlocBuilder<AudioBloc, AudioState>(
                  builder: (context, audioState) {
                    final isPlaying =
                        audioState is AudioPlaying &&
                        audioState.currentSong.id == song.id &&
                        audioState.isPlaying;

                    return SongTile(
                      song: song,
                      isPlaying: isPlaying,
                      isFavorite: true,
                    );
                  },
                );
              },
            );
          } else if (state is FavoritesError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No favorites found'));
          }
        },
      ),
    );
  }
}
