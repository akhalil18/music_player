import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/core/utils/screen_utill.dart';

import '../../core/models/album.dart';
import '../../core/page_models/tracks_page_model.dart';
import '../../core/routes/routing_constants.dart';
import '../shared/base_widget.dart';
import '../widgets/add_track_bottom_sheet.dart';

class TracksPage extends StatelessWidget {
  final Album album;

  TracksPage({this.album});

  @override
  Widget build(BuildContext context) {
    return BaseWidget<TracksPageModel>(
      model: TracksPageModel(),
      initState: (m) => WidgetsBinding.instance
          .addPostFrameCallback((_) => m.getAllTracks(album.id)),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        floatingActionButton: buildAddTrackFloatingActionButton(context, model),
        appBar: AppBar(centerTitle: true, title: Text(album.name)),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : model.tracks.isEmpty
                ? buildNoTracksWidget(model)
                : buildTracksList(model, context),
      ),
    );
  }

  FloatingActionButton buildAddTrackFloatingActionButton(
      BuildContext context, TracksPageModel model) {
    return FloatingActionButton(
      onPressed: () => addTrack(context, model),
      child: Icon(Icons.add),
    );
  }

  SingleChildScrollView buildTracksList(
      TracksPageModel model, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // if there is new track uploading
          if (model.isLoading)
            LinearProgressIndicator(),
          Column(
              children: model.tracks
                  .map((t) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.screenWidthDp * 0.03,
                            vertical: ScreenUtil.screenHeightDp * 0.01),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            PlayTrackScreenRoute,
                            arguments: t,
                          ),
                          onLongPress: () => deleteTask(context, model, t.id),
                          child: Card(
                            margin: EdgeInsets.only(top: 10),
                            child: ListTile(
                              leading: Icon(Icons.music_note,
                                  color: Theme.of(context).accentColor),
                              title: Text(
                                t.trackName,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Icon(Icons.play_circle_filled,
                                  color: Colors.brown[300]),
                            ),
                          ),
                        ),
                      ))
                  .toList()),
        ],
      ),
    );
  }

  Column buildNoTracksWidget(TracksPageModel model) {
    return Column(
      children: <Widget>[
        if (model.isLoading) LinearProgressIndicator(),
        Expanded(
          child: Center(
            child: Text(
              'No songs added yet, try to add one!',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void addTrack(BuildContext context, TracksPageModel model) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddTrackBottomSheet((
          {String trackName, String trackId, File track}) async {
        Navigator.of(context).pop();
        model.addTrack(
          albumId: album.id,
          track: track,
          trackId: trackId,
          trackName: trackName,
        );
      }),
    );
  }

  Future<void> deleteTask(
      BuildContext context, TracksPageModel model, String trackId) async {
    final confirmDelete = await buildDeleteTrackDialog(context);
    print(confirmDelete);
    if (confirmDelete) {
      model.deleteTrack(albumId: album.id, trackId: trackId);
    }
  }

  Future<bool> buildDeleteTrackDialog(BuildContext context) async {
    bool delete = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Delet Track !',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text('Are you sure you want to delete this Track ?'),
        actions: <Widget>[
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              delete = true;
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              delete = false;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    return delete;
  }
}
