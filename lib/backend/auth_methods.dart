import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/backend/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // writing code for get user cred auto update on screen user provider
  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap =
        await fireStore.collection('user').doc(currentUser.uid).get();
    // model.User snapi() {
    //   var snapshot = snap.data() as Map<String, dynamic>;
    //   return model.User(
    //     username: snapshot['username'],
    //     uid: snapshot['uid'],
    //     followers: snapshot['followers'],
    //     email: snapshot['email'],
    //     following: snapshot['following'],
    //     fullname: snapshot['fullname'],
    //     password: snapshot['password'],
    //     photourl: snapshot['photourl'],
    //   );
    // }

    return model.User.fromSnap(snap);
    // return snapi();
  }

  // User Sign up
  // ignore: non_constant_identifier_names
  Future<String> SignupUser(
      {required String username,
      required String password,
      required String fullname,
      required String email,
      required Uint8List file,
      required String bio}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          fullname.isNotEmpty) {
        // geting user register
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);
        // uploading profile photo to storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('Profile Pic', file, false);
        // add user to our firestore database
        model.User user = model.User(
            username: username,
            password: password,
            email: email,
            followers: [],
            following: [],
            fullname: fullname,
            uid: cred.user!.uid,
            photourl: photoUrl,
            bio: bio);
        await fireStore
            .collection('user')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> LoginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
