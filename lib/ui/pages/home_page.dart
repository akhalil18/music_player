import 'package:flutter/material.dart';
import 'package:music_player/core/utils/screen_utill.dart';

import '../../core/models/album.dart';
import '../../core/page_models/home_page_model.dart';
import '../../core/routes/routing_constants.dart';
import '../shared/base_widget.dart';
import '../widgets/add_album_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomePageModel>(
      model: HomePageModel(),
      initState: (m) =>
          WidgetsBinding.instance.addPostFrameCallback((_) => m.getAllAlbums()),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: AppBar(
          title: Text('My Albums'),
          actions: <Widget>[
            buildAddAlbumButton(context, model),
          ],
        ),
        body: model.busy
            ? Center(child: CircularProgressIndicator())
            : model.albums == null
                ? buildErrorWidget()
                : buildAlbumsList(model),
      ),
    );
  }

  Center buildErrorWidget() {
    return Center(
        child: Text('Ooops..something wrong, try again later',
            style: TextStyle(fontSize: 18, color: Colors.red)));
  }

  FlatButton buildAddAlbumButton(BuildContext context, HomePageModel model) {
    return FlatButton.icon(
      icon: Icon(Icons.add, color: Theme.of(context).accentColor),
      onPressed: () => addAlbum(context, model),
      label: Text(
        'Add Album',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
    );
  }

  addAlbum(BuildContext context, HomePageModel model) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddAlbumBottomSheet((Album album) async {
        Navigator.of(context).pop();
        model.addAlbum(album);
      }),
    );
  }

  Widget buildAlbumsList(HomePageModel model) {
    return model.albums.isEmpty
        ? Center(
            child: Text('No albums added yet, try to add one!',
                style: TextStyle(fontSize: 18, color: Colors.red)))
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil.screenHeightDp * 0.01,
              horizontal: ScreenUtil.screenWidthDp * 0.01,
            ),
            child: Column(
              children: <Widget>[
                // if is loading
                if (model.isLoading)
                  LinearProgressIndicator(),

                // Albums list
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: model.albums.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(TracksScreenRoute,
                          arguments: model.albums[index]);
                    },
                    onLongPress: () =>
                        deleteAlbum(context, model, model.albums[index].id),
                    leading: Icon(Icons.folder, color: Colors.brown),
                    title: Text(model.albums[index].name),
                    trailing: Icon(Icons.arrow_forward, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> deleteAlbum(
      BuildContext context, HomePageModel model, String id) async {
    final confirmDelete = await buildDeleteAlbumDialog(context);
    print(confirmDelete);
    if (confirmDelete) {
      model.deleteAlbum(id);
    }
  }

  Future<bool> buildDeleteAlbumDialog(BuildContext context) async {
    bool delete = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Delet Album !',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text('Are you sure you want to delete this album ?'),
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
