import 'dart:async';
import 'dart:ffi';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:controllable_widgets/controllable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/fetchsongs.dart';
import 'package:musicplayer/pages/Home/home_page.dart';
import 'package:musicplayer/pages/Player/player.dart';
import 'package:musicplayer/playController.dart';

import 'package:musicplayer/routes/app_routes.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {

final AudioController audioController = Get.find();
final PlayerController playerController = Get.find();

@override void initState(){
    // TODO: implement initState
  if(playerController.audioPlayer.current.hasValue)
  {
    playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index];
  }
  // playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index];
    super.initState();
    // setState(() async{

    // });

  }



  @override
  Widget build(BuildContext context) {
  return  Stack(
    children: [
      ListView.builder(
          physics: const BouncingScrollPhysics(),

          itemCount:audioController.songs.length ,
          itemBuilder: (BuildContext contex,int index){
            if(audioController.songs.isEmpty)
            {
              return Center(
                  child: CircularProgressIndicator()
              );
            }
            else
            {
              return ListTile(
                leading: CircleAvatar(
                  child:Icon(Icons.music_note_outlined),
                ),
                onTap: ()async{
                  Get.toNamed(AppRoutes.player);
                  await playerController.audioPlayer.playlistPlayAtIndex(index);
                  setState((){

                    playerController.isplaying.value = playerController.audioPlayer.isPlaying.value;
                  });



                },
                title: Text(audioController.songs![index].title??"",style: TextStyle(color: Colors.white),),
                subtitle: Text(audioController.songs![index].artist??"",style: TextStyle(color: Colors.white),),

              );
            }

          }),

      Obx(() =>  Align(

          alignment: Alignment(1,0.5),
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
      )),
      Obx(() => playerController.audioPlayer.current.hasValue?Align(

        alignment: Alignment(0,0.95),
        child: Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black87.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 20
                )
              ]
          ),
          height: 120,
          width: double.infinity,
          child: ListTile(
            onTap: (){
              Get.toNamed(AppRoutes.player);
            },
            leading: CircleAvatar(
              radius: 23,
              child: Icon(Icons.music_note,color: Colors.black87,size: 40,),
            ),
            title: Text(playerController.metas?.title??"SOng"),
            subtitle: Text(playerController.metas?.artist??"Artist"),
            trailing:     IconButton(
                onPressed: ()async
                {
                  if(playerController.isplaying.value)
                  {
                    await playerController.audioPlayer.pause();

                  }
                  else{
                    await playerController.audioPlayer.play();
                  }
                  setState(() {
                    playerController.isplaying.value=playerController.audioPlayer.isPlaying.value;

                  });

                },
                icon:playerController.isplaying.value?
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Colors.black87,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple, // Shadow color
                        spreadRadius: 10, // Spread radius
                        blurRadius: 10, // Blur radius
// Blur radius

                      ),
                    ],
                  ),
                  child:  Icon(Icons.pause,size: 30,color: Colors.white,),
                )

                    :Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(

                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple, // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 10, // Blur radius

                      ),
                    ],
                  ),
                  child:  Icon(Icons.play_arrow_sharp,size:30,color: Colors.white,),
                )),
          ),
        ),
      ):Container(),),


    ],
  );











  }
}
