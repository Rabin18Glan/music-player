part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistsLoaded extends PlaylistState {
  final Map<String, List<SongModel>> playlists;

  const PlaylistsLoaded(this.playlists);

  @override
  List<Object> get props => [playlists];
}

class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError(this.message);

  @override
  List<Object> get props => [message];
}
