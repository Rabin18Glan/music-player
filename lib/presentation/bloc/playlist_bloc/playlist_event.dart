part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

class LoadPlaylists extends PlaylistEvent {}

class CreatePlaylist extends PlaylistEvent {
  final String name;

  const CreatePlaylist(this.name);

  @override
  List<Object> get props => [name];
}

class AddSongToPlaylist extends PlaylistEvent {
  final String playlistName;
  final SongModel song;

  const AddSongToPlaylist(this.playlistName, this.song);

  @override
  List<Object> get props => [playlistName, song];
}

class RemoveSongFromPlaylist extends PlaylistEvent {
  final String playlistName;
  final SongModel song;

  const RemoveSongFromPlaylist(this.playlistName, this.song);

  @override
  List<Object> get props => [playlistName, song];
}

class DeletePlaylist extends PlaylistEvent {
  final String name;

  const DeletePlaylist(this.name);

  @override
  List<Object> get props => [name];
}
