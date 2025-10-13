import 'package:cloud_firestore/cloud_firestore.dart';

class SongsFirebase {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? songsCollection;

  SongsFirebase() {
    songsCollection = firebaseFirestore.collection("songs");
  }

  Future<void> insertSong(Map<String, dynamic> song) async {
    songsCollection!.doc().set(song);
  }

  Future<void> updateSong(Map<String, dynamic> song, String uid) async {
    songsCollection!.doc(uid).update(song);
  }

  Future<void> deleteSong(String uid) async {
    songsCollection!.doc(uid).delete();
  }

  Stream<QuerySnapshot> selectAllSongs() {
    return songsCollection!.snapshots();
  }
}
