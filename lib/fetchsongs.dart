import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Global audio player

  // Global list of songs
  RxList<SongModel> songs = <SongModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

 Future<void> fetchSongs() async {
    final List<SongModel> fetchedSongs = await _audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    songs.value = fetchedSongs;

  }
  checkPermission()async{
    var permission = await Permission.storage.request();
    if(permission.isGranted)
    {
    }
    else{
      checkPermission();
    }
  }
}
