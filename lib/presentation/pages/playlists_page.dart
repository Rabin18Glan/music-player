import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/bloc/playlist_bloc.dart';
import 'package:music_player/presentation/pages/playlist_detail_page.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final _playlistNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PlaylistBloc>().add(LoadPlaylists());
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create Playlist'),
            content: TextField(
              controller: _playlistNameController,
              decoration: const InputDecoration(hintText: 'Playlist name'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _playlistNameController.clear();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_playlistNameController.text.isNotEmpty) {
                    context.read<PlaylistBloc>().add(
                      CreatePlaylist(_playlistNameController.text),
                    );
                    Navigator.pop(context);
                    _playlistNameController.clear();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlaylistDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlaylistsLoaded) {
            final playlists = state.playlists;

            if (playlists.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_music,
                      size: 80,
                      color: AppTheme.primaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No playlists yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your first playlist',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Create Playlist'),
                      onPressed: _showCreatePlaylistDialog,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlistName = playlists.keys.elementAt(index);
                final songs = playlists[playlistName]!;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.queue_music,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      playlistName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${songs.length} songs',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // Show playlist options
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete Playlist'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<PlaylistBloc>().add(
                                        DeletePlaylist(playlistName),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PlaylistDetailPage(
                                playlistName: playlistName,
                                songs: songs,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is PlaylistError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No playlists found'));
          }
        },
      ),
    );
  }
}
