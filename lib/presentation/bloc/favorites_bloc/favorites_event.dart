part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final SongModel song;

  const AddToFavorites(this.song);

  @override
  List<Object> get props => [song];
}

class RemoveFromFavorites extends FavoritesEvent {
  final SongModel song;

  const RemoveFromFavorites(this.song);

  @override
  List<Object> get props => [song];
}
