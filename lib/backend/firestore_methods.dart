import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/backend/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
    String discription,
    Uint8List file,
    bool isPost,
    String profilePhoto,
    String uid,
    String username,
  ) async {
    String res = "some error accourd";
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('Post', file, true);

      String postid = const Uuid().v1();

      Post post = Post(
        datePublished: DateTime.now(),
        description: discription,
        postid: postid,
        posturl: postUrl,
        profilePhoto: profilePhoto,
        uid: uid,
        username: username,
        likes: [],
      );
      await firestore.collection('Post').doc(postid).set(post.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> LikePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('Post').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('Post').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> AddComment(String uid, String profilePhoto, String username,
      String comment, String postId) async {
    try {
      String CommentId = Uuid().v1();
      await firestore
          .collection('Post')
          .doc(postId)
          .collection('Comments')
          .doc(CommentId)
          .set({
        'uid': uid,
        'ProfilePhoto': profilePhoto,
        'username': username,
        'comment': comment,
        'postId': postId,
        'datePublished': DateTime.now()
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postid) async {
    try {
      await FirebaseFirestore.instance.collection('Post').doc(postid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await firestore.collection('user').doc(uid).get();
      List following = (snap.data() as dynamic)!['following'];
      if (following.contains(followId)) {
        await firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await firestore.collection('user').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await firestore.collection('user').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
