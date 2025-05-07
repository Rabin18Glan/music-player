import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddToFavorites extends FavoritesEvent {
  final SongModel  song;

  const AddToFavorites(this.song);

  @override
  List<Object> get props => [song];
}

class RemoveFromFavorites extends FavoritesEvent {
  final SongModel  song;

  const RemoveFromFavorites(this.song);

  @override
  List<Object> get props => [song];
}

// States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<SongModel> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  List<SongModel> _favorites = [];

  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      await _loadFavoritesFromStorage();
      emit(FavoritesLoaded(_favorites));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      // Check if SongModel  already exists in favorites
      if (_favorites.any((song) => song.id == event.song.id)) {
        emit(FavoritesError('SongModel  already in favorites'));
        return;
      }

      _favorites.add(event.song);
      await _saveFavoritesToStorage();
      emit(FavoritesLoaded(_favorites));
    } catch (e) {
      emit(FavoritesError('Failed to add to favorites: ${e.toString()}'));
    }
  }

  void _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      _favorites =
          _favorites.where((song) => song.id != event.song.id).toList();
      await _saveFavoritesToStorage();
      emit(FavoritesLoaded(_favorites));
    } catch (e) {
      emit(FavoritesError('Failed to remove from favorites: ${e.toString()}'));
    }
  }

  Future<void> _loadFavoritesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');

    if (favoritesJson != null) {
     _favorites = jsonDecode(favoritesJson);

    } else {
      _favorites = [];
    }
  }

  Future<void> _saveFavoritesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(_favorites));
  }
}
