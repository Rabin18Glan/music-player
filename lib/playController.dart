import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PlayerController extends GetxController {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  RxBool isplaying = false.obs;
  int index=0;
  dynamic metas;

Future<void> openPlayList(List playlist)async
  {
    List<Audio> audios = playlist.map((element) => Audio.network(element.uri,metas: Metas(

        extra: {
          "favorite":false
        }
    ))).toList();

   await audioPlayer.open(
        Playlist(
     audios:audios
   ),autoStart:false,showNotification: true
    );
  }


   void prevSong()
  {
   audioPlayer.previous();
  }

  void playSong()
  {
    audioPlayer.play();
  }

  void pauseSong() {
    audioPlayer.pause();
  }
bool isPlaying(){
  isplaying.value = audioPlayer.isPlaying.value;
    return isplaying.value;
}
}
