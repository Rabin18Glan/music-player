part of 'audio_bloc.dart';


abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object?> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final List<SongModel> songs;
  final SongModel currentSong;
  final Duration position;
  final bool isPlaying;

  const AudioLoaded({
    required this.currentSong,
    required this.position,
    required this.isPlaying,
    required this.songs
  });

  AudioLoaded copyWith({
    SongModel? currentSong,
    Duration? position,
    bool? isPlaying,
    List<SongModel>? songs
  }) {
    return AudioLoaded(
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      songs:songs ?? this.songs
    );
  }

  @override
  List<Object?> get props => [currentSong, position, isPlaying,songs];
}

class AudioError extends AudioState {
  final String message;

  const AudioError(this.message);

  @override
  List<Object?> get props => [message];
}