import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/domain/repositories/audio_repository.dart';

part 'audio_event.dart';
part 'audio_state.dart';

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
      _updateState(position: position);
    });

    // Listen to playing state updates
    audioRepository.getPlayingStateStream().listen((isPlaying) {
      _updateState(isPlaying: isPlaying);
    });
  }

  void _onLoadAudioFiles(LoadAudioFiles event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      final songs = await audioRepository.getAllSongs();
      emit(
        AudioLoaded(
          songs: songs,
          currentSong: songs[0],
          position: Duration.zero,
          isPlaying: false,
        ),
      );
    } catch (e) {
      emit(AudioError('Failed to load songs: ${e.toString()}'));
    }
  }

  void _onPlaySong(PlaySong event, Emitter<AudioState> emit) async {
    try {
      _currentSong = event.song;
      _currentPosition = Duration.zero;
      _isPlaying = true;

      _updateState(
        currentSong: event.song,
        position: Duration.zero,
        isPlaying: true,
      );

      await audioRepository.playSong(event.song);
    } catch (e) {
      emit(AudioError('Failed to play song: ${e.toString()}'));
    }
  }

  void _onPauseSong(PauseSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.pauseSong();
      _updateState(isPlaying: false);
    }
  }

  void _onResumeSong(ResumeSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.resumeSong();
      _updateState(isPlaying: true);
    }
  }

  void _onStopSong(StopSong event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.stopSong();
      _updateState(isPlaying: false, position: Duration.zero);
    }
  }

  void _onSeekToPosition(SeekToPosition event, Emitter<AudioState> emit) async {
    if (_currentSong != null) {
      await audioRepository.seekTo(event.position);
      _updateState(position: event.position);
    }
  }

  void _updateState({
    SongModel? currentSong,
    Duration? position,
    bool? isPlaying,
  }) {
    if (state is AudioLoaded) {
      emit(
        (state as AudioLoaded).copyWith(
          currentSong: currentSong ?? _currentSong,
          position: position ?? _currentPosition,
          isPlaying: isPlaying ?? _isPlaying,
        ),
      );
    }
  }
}
