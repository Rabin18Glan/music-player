import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_player/presentation/bloc/playlist_bloc/playlist_bloc.dart';
import 'package:music_player/presentation/widgets/song_tile.dart';

class PlaylistDetailPage extends StatelessWidget {
  final String playlistName;
  final List<SongModel> songs;

  const PlaylistDetailPage({
    super.key,
    required this.playlistName,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(playlistName),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primaryColor, AppTheme.backgroundColor],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.queue_music,
                    size: 100,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${songs.length} songs',
                    style: const TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play All'),
                    onPressed: () {
                      if (songs.isNotEmpty) {
                        context.read<AudioBloc>().add(PlaySong(songs.first));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final song = songs[index];

              return BlocBuilder<AudioBloc, AudioState>(
                builder: (context, audioState) {
                  final isPlaying =
                      audioState is AudioLoaded &&
                      audioState.currentSong.id == song.id &&
                      audioState.isPlaying;

                  return BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, favoritesState) {
                      final favorites =
                          favoritesState is FavoritesLoaded
                              ? favoritesState.favorites
                              : [];

                      final isFavorite = favorites.any(
                        (fav) => fav.id == song.id,
                      );

                      return Dismissible(
                        key: Key(song.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          context.read<PlaylistBloc>().add(
                            RemoveSongFromPlaylist(playlistName, song),
                          );
                        },
                        child: SongTile(
                          song: song,
                          isPlaying: isPlaying,
                          isFavorite: isFavorite,
                        ),
                      );
                    },
                  );
                },
              );
            }, childCount: songs.length),
          ),
        ],
      ),
    );
  }
}
