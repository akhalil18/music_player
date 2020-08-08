import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/ui/shared/base_notifier.dart';

class PlayTrackPageModel extends BaseNotifier {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AudioPlayer audioPlayer = new AudioPlayer();
  String currentAudio = "";
  bool repeat = false;
  bool isPlay = false;

  Duration durationSound = new Duration(seconds: 0);
  Duration positionSound = new Duration(seconds: 0);

  void initPlayer() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      // print('Max duration: ${d.inSeconds}');
      durationSound = d;
      setState();
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      // print('Current position: ${p.inSeconds}');
      positionSound = p;
      setState();

      if (positionSound.inSeconds == durationSound.inSeconds && repeat) {
        positionSound = Duration(seconds: 0);
        repeatTrack(currentAudio);
      }
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case AudioPlayerState.PLAYING:
          isPlay = true;
          break;
        default:
          isPlay = false;
      }
      setState();
    });
  }

  /// play track
  /// if track is at end repeat
  Future<void> play(String url) async {
    // if audio end repeat
    if (positionSound.inSeconds == durationSound.inSeconds) {
      positionSound = Duration(seconds: 0);
      setState();
    }
    if (isPlay) {
      audioPlayer.pause();
    } else {
      int result = await audioPlayer.play(url, position: positionSound);
      if (result == 1) {
        currentAudio = url;
      } else {
        showSnack('Ooops..something wrong, try one more time');
      }
    }
  }

  /// stop track
  /// set poition to zero
  Future<void> stop() async {
    audioPlayer.stop();
    positionSound = Duration(seconds: 0);
    setState();
  }

  /// repeat treack
  Future<void> repeatTrack(String url) async {
    // if audio end repeat
    if (positionSound.inSeconds == durationSound.inSeconds) {
      positionSound = Duration(seconds: 0);
      setState();
    }
    int result = await audioPlayer.play(url, position: positionSound);
    if (result == 1) {
      currentAudio = url;
    } else {
      showSnack('Ooops..something wrong, try one more time');
    }
  }

// repat on or off
  void togleRepeat() {
    repeat = !repeat;
    setState();
  }

  @override
  void dispose() async {
    super.dispose();
    await audioPlayer.stop();
    audioPlayer.dispose();
  }

  void showSnack(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
