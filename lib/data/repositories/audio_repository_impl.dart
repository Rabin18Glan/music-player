import 'package:music_player/data/datasources/audio_local_data_source.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:music_player/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioLocalDataSource localDataSource;

  AudioRepositoryImpl({required this.localDataSource});

  @override
  Future<List<SongModel>> getAllSongs() async {
   return await localDataSource.getAllSongs();
  
  }

  @override
  Future<void> playSong(SongModel song) async {
    await localDataSource.playSong(song);
  }

  @override
  Future<void> pauseSong() async {
    await localDataSource.pauseSong();
  }

  @override
  Future<void> resumeSong() async {
    await localDataSource.resumeSong();
  }

  @override
  Future<void> stopSong() async {
    await localDataSource.stopSong();
  }

  @override
  Future<void> seekTo(Duration position) async {
    await localDataSource.seekTo(position);
  }

  @override
  Stream<Duration> getPositionStream() {
    return localDataSource.getPositionStream();
  }

  @override
  Stream<bool> getPlayingStateStream() {
    return localDataSource.getPlayingStateStream();
  }

  @override
  Stream<Duration?> getDurationStream() {
    return localDataSource.getDurationStream();
  }
}
