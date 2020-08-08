import 'dart:io';

import 'package:flutter/material.dart';

import '../../ui/shared/base_notifier.dart';
import '../models/track.dart';
import '../services/firestore_service.dart';

class TracksPageModel extends BaseNotifier {
  List<Track> _tracks = [];
  final _firestoreService = FirestoreService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  List<Track> get tracks => _tracks;

  /// get all tracks
  /// if fail, tracks list = null
  Future<void> getAllTracks(String albumId) async {
    setBusy(true);
    final fetchedTracks = await _firestoreService.fetchTracks(albumId);

    if (fetchedTracks == null) {
      setBusy(false);
      return;
    } else {
      _tracks = fetchedTracks;
      setBusy(false);
    }
  }

  // Add new track
  Future<void> addTrack(
      {String albumId, File track, String trackName, String trackId}) async {
    isLoading = true;
    setState();
    var isAded = await _firestoreService.addTrack(
      albumId: albumId,
      track: track,
      trackId: trackId,
      trackName: trackName,
    );

    if (isAded) {
      // update tracks list.
      _tracks = await _firestoreService.fetchTracks(albumId);
      isLoading = false;
      setState();
      showSnack('New Track aded');
    } else {
      isLoading = false;
      setState();
      showSnack('Ooops..something wrong, try one more time');
    }
  }

  // delete Track
  Future<void> deleteTrack({String albumId, String trackId}) async {
    isLoading = true;
    setState();

    final isDeleted =
        await _firestoreService.deleteTrack(albumId: albumId, trackId: trackId);
    if (isDeleted) {
      // update tracks list.
      _tracks = await _firestoreService.fetchTracks(albumId);
      isLoading = false;
      setState();
      showSnack('Track delete successfully');
    } else {
      isLoading = false;
      setState();
      showSnack('Ooops..something wrong, try one more time');
    }
  }

  void showSnack(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
