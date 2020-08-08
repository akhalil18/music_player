import 'dart:async';

import 'package:flutter/material.dart';

import '../../ui/shared/base_notifier.dart';
import '../models/album.dart';
import '../services/firestore_service.dart';

class HomePageModel extends BaseNotifier {
  List<Album> _albums;
  final _firestoreService = FirestoreService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  /// fetched albums
  List<Album> get albums => _albums;

  /// get all albums
  /// if fail, albums list = null
  Future<void> getAllAlbums() async {
    setBusy(true);
    final fetchedAlbums = await _firestoreService.fetchAllAlbums();

    if (fetchedAlbums == null) {
      setBusy(false);
      return;
    } else {
      _albums = fetchedAlbums;
      setBusy(false);
    }
  }

  /// Add new album.
  Future<void> addAlbum(Album album) async {
    var isAded = await _firestoreService.addAlbum(album.id, album.name);
    if (isAded) {
      _albums.add(album);
      setState();
      showSnack('New Album aded');
    } else {
      showSnack('Ooops..something wrong, try one more time');
    }
  }

  // delete Album
  Future<void> deleteAlbum(String albumId) async {
    isLoading = true;
    setState();

    final isDeleted = await _firestoreService.deleteAlbum(albumId: albumId);
    if (isDeleted) {
      // update albums list.
      _albums.removeWhere((a) => a.id == albumId);
      isLoading = false;
      setState();
      showSnack('Album delete successfully');
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
