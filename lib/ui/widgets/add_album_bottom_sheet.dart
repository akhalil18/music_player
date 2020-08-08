import 'package:flutter/material.dart';
import 'package:music_player/core/models/album.dart';
import 'package:uuid/uuid.dart';

class AddAlbumBottomSheet extends StatefulWidget {
  final Future<void> Function(Album addedAlbum) addAlbum;
  AddAlbumBottomSheet(
    this.addAlbum,
  );

  @override
  _AddAlbumBottomSheetState createState() => _AddAlbumBottomSheetState();
}

class _AddAlbumBottomSheetState extends State<AddAlbumBottomSheet> {
  bool hasError = false;
  String errorMessage;
  String albumId = Uuid().v4();

  TextEditingController _albumNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        right: 15,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            albumTextField(),
            SizedBox(height: 10),
            buildSubmitButton()
          ],
        ),
      ),
    );
  }

  TextField albumTextField() {
    return TextField(
      controller: _albumNameController,
      autofocus: true,
      maxLines: 1,
      decoration: InputDecoration(
          errorText: hasError ? errorMessage : null,
          isDense: true,
          border: InputBorder.none,
          hintText: 'Album name'),
    );
  }

  RaisedButton buildSubmitButton() {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0.0,
      child: Text('Add'),
      onPressed: () async {
        // If track field is empty show error.
        if (_albumNameController.text.isEmpty) {
          errorMessage = 'Album name is empty!';
          setState(() {
            hasError = true;
          });
          return;
        }

        // Add Album callback
        await widget
            .addAlbum(Album(id: '$albumId', name: _albumNameController.text));
        _albumNameController.clear();
      },
    );
  }
}
