import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  Map<String, List<SongModel>> _playlists = {};

  PlaylistBloc() : super(PlaylistInitial()) {
    on<LoadPlaylists>(_onLoadPlaylists);
    on<CreatePlaylist>(_onCreatePlaylist);
    on<AddSongToPlaylist>(_onAddSongToPlaylist);
    on<RemoveSongFromPlaylist>(_onRemoveSongFromPlaylist);
    on<DeletePlaylist>(_onDeletePlaylist);
  }

  void _onLoadPlaylists(
    LoadPlaylists event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoading());
    try {
      await _loadPlaylistsFromStorage();
      emit(PlaylistsLoaded(_playlists));
    } catch (e) {
      emit(PlaylistError('Failed to load playlists: ${e.toString()}'));
    }
  }

  void _onCreatePlaylist(
    CreatePlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      if (_playlists.containsKey(event.name)) {
        emit(PlaylistError('Playlist with this name already exists'));
        return;
      }

      _playlists[event.name] = [];
      await _savePlaylistsToStorage();
      emit(PlaylistsLoaded(_playlists));
    } catch (e) {
      emit(PlaylistError('Failed to create playlist: ${e.toString()}'));
    }
  }

  void _onAddSongToPlaylist(
    AddSongToPlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      if (!_playlists.containsKey(event.playlistName)) {
        emit(PlaylistError('Playlist does not exist'));
        return;
      }

      // Check if SongModel already exists in playlist
      if (_playlists[event.playlistName]!.any(
        (song) => song.id == event.song.id,
      )) {
        emit(PlaylistError('SongModel already exists in playlist'));
        return;
      }

      _playlists[event.playlistName]!.add(event.song);
      await _savePlaylistsToStorage();
      emit(PlaylistsLoaded(_playlists));
    } catch (e) {
      emit(
        PlaylistError('Failed to add SongModel to playlist: ${e.toString()}'),
      );
    }
  }

  void _onRemoveSongFromPlaylist(
    RemoveSongFromPlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      if (!_playlists.containsKey(event.playlistName)) {
        emit(PlaylistError('Playlist does not exist'));
        return;
      }

      _playlists[event.playlistName] =
          _playlists[event.playlistName]!
              .where((song) => song.id != event.song.id)
              .toList();

      await _savePlaylistsToStorage();
      emit(PlaylistsLoaded(_playlists));
    } catch (e) {
      emit(
        PlaylistError(
          'Failed to remove SongModel from playlist: ${e.toString()}',
        ),
      );
    }
  }

  void _onDeletePlaylist(
    DeletePlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      if (!_playlists.containsKey(event.name)) {
        emit(PlaylistError('Playlist does not exist'));
        return;
      }

      _playlists.remove(event.name);
      await _savePlaylistsToStorage();
      emit(PlaylistsLoaded(_playlists));
    } catch (e) {
      emit(PlaylistError('Failed to delete playlist: ${e.toString()}'));
    }
  }

  Future<void> _loadPlaylistsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistsJson = prefs.getString('playlists');

    if (playlistsJson != null) {
      final Map<String, List<SongModel>> playlistsMap = jsonDecode(
        playlistsJson,
      );

      _playlists = {};
      playlistsMap.forEach((key, value) {
        final List<SongModel> songs = value;

        _playlists[key] = songs;
      });
    } else {
      // Initialize with default playlists
      _playlists = {'Favorites': [], 'Recently Played': []};
    }
  }

  Future<void> _savePlaylistsToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, List<SongModel>> playlistsMap = {};

    _playlists.forEach((key, songs) {
      playlistsMap[key] = songs;
    });

    await prefs.setString('playlists', jsonEncode(playlistsMap));
  }
}
