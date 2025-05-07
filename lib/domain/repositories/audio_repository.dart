
import 'package:on_audio_query_forked/on_audio_query.dart';
abstract class AudioRepository {
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
