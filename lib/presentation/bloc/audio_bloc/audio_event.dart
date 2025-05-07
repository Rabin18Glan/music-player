part of 'audio_bloc.dart';
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