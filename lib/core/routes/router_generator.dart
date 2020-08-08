import 'package:flutter/material.dart';
import 'package:music_player/ui/pages/home_page.dart';
import 'package:music_player/ui/pages/tracks_page.dart';
import '../../ui/pages/play_track_page.dart';

import 'routing_constants.dart';

// app route class, handle app routing

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case HomeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomePage());

      case TracksScreenRoute:
        return MaterialPageRoute(builder: (_) => TracksPage(album: args));

      case PlayTrackScreenRoute:
        return MaterialPageRoute(builder: (_) => PlayTrackPage(track: args));

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
