import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String name;

  Album({this.id, this.name});
  factory Album.fromDocument(DocumentSnapshot doc) {
    return Album(
      id: doc['id'],
      name: doc['name'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> album = {};
    album['id'] = this.id;
    album['name'] = this.name;

    return album;
  }
}
