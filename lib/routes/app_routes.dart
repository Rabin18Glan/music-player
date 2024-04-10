

import 'package:get/get.dart';
import 'package:musicplayer/pages/Home/home_page.dart';
import 'package:musicplayer/pages/Player/player.dart';

class AppRoutes {
  static const String home = '/';

  static const String player = '/player';
  static List<GetPage> pages = [
    GetPage(
      name:home,
      page: () => Home(),
    ),
    GetPage(
      name: player,
      page: () =>Player(),
    ),



  ];
}
