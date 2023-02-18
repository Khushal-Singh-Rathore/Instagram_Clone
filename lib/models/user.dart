import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String username;
  final String password;
  final String email;
  final String uid;
  final String fullname;
  final String photourl;
  final List following;
  final List followers;
  final String bio;

  User(
      {required this.username,
      required this.password,
      required this.email,
      required this.uid,
      required this.fullname,
      required this.followers,
      required this.following,
      required this.photourl,
      required this.bio});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'followers': followers,
        'username': username,
        'photourl': photourl,
        'password': password,
        'email': email,
        'following': following,
        'fullname': fullname,
        'bio': bio
      };

  static User fromSnap(DocumentSnapshot snap) {
    var Snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: Snapshot['username'],
      uid: Snapshot['uid'],
      followers: Snapshot['followers'],
      email: Snapshot['email'],
      following: Snapshot['following'],
      fullname: Snapshot['fullname'],
      password: Snapshot['password'],
      photourl: Snapshot['photourl'],
      bio: Snapshot['bio'],
    );
  }
}
