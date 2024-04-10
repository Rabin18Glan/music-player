import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/fetchsongs.dart';
import 'package:musicplayer/pages/Home/home_page.dart';
import 'package:musicplayer/pages/Player/player.dart';
import 'package:musicplayer/playController.dart';
import 'package:musicplayer/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
    );
  }
}