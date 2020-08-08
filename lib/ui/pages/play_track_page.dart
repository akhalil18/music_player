import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/page_models/play_track_page_model.dart';
import '../../core/utils/screen_utill.dart';
import '../shared/base_widget.dart';

class PlayTrackPage extends StatelessWidget {
  final Track track;
  PlayTrackPage({this.track});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PlayTrackPageModel>(
      model: PlayTrackPageModel(),
      initState: (m) => m.initPlayer(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(track.trackName), centerTitle: true),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  buildImage(),
                  buildTrackSlider(context, model),
                  buildTrackDuration(model),
                  buildControlRow(model)
                ],
              ),
            )),
      ),
    );
  }

  Row buildControlRow(PlayTrackPageModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          iconSize: 30,
          icon: Icon(Icons.stop),
          onPressed: () => model.stop(),
        ),
        IconButton(
          iconSize: 80,
          icon: model.isPlay
              ? Icon(Icons.pause_circle_filled)
              : Icon(Icons.play_circle_filled),
          onPressed: () => model.play(track.trackUrl),
        ),
        IconButton(
          iconSize: 25,
          icon: model.repeat
              ? Icon(Icons.repeat, color: Colors.green)
              : Icon(Icons.repeat),
          onPressed: () => model.togleRepeat(),
        ),
      ],
    );
  }

  Container buildTrackDuration(PlayTrackPageModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // playing duration
          Text(formatDate(
              DateTime(1989, 02, 1, model.positionSound.inHours,
                  model.positionSound.inMinutes, model.positionSound.inSeconds),
              [HH, ':', nn, ':', ss]).toString()),
          // track duratio
          Text(formatDate(
              DateTime(1989, 02, 1, model.durationSound.inHours,
                  model.durationSound.inMinutes, model.durationSound.inSeconds),
              [HH, ':', nn, ':', ss]).toString()),
        ],
      ),
    );
  }

  SliderTheme buildTrackSlider(BuildContext context, PlayTrackPageModel model) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 18.0),
      ),
      child: Container(
        child: Slider.adaptive(
          value: double.parse(model.positionSound.inSeconds.toString()),
          min: 0,
          max: double.parse(model.durationSound.inSeconds.toString()),
          onChanged: (v) {
            final position = v;
            model.audioPlayer.seek(Duration(seconds: position.round()));
          },
          // divisions: maxDuration.toInt(),
        ),
      ),
    );
  }

  Image buildImage() {
    return Image.asset(
      'assets/images/music.png',
      height: ScreenUtil.portrait
          ? ScreenUtil.screenHeightDp * 0.6
          : ScreenUtil.screenHeightDp * 0.42,
    );
  }
}
