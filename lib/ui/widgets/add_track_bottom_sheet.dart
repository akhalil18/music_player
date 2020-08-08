import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddTrackBottomSheet extends StatefulWidget {
  final Future<void> Function({String trackName, String trackId, File track})
      addTrack;
  AddTrackBottomSheet(
    this.addTrack,
  );

  @override
  _AddTrackBottomSheetState createState() => _AddTrackBottomSheetState();
}

class _AddTrackBottomSheetState extends State<AddTrackBottomSheet> {
  bool hasError = false;
  String errorMessage;
  String trackId = Uuid().v4();
  File _pickedAudio;
  TextEditingController _trackController = TextEditingController();

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
            buildPickedFileRow(),
            SizedBox(height: 10),
            buildSubmitButton()
          ],
        ),
      ),
    );
  }

  TextField albumTextField() {
    return TextField(
      controller: _trackController,
      maxLines: 1,
      decoration: InputDecoration(
          errorText: hasError ? errorMessage : null,
          isDense: true,
          border: InputBorder.none,
          hintText: 'Enter track name.'),
    );
  }

  RaisedButton buildSubmitButton() {
    return RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: 0.0,
      child: Text('Add'),
      onPressed: () async {
        // If track field is empty show error.
        if (_trackController.text.isEmpty) {
          errorMessage = 'Track name is empty!';
          setState(() {
            hasError = true;
          });
          return;
        } else if (_pickedAudio == null) {
          return;
        }

        // Add Album callback
        await widget.addTrack(
          track: _pickedAudio,
          trackName: _trackController.text,
          trackId: trackId,
        );
        _trackController.clear();
      },
    );
  }

  buildPickedFileRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _pickedAudio == null
              ? Text('No file picked.', style: TextStyle(color: Colors.red))
              : Text('Track Picked successfully',
                  style: TextStyle(color: Colors.green)),
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () async {
              File file = await FilePicker.getFile(type: FileType.audio);
              if (file == null) {
                return;
              }
              setState(() {
                _pickedAudio = file;
              });
            },
          )
        ],
      ),
    );
  }
}
