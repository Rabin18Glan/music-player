import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CollectionController extends GetxController {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  RxList FavoriteList = [].obs;
  RxList PlaylistList = [[]].obs;

  bool isInFavorite(SongModel song)
  {
    return FavoriteList.any((item) => item["song"] == song);
  }

  void addToFavorite(SongModel song,int index) {
    if(isInFavorite(song))
      {
       return ;
      }
    FavoriteList.add({"song":song,"index":index});
  }
void removeFavorite(SongModel song)
{

      FavoriteList.removeWhere((item) => item["song"] == song);

}
  List getFavorite()
  {
    return FavoriteList;
  }

  String makeNewPlayList(audio,ListName){
    if(PlaylistList.contains(ListName))
      {
      return "Already Exists";
      }
    else {
      List ListName = [];
      ListName.add(audio);
      PlaylistList.add(ListName);
      return "Done";
    }

  }
  String addtoPlayList(audio,ListName){

    PlaylistList[PlaylistList.indexOf(ListName)].add(audio);

    return "Done";

  }

List getPlaylist(ListName) {
return  PlaylistList[PlaylistList.indexOf(ListName)];
  }


}
