import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/domain/repositories/audio_repository.dart';

// Events
abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class LoadAudioFiles extends AudioEvent {}

class PlaySong extends AudioEvent {
  final SongModel song;

  const PlaySong(this.song);

  @override
  List<Object> get props => [song];
}

class PauseSong extends AudioEvent {}

class ResumeSong extends AudioEvent {}

class StopSong extends AudioEvent {}

class SeekToPosition extends AudioEvent {
  final Duration position;

  const SeekToPosition(this.position);

  @override
  List<Object> get props => [position];
}

// States
abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object?> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioLoaded extends AudioState {
  final List<SongModel> songs;

  const AudioLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class AudioPlaying extends AudioState {
  final SongModel currentSong;
  final Duration position;
  final bool isPlaying;

  const AudioPlaying({
    required this.currentSong,
    required this.position,
    required this.isPlaying,
  });

  AudioPlaying copyWith({
    SongModel? currentSong,
    Duration? position,
    bool? isPlaying,
  }) {
    return AudioPlaying(
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [currentSong, position, isPlaying];
}

class AudioError extends AudioState {
  final String message;

  const AudioError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioRepository audioRepository;
  SongModel? _currentSong;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  AudioBloc({required this.audioRepository}) : super(AudioInitial()) {
    on<LoadAudioFiles>(_onLoadAudioFiles);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<StopSong>(_onStopSong);
    on<SeekToPosition>(_onSeekToPosition);

    // Listen to position updates
    audioRepository.getPositionStream().listen((position) {
      _currentPosition = position;
      if (_currentSong != null && state is AudioPlaying) {
        emit(
          AudioPlaying(
            currentSong: _currentSong!,
            position: position,
            isPlaying: _isPlaying,
          ),
        );
      }
    });

    // Listen to playing state updates
    audioRepository.getPlayingStateStream().listen((isPlaying) {
      _isPlaying = isPlaying;
      if (_currentSong != null && state is AudioPlaying) {
        emit(
          AudioPlaying(
            currentSong: _currentSong!,
            position: _currentPosition,
            isPlaying: isPlaying,
          ),
        );
      }
    });
  }

  void _onLoadAudioFiles(LoadAudioFiles event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      final songs = await audioRepository.getAllSongs();
      emit(AudioLoaded(songs));
    } catch (e) {
      emit(AudioError('Failed to load songs: ${e.toString()}'));
    }
  }

  void _onPlaySong(PlaySong event, Emitter<AudioState> emit) async {
    try {
      _currentSong = event.song;
      _currentPosition = Duration.zero;
      _isPlaying = true;

      emit(
        AudioPlaying(
          currentSong: event.song,
          position: Duration.zero,
          isPlaying: true,
        ),
      );

      await audioRepository.playSong(event.song);
    } catch (e) {
      emit(AudioError('Failed to play song: ${e.toString()}'));
    }
  }

  void _onPauseSong(PauseSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.pauseSong();
      _isPlaying = false;

      if (state is AudioPlaying) {
        emit((state as AudioPlaying).copyWith(isPlaying: false));
      }
    }
  }

  void _onResumeSong(ResumeSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.resumeSong();
      _isPlaying = true;

      if (state is AudioPlaying) {
        emit((state as AudioPlaying).copyWith(isPlaying: true));
      }
    }
  }

  void _onStopSong(StopSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.stopSong();
      _isPlaying = false;
      _currentPosition = Duration.zero;

      if (state is AudioPlaying) {
        emit(
          (state as AudioPlaying).copyWith(
            isPlaying: false,
            position: Duration.zero,
          ),
        );
      }
    }
  }

  void _onSeekToPosition(SeekToPosition event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.seekTo(event.position);
      _currentPosition = event.position;

      if (state is AudioPlaying) {
        emit((state as AudioPlaying).copyWith(position: event.position));
      }
    }
  }
}
