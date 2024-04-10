import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/collections.dart';
import 'package:musicplayer/fetchsongs.dart';
import 'package:musicplayer/pages/Favorites/favorites.dart';
import 'package:musicplayer/playController.dart';
import 'package:musicplayer/routes/app_routes.dart';

class Player extends StatefulWidget {

  const Player({super.key,
  });


  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
static bool isBufferrring = false;
  double _currentSliderValue = 0;
  double _maxSliderValue = 100;
  Duration _totalDuration = Duration.zero;
  final PlayerController playerController = Get.find();
final AudioController audioController = Get.find();
final CollectionController collectionController = Get.find();
//
  @override
  void initState() {
    // TODO: implement initState
    // playSong();

   playerController.audioPlayer.currentPosition.listen((Duration duration) {
      setState(() {
        _currentSliderValue = duration.inSeconds.toDouble();
      });
    });
    // Get the total duration of the audio
playerController.audioPlayer.current.listen((Playing? playing) {

      setState(() {
        _totalDuration = playing?.audio.duration ?? Duration.zero;
        _maxSliderValue = _totalDuration.inSeconds.toDouble();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: ()=>{
            setState(()=>{
              Get.back()
            })
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body:PlayerBuilder.isPlaying(
          player: playerController.audioPlayer,
          builder: (BuildContext context, isPlaying)
          {
            if(playerController.audioPlayer.current.hasValue)
            {
              playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index];
            }
            if(isPlaying)
            {
              playerController.isplaying();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 350,
                    width: 350,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage('assets/image/background.jpg')
                            ,fit: BoxFit.cover
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child:    Column(
                      children: [
                        Text(playerController.metas?.title??"Song",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        Text(playerController.metas?.artist??"Unkown",style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child:  Row(

                      children: [
                        Text(
                          '${formatDuration(Duration(seconds: _currentSliderValue.toInt()))}',style: TextStyle(color: Colors.white),
                        ),
                        Expanded(child:  Slider(
                          activeColor: playerController.isplaying.value?Colors.deepPurple:Colors.blueGrey, // Change the color of the active track
                          inactiveColor: Colors.grey, // Change the color of the inactive track
                          thumbColor: playerController.isplaying.value?Colors.deepPurple:Colors.blueGrey, // Change the color of the thumb
                          // Change the color of the overlay when pressed

                          value: _currentSliderValue,
                          min: 0,
                          max:_maxSliderValue,
                          label: _currentSliderValue.round().toString(), // Optional: Shows value label
                          onChanged: (value) {
                            setState(() {
                              _currentSliderValue = value;
                              playerController.audioPlayer.seek(Duration(seconds: value.toInt()));
                            });
                          },
                        ),),
                        Text(' ${formatDuration(_totalDuration)}',style: TextStyle(color: Colors.white),)

                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          !collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?collectionController.addToFavorite(audioController.songs[playerController.audioPlayer.current.value!.index],playerController.audioPlayer.current.value!.index):
                          collectionController.removeFavorite(audioController.songs[playerController.audioPlayer.current.value!.index]);

                        });
                      },icon:Icon(collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?Icons.favorite:Icons.favorite_outline_rounded,color: Colors.grey,
                        shadows: [Shadow(
                          color: Colors.purple,
                          blurRadius: collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?20:0,

                        )],),),
                      IconButton(onPressed: (){}, icon:Icon(Icons.playlist_add_outlined,color: Colors.grey,))
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: ()async {
                            await playerController.audioPlayer.previous();
                            setState(()=>{

                              playerController.isplaying.value=playerController.audioPlayer.isPlaying.value,
                              playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index]
                            });
                          }, icon:Icon(Icons.skip_previous_outlined,color: Colors.white,size: 40,)),
                      IconButton(
                          onPressed: ()async
                          {
                              await playerController.audioPlayer.pause();
                              playerController.isplaying.value=playerController.audioPlayer.isPlaying.value;
                            setState(() {

                            });

                          },
                          icon:
                           Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              color: Colors.black87,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple, // Shadow color
                                  spreadRadius: 20, // Spread radius
                                  blurRadius: 20, // Blur radius
// Blur radius

                                ),
                              ],
                            ),
                            child:  Icon(Icons.pause,size: 100,color: Colors.white,),
                          )),

                      IconButton(
                        onPressed: ()async{
                          await  playerController.audioPlayer.next();
                          setState(()=>{

                            playerController.isplaying.value=playerController.audioPlayer.isPlaying.value,
                            playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index]
                          });
                        }, icon:Icon(Icons.skip_next_outlined),color: Colors.white,iconSize: 40,),
                    ],
                  )
                ],

              );
            }

            else{

              // playerController.isplaying.value=isPlaying;
             return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 350,
                    width: 350,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage('assets/image/background.jpg')
                            ,fit: BoxFit.cover
                        )
                    ),
                  ),
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 30),
                 child:    Column(
                   children: [
                     Text(playerController.metas?.title??"Song",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                     Text(playerController.metas?.artist??"Unkown",style: TextStyle(color: Colors.white))
                   ],
                 ),
               ),
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 30),
                   child:  Row(

                     children: [
                       Text(
                         '${formatDuration(Duration(seconds: _currentSliderValue.toInt()))}',style: TextStyle(color: Colors.white),
                       ),
                       Expanded(child:  Slider(
                         activeColor: playerController.isplaying.value?Colors.deepPurple:Colors.blueGrey, // Change the color of the active track
                         inactiveColor: Colors.grey, // Change the color of the inactive track
                         thumbColor: playerController.isplaying.value?Colors.deepPurple:Colors.blueGrey, // Change the color of the thumb
                         // Change the color of the overlay when pressed

                         value: _currentSliderValue,
                         min: 0,
                         max:_maxSliderValue,
                         label: _currentSliderValue.round().toString(), // Optional: Shows value label
                         onChanged: (value) {
                           setState(() {
                             _currentSliderValue = value;
                             playerController.audioPlayer.seek(Duration(seconds: value.toInt()));
                           });
                         },
                       ),),
                       Text(' ${formatDuration(_totalDuration)}',style: TextStyle(color: Colors.white),)

                     ],
                   ),
                 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          !collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?collectionController.addToFavorite(audioController.songs[playerController.audioPlayer.current.value!.index],playerController.audioPlayer.current.value!.index):
                          collectionController.removeFavorite(audioController.songs[playerController.audioPlayer.current.value!.index]);

                        });
                      },icon:Icon(collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?Icons.favorite:Icons.favorite_outline_rounded,color: Colors.grey,
                      shadows: [Shadow(
                        color: Colors.purple,
                        blurRadius: collectionController.isInFavorite(audioController.songs[playerController.audioPlayer.current.value!.index])?20:0,

                      )],),
                      ),
                      IconButton(onPressed: (){}, icon:Icon(Icons.playlist_add_outlined,color: Colors.grey,))
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: ()async {
                            await playerController.audioPlayer.previous();
                            setState(()=>{

                              playerController.isplaying.value=playerController.audioPlayer.isPlaying.value,
                              playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index]
                            });
                          }, icon:Icon(Icons.skip_previous_outlined,color: Colors.white,size: 40,)),
                      IconButton(
                          onPressed: ()async
                          {

                              await playerController.audioPlayer.play();
                              playerController.isplaying.value=playerController.audioPlayer.isPlaying.value;

                              setState(() {

                            });

                          },
                          icon:
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              color: Colors.black87,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple, // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 20, // Blur radius
// Blur radius

                                ),
                              ],
                            ),
                            child:  Icon(Icons.play_arrow_sharp,size: 100,color: Colors.white,),
                          )),

                      IconButton(
                        onPressed: ()async{
                          await  playerController.audioPlayer.next();
                          setState(()=>{

                            playerController.isplaying.value=playerController.audioPlayer.isPlaying.value,
                            playerController.metas = audioController.songs![playerController.audioPlayer.current.value!.index]
                          });
                        }, icon:Icon(Icons.skip_next_outlined),color: Colors.white,iconSize: 40,),
                    ],
                  )
                ],

              );
            }


          })


    );

  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
}
