import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/album.dart';
import '../models/track.dart';

class FirestoreService {
  final albumsRef = Firestore.instance.collection('albums');
  final tracksRef = Firestore.instance.collection('tracks');
  final storageRef = FirebaseStorage.instance.ref();

  /// Add new album to firestor.
  /// Return true if success and false if fail.
  Future<bool> addAlbum(String albumId, String albumName) async {
    try {
      await albumsRef
          .document(albumId)
          .setData(Album(id: albumId, name: albumName).toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Fetch all albums from firestore.
  /// Return albums List.
  Future<List<Album>> fetchAllAlbums() async {
    try {
      final snapshot = await albumsRef.getDocuments();
      final albums =
          snapshot.documents.map((a) => Album.fromDocument(a)).toList();
      return albums;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Fetch album tracks from firestore.
  /// Return Tasks List.
  Future<List<Track>> fetchTracks(String albumId) async {
    try {
      final snapshot =
          await tracksRef.document(albumId).collection('tracks').getDocuments();
      final tracks =
          snapshot.documents.map((a) => Track.fromDocument(a)).toList();
      return tracks;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Add new track to album.
  /// Return true if success and false if fail.
  Future<bool> addTrack(
      {String albumId, String trackName, String trackId, File track}) async {
    try {
      // upload track to storage
      final trackUrl = await uploadTrack(track, trackId);
      if (trackUrl == null) {
        return false;
      }
      await tracksRef
          .document(albumId)
          .collection('tracks')
          .document(trackId)
          .setData(Track(
            id: trackId,
            trackName: trackName,
            trackUrl: trackUrl,
          ).toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// upload file to firestore
  Future<String> uploadTrack(File pickedAudio, String trackId) async {
    try {
      StorageUploadTask uploadTask =
          storageRef.child('track_$trackId.mp3').putFile(pickedAudio);

      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// delete track
  Future<bool> deleteTrack({String albumId, String trackId}) async {
    final doc = await tracksRef
        .document(albumId)
        .collection('tracks')
        .document(trackId)
        .get();
    if (doc.exists) {
      await doc.reference.delete();
      await storageRef.child('track_$trackId.mp3').delete();
      return true;
    } else {
      return false;
    }
  }

  /// delete Album
  Future<bool> deleteAlbum({String albumId}) async {
    final doc = await albumsRef.document(albumId).get();
    if (doc.exists) {
      await doc.reference.delete();
      await deleteAllAlbumTracks(albumId);
      return true;
    } else {
      return false;
    }
  }

  /// delete album tracks
  Future<void> deleteAllAlbumTracks(String albumId) async {
    await tracksRef
        .document(albumId)
        .collection('tracks')
        .getDocuments()
        .then((snapshot) => snapshot.documents.forEach((d) async {
              if (d.exists) {
                await d.reference.delete();
                await storageRef.child('track_${d.documentID}.mp3').delete();
              }
            }));
  }
}
