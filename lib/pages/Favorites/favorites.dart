import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/collections.dart';
import 'package:musicplayer/fetchsongs.dart';
import 'package:musicplayer/pages/Player/player.dart';
import 'package:musicplayer/playController.dart';
import 'package:musicplayer/routes/app_routes.dart';
class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final PlayerController playerController = Get.find();
  final CollectionController collectionController = Get.find();
  final AudioController audioController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: Stack(
        children:
        [
          Obx(() => collectionController.FavoriteList.isEmpty?Center(child: Text("No Favorites",style: TextStyle(color: Colors.white,fontSize: 25),),):
          ListView.builder(
              itemCount: collectionController.FavoriteList.length,
              itemBuilder: (context,index){
                return ListTile(
                  onTap: ()async
                  {
                    Get.toNamed(AppRoutes.player);
                    await playerController.audioPlayer.playlistPlayAtIndex(collectionController.FavoriteList[index]["index"]);

                    setState(() {

                      playerController.isplaying.value = playerController.audioPlayer.isPlaying.value;
                    });

                  },
                  leading: CircleAvatar(
                    child: Icon(Icons.music_note),
                  ),
                  title: Text(collectionController.FavoriteList[index]["song"].title,style: TextStyle(color: Colors.white),),
                  subtitle: Text(collectionController.FavoriteList[index]["song"].artist,style: TextStyle(color: Colors.white),),
                );

              }),
          ),
          Obx(() =>  Align(

              alignment: Alignment(0,0.9),
              child:
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.black,
                  boxShadow: [
                    playerController.isPlaying()&&!playerController.audioPlayer.stopped&&playerController.isplaying.value?
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(1), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 20, // Blur radius

                    ): BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.3), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 20, // Blur radius

                    ),
                  ],
                ),
                child: IconButton(onPressed: (){

                  Get.toNamed(AppRoutes.player);

                }, icon:Icon(Icons.music_note,size: 60,color: Colors.white,
                )),
              )
          )),],
      )
    );
  }
}
