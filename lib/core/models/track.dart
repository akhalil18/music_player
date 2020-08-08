import 'package:cloud_firestore/cloud_firestore.dart';

class Track {
  final String id;
  final String trackName;
  final String trackUrl;

  Track({this.trackUrl, this.id, this.trackName});
  factory Track.fromDocument(DocumentSnapshot doc) {
    return Track(
      id: doc['id'],
      trackName: doc['trackName'],
      trackUrl: doc['trackUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> track = {};
    track['id'] = this.id;
    track['trackName'] = this.trackName;
    track['trackUrl'] = this.trackUrl;

    return track;
  }
}
