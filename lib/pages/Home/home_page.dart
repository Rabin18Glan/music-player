
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:musicplayer/collections.dart';
import 'package:musicplayer/fetchsongs.dart';
import 'package:musicplayer/pages/Albums/albums.dart';
import 'package:musicplayer/pages/Favorites/favorites.dart';
import 'package:musicplayer/pages/Player/player.dart';
import 'package:musicplayer/pages/Playlist/play_list.dart';
// import 'package:musicplayer/pages/Songs/songController.dart';
import 'package:musicplayer/pages/Songs/songs.dart';
import 'package:get/get.dart';
import 'package:musicplayer/playController.dart';
import 'package:musicplayer/routes/app_routes.dart';
import 'package:on_audio_query/on_audio_query.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final audioController = Get.put(AudioController());
  final playerController =  Get.put(PlayerController());
  final collectionController = Get.put(CollectionController());
  int navnumber=0;
  Future<String> makePlaylist()async{

    await audioController.fetchSongs();
    await  playerController.openPlayList(audioController.songs);

    return 'done';

  }

@override
void initState() {
    // TODO: implement initState
    super.initState();
    // audioController.fetchSongs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
      body:Stack
        (children: [

        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/player2.jpg'),
                  fit: BoxFit.cover
              )
          ),
        ),

 Container(
   child: Stack(
     children: [

               Container(
                 height: 130,

                     color: Colors.black26,

                 child:   Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [

                     IconButton(
                         onPressed:()=>{

                           Get.to(Favorites())

                         },
                         icon:Icon(Icons.favorite,color:  navnumber==1?Colors.purpleAccent:Colors.white,size: 35,)),

                     IconButton(
                         onPressed:()=>{
                            Get.to(PlayList())
                         },
                         icon:Icon(Icons.playlist_play_outlined,color: navnumber==2?Colors.purpleAccent:Colors.white,size: 35,)),
                     IconButton(
                         onPressed:()=>{
                         Get.to(Albums())
                         },
                         icon:Icon(Icons.album_outlined,color:  navnumber==3?Colors.purpleAccent:Colors.white,size: 35,)),
                   ],
                 ),

       ),
                Container(
         width: double.infinity,
         margin: EdgeInsets.only(top: 100),
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color:Color.fromRGBO(0 ,0, 0, 0.92),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
        ),

         child:FutureBuilder(future:makePlaylist(), builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    // Display a loading indicator while waiting for the future to complete
    return Center(child: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(200),
        image: DecorationImage(
          image: AssetImage('assets/image/music.gif')

        )
      ),
    ));
    }
    else if(snapshot.hasError)
      {
        return Center(
          child: Text("${snapshot.error}",style: TextStyle(color: Colors.white),),);
      }
    else if(snapshot.connectionState==ConnectionState.done ){
return Songs();

    }
    else {
     return Text("sorry");
    }
    })
       )
     ],
   ),
 )


      ],)




    );
  }
}


