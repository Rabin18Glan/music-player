import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

abstract class AudioLocalDataSource {
  Future<List<SongModel>> getAllSongs();
  Future<void> playSong(SongModel song);
  Future<void> pauseSong();
  Future<void> resumeSong();
  Future<void> stopSong();
  Future<void> seekTo(Duration position);
  Stream<Duration> getPositionStream();
  Stream<bool> getPlayingStateStream();
  Stream<Duration?> getDurationStream();
}

class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _playingStateController = StreamController<bool>.broadcast();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  AudioLocalDataSourceImpl() {
    _audioPlayer.playerStateStream.listen((state) {
      _playingStateController.add(state.playing);
    });
  }

  @override
  Future<List<SongModel>> getAllSongs() async {
    // Request storage permissions
    if (!await _audioQuery.permissionsStatus()) {
      if (!await _audioQuery.permissionsRequest()) {
        if (kDebugMode) {
          print('Storage permission denied.');
        }
        return [];
      }
    }

    try {
      // Query all audio files from the device
      final List<SongModel> audioFiles = await _audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      return audioFiles;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching songs: $e');
      }

      return [];
    }
  }

  @override
  Future<void> playSong(SongModel song) async {
    await _audioPlayer.setUrl(song.uri ?? "");

    await _audioPlayer.play();
  }

  @override
  Future<void> pauseSong() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> resumeSong() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> stopSong() async {
    await _audioPlayer.stop();
  }

  @override
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Stream<Duration> getPositionStream() {
    return _audioPlayer.positionStream;
  }

  @override
  Stream<bool> getPlayingStateStream() {
    return _playingStateController.stream;
  }

  @override
  Stream<Duration?> getDurationStream() {
    return _audioPlayer.durationStream;
  }

  void dispose() {
    _playingStateController.close();
    _audioPlayer.dispose();
  }
}
