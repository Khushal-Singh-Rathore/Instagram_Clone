import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
// ------ from here ------
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    //  by this we are taking the reference of storage and where to upload photo with folder name and uid mention
    Reference reference =
        storage.ref().child(childName).child(auth.currentUser!.uid);

    if (isPost == true) {
      String id = Uuid().v1();
      reference = reference.child(id);
    }

// by this we able to upload the uint8list file to the reference storage
    UploadTask uploadTask = reference.putData(file);
    // ------- to here we wrote a code to upload a user profile photo ------

    // we can see the uploaded data by the TaskSnapshot
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
