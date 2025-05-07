import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/audio_bloc/audio_bloc.dart';
import 'package:music_player/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:music_player/presentation/bloc/playlist_bloc/playlist_bloc.dart';

import 'package:music_player/presentation/widgets/player_controls.dart';

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsBottomSheet(context);
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state is AudioLoaded) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(gradient: AppTheme.surfaceGradient),
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(),

                    // Album art
                    Hero(
                      tag: 'album-art-${state.currentSong.id}',
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child:
                            state.currentSong.data != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    File(state.currentSong.data!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.music_note,
                                        color: AppTheme.primaryColor,
                                        size: 120,
                                      );
                                    },
                                  ),
                                )
                                : Icon(
                                  Icons.music_note,
                                  color: AppTheme.primaryColor,
                                  size: 120,
                                ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    
                    const Spacer(),

                    // Song info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Text(
                            state.currentSong.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.currentSong.artist} • ${state.currentSong.album}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.secondaryTextColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Player controls
                    const PlayerControls(),

                    const Spacer(),

                    // Favorite and playlist buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, favoritesState) {
                              final favorites =
                                  favoritesState is FavoritesLoaded
                                      ? favoritesState.favorites
                                      : [];

                              final isFavorite = favorites.any(
                                (fav) => fav.id == state.currentSong.id,
                              );

                              return IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppTheme.accentColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (isFavorite) {
                                    context.read<FavoritesBloc>().add(
                                      RemoveFromFavorites(state.currentSong),
                                    );
                                  } else {
                                    context.read<FavoritesBloc>().add(
                                      AddToFavorites(state.currentSong),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_add, size: 30),
                            onPressed: () {
                              _showAddToPlaylistBottomSheet(
                                context,
                                state.currentSong,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            );
          } else if (state is AudioError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 80,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_off,
                    size: 80,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No song playing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Song Info'),
                onTap: () {
                  Navigator.pop(context);
                  // Show song info
                },
              ),
            ],
          ),
    );
  }

  void _showAddToPlaylistBottomSheet(BuildContext context, song) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => BlocBuilder<PlaylistBloc, PlaylistState>(
            builder: (context, state) {
              if (state is PlaylistsLoaded) {
                final playlists = state.playlists;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Add to Playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          final playlistName = playlists.keys.elementAt(index);

                          return ListTile(
                            leading: Icon(
                              Icons.playlist_play,
                              color: AppTheme.primaryColor,
                            ),
                            title: Text(playlistName),
                            onTap: () {
                              context.read<PlaylistBloc>().add(
                                AddSongToPlaylist(playlistName, song),
                              );
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added to $playlistName'),
                                  backgroundColor: AppTheme.surfaceColor,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
    );
  }
}
