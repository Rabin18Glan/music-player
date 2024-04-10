import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/playController.dart';
import 'package:musicplayer/routes/app_routes.dart';
class Albums extends StatefulWidget {
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final PlayerController playerController = Get.find();
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
        children: [Center(child: Text("No Abumns",style: TextStyle(color: Colors.white,fontSize: 25),),),
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
