import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String description;
  final datePublished;
  final String profilePhoto;
  final String posturl;
  final String postid;
  final likes;

  Post({
    required this.uid,
    required this.username,
    required this.description,
    required this.datePublished,
    required this.profilePhoto,
    required this.posturl,
    required this.postid,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'description': description,
        'datePublished': datePublished,
        'profilePhoto': profilePhoto,
        'posturl': posturl,
        'postid': postid,
        'likes': likes
      };

  Post isSnap(DocumentSnapshot snap) {
    var Snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        uid: Snapshot['uid'],
        username: Snapshot['username'],
        description: Snapshot['description'],
        datePublished: Snapshot['datePublished'],
        likes: Snapshot['likes'],
        postid: Snapshot['postid'],
        posturl: Snapshot['posturl'],
        profilePhoto: Snapshot['profilePhoto']);
  }
}
